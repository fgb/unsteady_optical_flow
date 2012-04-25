/*
 * Receiving and transmitting queue handler
 *
 * created on 2011-3-8 by stanbaek, fgb
 * modified by hhu for optical flow project
 * for use with hhu-lib code base
 */

//#include "init_default.h"
//#include "init.h"
//#include "interrupts.h"
#include "cmd.h"
#include "ports.h"
#include "led.h"
#include "utils.h"

#include "dfmem.h"
#include "ovcam.h"
#include "stopwatch.h"
#include "gyro.h"

//#include "pwm.h"
#include "motor_ctrl.h"

#include "radio.h"
#include "payload.h"
#include "cam.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


// Commands
#define MAX_CMD_FUNC_SIZE           0x11

#define CMD_SET_MOTOR_SPEED         0
#define CMD_GET_PICTURE             1
#define CMD_GET_VIDEO               2
#define CMD_GET_LINES               3
#define CMD_RECORD_SENSOR_DUMP      4
#define CMD_GET_MEM_CONTENTS        5

#define CMD_RUN_GYRO_CALIB          0x0d
#define CMD_GET_GYRO_CALIB_PARAM    0x0e
#define CMD_ECHO                    0x0f
#define CMD_RUN_RADIO_TEST          0x10

#define BASESTATION_ADDR            0x1020

/* Declarations */
#define IM_COLS                     160
#define IM_ROWS                     120
#define IM_ROWS_START               0
#define IM_ROWS_QUANT               1
#define VID_ROWS                    13
#define VID_COLS                    18
#define VID_FRAMES                  85
#define MEM_PAGES                   100
#define MEM_PAGESIZE                528

#define MEM_DATAPOINT_SIZE          176

/* A datapoint is saved upon completion of a camera row capture. It contains:
 *      sample - The datapoint number (starting from 0)
 *      timestamp - The system time in milliseconds corresponding to row capture completion
 *      bemf - The main motor back EMF reading
 *      gyro - Raw gyro values
 *      row_num - Physical row number (0 to IM_ROWS)
 *      row - Serialized captured row data
 */
 union {
    struct {                                    // Total: 176
        unsigned int  sample;                   // (2)
        unsigned int  bemf;                     // (2)
        unsigned char gyro[3*sizeof(int)];      // 2*3 = (6)
        unsigned int  gyro_timestamp;           // (2)
        unsigned int  row_num;                  // (2)
        unsigned int  row_timestamp;            // (2)
        unsigned char row[IM_COLS];             // IM_COLS = (160)
    };
    unsigned char contents[MEM_DATAPOINT_SIZE];
} data;

typedef union {
    float fval;
    unsigned long lval;
    short sval[2];
    unsigned char cval[4];
} uByte4;

typedef union {
    unsigned short sval;
    unsigned char cval[2];
} uByte2;

// use an array of function pointer to avoid a number of case statements
void (*cmd_func[MAX_CMD_FUNC_SIZE])(unsigned char, unsigned char, unsigned char*);


/*-----------------------------------------------------------------------------
 *          Declaration of static functions
-----------------------------------------------------------------------------*/
static void cmdNop(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdEcho(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdSetMotorSpeed(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdRecordSensorDump(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdGetMemContents(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdRunGyroCalib(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdGetGyroCalibParam(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdRunRadioTest(unsigned char status, unsigned char length, unsigned char *frame);

/*-----------------------------------------------------------------------------
 *          Public functions
-----------------------------------------------------------------------------*/
void cmdSetup(void) {

    unsigned int i;

    // initialize the array of func pointers with Nop()
    for(i = 0; i < MAX_CMD_FUNC_SIZE; ++i) {
        cmd_func[i] = &cmdNop;
    }

    cmd_func[CMD_ECHO] = &cmdEcho;
    cmd_func[CMD_SET_MOTOR_SPEED] = &cmdSetMotorSpeed;
    cmd_func[CMD_RECORD_SENSOR_DUMP] = &cmdRecordSensorDump;
    cmd_func[CMD_GET_MEM_CONTENTS] = &cmdGetMemContents;
    cmd_func[CMD_RUN_GYRO_CALIB] = &cmdRunGyroCalib;
    cmd_func[CMD_GET_GYRO_CALIB_PARAM] = &cmdGetGyroCalibParam;
    cmd_func[CMD_RUN_RADIO_TEST] = &cmdRunRadioTest;
}

void cmdHandleRadioRxBuffer(void) {

    MacPacket packet;
    Payload pld;
    unsigned char command, status;  

    if ((packet = radioDequeueRxPacket()) != NULL) {
        pld = macGetPayload(packet);
        status = payGetStatus(pld);
        command = payGetType(pld);      
        if(command < MAX_CMD_FUNC_SIZE) {
            cmd_func[command](status, payGetDataLength(pld), payGetData(pld));
        }
        radioReturnMacPacket(packet);
    } 

    return;
    
}


/*-----------------------------------------------------------------------------
 * ----------------------------------------------------------------------------
 * The functions below are intended for internal use, i.e., private methods.
 * Users are recommended to use functions defined above.
 * ----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/

static void cmdSetMotorSpeed(unsigned char status, unsigned char length, unsigned char *frame) {

    //while(!U2STAbits.URXDA);
    //argument = U2RXREG;

    unsigned char chr_test[4];
    float *duty_cycle = (float*)chr_test;

    chr_test[0] = frame[0];
    chr_test[1] = frame[1];
    chr_test[2] = frame[2];
    chr_test[3] = frame[3];
    
    // Update duty cycle - Main drive (PWM1L)    
    mcSetDutyCycle(MC_CHANNEL_PWM1, *duty_cycle);

    //while(U2STAbits.UTXBF);
    //U2TXREG = argument;
}

static void cmdRecordSensorDump(unsigned char status, unsigned char length, unsigned char *frame) {

    unsigned int samples = frame[0] + (frame[1] << 8), count = samples;
    unsigned long next_sample_time = 0; 
    
    unsigned int mem_byte = 0;
    unsigned int mem_page = 0x080, max_page = mem_page + samples/3 + 0x80, sector = mem_page;
    static unsigned char buf_index = 1;

    // Erase as many memory sectors as needed
    // TODO (fgb) : fix to adapt to any number of samples, not only multiples of 3
    LED_RED = 1;
    while (sector < max_page) {
        dfmemEraseSector(sector);
        sector += 0x80;
    }
    LED_RED = 0;

    // Reset and start stopwatch
    // swatchReset();
    // swatchTic();

    // Dump sensor data to memory
    LED_ORANGE = 1;
    
    CamRow row_buff;
    
    next_sample_time = swatchToc();
    do {
        
        if (swatchToc() > next_sample_time) {

            // Capture sensor datapoint
            // OLD CODE
            //data.vsync[0] = OVCAM_VSYNC;
            //ovcamGetRow(data.rows);
            //data.vsync[1] = OVCAM_VSYNC;
            //data.timestamp = swatchToc();
            //data.bemf = ADC1BUF0;
            //gyroGetXYZ(data.gyro);
            //data.sample = samples - count;

            // NEW CODE
            data.sample = samples - count;
            
            // Check if a row is available
            // If no new row is available, clear respective fields
            if(camHasNewRow()) {
                row_buff = camGetRow();
                memcpy(data.row, row_buff->pixels, IM_COLS); 
                data.row_num = row_buff->row_num;
                data.row_timestamp = (unsigned int) (row_buff->timestamp & 0x00FF);
            } else {
                memset(data.row, 0, IM_COLS);
                data.row_timestamp = 0;
            }
            
            // Read gyro values
            gyroGetXYZ(data.gyro);
            data.gyro_timestamp = (unsigned int) (swatchToc() & 0x00FF);
            data.bemf = ADC1BUF0;
            
            
            // Send datapoint to memory buffer
            dfmemWriteBuffer(data.contents, MEM_DATAPOINT_SIZE, mem_byte, buf_index);
            mem_byte += MEM_DATAPOINT_SIZE;

            // If buffer full, write it to memory 
            if (mem_byte + MEM_DATAPOINT_SIZE > MEM_PAGESIZE) { 
                dfmemWriteBuffer2MemoryNoErase(mem_page++, buf_index);
                buf_index ^= 0x01;  // toggle between buffer 0 and 1                
                mem_byte = 0; 
            }

            // Stop motor while still sampling, to capture final glide/crash            
            if (count == samples/2) { mcSetDutyCycle(MC_CHANNEL_PWM1, 0); }

            next_sample_time = next_sample_time + 1000;
            //delay_ms(2);
            count--;
        }
    } while (count);
    LED_ORANGE = 0;
}

static void cmdGetMemContents(unsigned char status, unsigned char length, unsigned char *frame) {

    unsigned int start_page = frame[0] + (frame[1] << 8);
    unsigned int end_page = frame[2] + (frame[3] << 8);
    unsigned int tx_data_size = frame[4] + (frame[5] << 8);
    unsigned int page, j;
    unsigned char count = 0;

    //// Send back memory details
    //while(U2STAbits.UTXBF);
    //U2TXREG = MEM_PAGES;
    //while(U2STAbits.UTXBF);
    //U2TXREG = sizeof(data);

    // Stopping motor in case it's still running
    mcSetDutyCycle(MC_CHANNEL_PWM1, 0);

    Payload pld;
    MacPacket packet;

    LED_ORANGE = 0;
    LED_GREEN = 1; // Signal start of transfer
    LED_RED = 0;

    // Send back memory contents
    for (page = start_page; page < end_page; ++page) {
        j = 0;
        while (j + tx_data_size <= 528) {
            packet = radioRequestMacPacket(tx_data_size);
            if(packet == NULL) {
                continue;
            }
            macSetDestAddr(packet, BASESTATION_ADDR);
            macSetDestPan(packet, 0x1001);
            pld = macGetPayload(packet);
            dfmemRead(page, j, tx_data_size, payGetData(pld));
            paySetStatus(pld, count++);
            paySetType(pld, CMD_GET_MEM_CONTENTS);
            while(!radioEnqueueTxPacket(packet)) {
                radioProcess();
            }
            j += tx_data_size;
        }

        if ((page >> 7) & 0x1) {
            LED_ORANGE = ~LED_ORANGE;
            LED_GREEN = ~LED_GREEN;
        }

        delay_ms(20);
    }

    // Signal end of transfer
    LED_GREEN = 1; LED_RED = 1; LED_ORANGE = 1;
    delay_ms(2000);
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdRunGyroCalib(unsigned char status, unsigned char length, unsigned char *frame) {

    unsigned int count = frame[0] + (frame[1] << 8);

    LED_ORANGE = 1;
    LED_GREEN = 1;
    LED_RED = 0;
    gyroRunCalib(count);
    LED_ORANGE = 0;
    LED_GREEN = 0;
}

static void cmdGetGyroCalibParam(unsigned char status, unsigned char length, unsigned char *frame) {
    Payload pld;
    MacPacket packet;

    packet = radioRequestMacPacket(12);
    if(packet == NULL) { return; }
    macSetDestAddr(packet, BASESTATION_ADDR);
    macSetDestPan(packet, 0x1001);
    
    pld = macGetPayload(packet);
    paySetData(pld, 12, gyroGetCalibParam());
    paySetType(pld, CMD_GET_GYRO_CALIB_PARAM);
    paySetStatus(pld, 0);

    while(!radioEnqueueTxPacket(packet)) { radioProcess(); }
}

static void cmdRunRadioTest(unsigned char status, unsigned char length, unsigned char *frame) {

    MacPacket packet;
    Payload pld;
    unsigned int i, num_runs, size;

    num_runs = *((unsigned int*) frame);
    size = *((unsigned int*) frame + 1);
    i = 0;
    while(i < num_runs) {

        radioProcess();
        packet = radioRequestMacPacket(size);
        if(packet == NULL) { continue; }

        macSetDestAddr(packet, BASESTATION_ADDR);
        macSetDestPan(packet, 0x1001);
        i++;

        pld = macGetPayload(packet);
        paySetType(pld, 0x10);
        paySetData(pld, 2, (unsigned char*)&i);
        while(!radioEnqueueTxPacket(packet)) { radioProcess(); }

    }

}

/*-----------------------------------------------------------------------------
 *          AUX functions
-----------------------------------------------------------------------------*/
static void cmdEcho(unsigned char status, unsigned char length, unsigned char *frame) {
    
    MacPacket packet;
    Payload pld;

    packet = radioRequestMacPacket(length);
    if(packet == NULL) { return; }
    macSetDestAddr(packet, BASESTATION_ADDR);
    macSetDestPan(packet, 0x1001);
    
    pld = macGetPayload(packet);
    paySetData(pld, length, frame);
    paySetType(pld, CMD_ECHO);
    paySetStatus(pld, status);

    while(!radioEnqueueTxPacket(packet)) { radioProcess(); }
    
}

static void cmdNop(unsigned char status, unsigned char length, unsigned char *frame) {
    Nop();
}
