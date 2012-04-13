/*
 * Receiving and transmitting queue handler
 *
 * created on 2011-3-8 by stanbaek, fgb
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

#include <stdio.h>
//#include <string.h>
//#include <stdlib.h>


// Commands
#define MAX_CMD_FUNC_SIZE           0x10

#define CMD_SET_MOTOR_SPEED         0
#define CMD_GET_PICTURE             1
#define CMD_GET_VIDEO               2
#define CMD_GET_LINES               3
#define CMD_RECORD_SENSOR_DUMP      4
#define CMD_GET_MEM_CONTENTS        5

#define CMD_RUN_GYRO_CALIB          0x0d
#define CMD_GET_GYRO_CALIB_PARAM    0x0e
#define CMD_ECHO                    0x0f

/* Declarations */
#define IM_COLS                     160
#define IM_ROWS                     100
#define IM_ROWS_START               0
#define IM_ROWS_QUANT               1
#define VID_ROWS                    13
#define VID_COLS                    18
#define VID_FRAMES                  85
#define MEM_PAGES                   100
#define MEM_PAGESIZE                528

#define MEM_DATAPOINT_SIZE          176
union {
    struct {
        unsigned int  sample;
        unsigned long timestamp;
        unsigned int  bemf;
        unsigned char gyro[3*sizeof(int)];        
        unsigned char vsync[2];        
        unsigned char rows[IM_ROWS_QUANT][IM_COLS];
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
}

void cmdHandleRadioRxBuffer(void) {

    Payload pld;
    unsigned char command, status;  

    if ((pld = radioGetRxPayload()) != NULL) {
        status = payGetStatus(pld);
        command = payGetType(pld);      
        cmd_func[command](status, payGetDataLength(pld), payGetData(pld));
        payDelete(pld);
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

    //// Send back image resolution
    //while(U2STAbits.UTXBF);
    //U2TXREG = IM_COLS;
    //while(U2STAbits.UTXBF);
    //U2TXREG = IM_ROWS_QUANT;
    //while(U2STAbits.UTXBF);
    //U2TXREG = sizeof(data.gyro);
    //while(U2STAbits.UTXBF);
    //U2TXREG = sizeof(data.timestamp);

    // Erase as many memory sectors as needed
    // TODO (fgb) : fix to adapt to any number of samples, not only multiples of 3
    LED_RED = 1;
    while (sector < max_page) {
        dfmemEraseSector(sector);
        sector += 0x80;
    }
    LED_RED = 0;

    // Reset and start stopwatch
    swatchReset();
    swatchTic();

    // Dump sensor data to memory
    LED_ORANGE = 1;
    do {
        if (swatchToc() > next_sample_time) {

            // Capture sensor datapoint
            data.vsync[0] = OVCAM_VSYNC;
            ovcamGetRow(data.rows);
            data.vsync[1] = OVCAM_VSYNC;
            data.timestamp = swatchToc();
            data.bemf = ADC1BUF0;
            gyroGetXYZ(data.gyro);
            data.sample = samples - count;

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

            next_sample_time = data.timestamp + 1000;
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
    unsigned int i, j;
    unsigned char count = 0;

    //// Send back memory details
    //while(U2STAbits.UTXBF);
    //U2TXREG = MEM_PAGES;
    //while(U2STAbits.UTXBF);
    //U2TXREG = sizeof(data);

    // Stopping motor in case it's still running
    mcSetDutyCycle(MC_CHANNEL_PWM1, 0);

    Payload pld;

    LED_ORANGE = 0;
    LED_GREEN = 1; // Signal start of transfer
    LED_RED = 0;

    // Send back memory contents
    for (i = start_page; i < end_page; ++i) {
        j = 0;
        while (j + tx_data_size <= 528) {
            pld = payCreateEmpty(tx_data_size);  
            dfmemRead(i, j, tx_data_size, payGetData(pld));
            paySetStatus(pld, count++);
            paySetType(pld, CMD_GET_MEM_CONTENTS);
            while(radioIsTxQueueFull());
            radioSendPayload(pld);
            j += tx_data_size;
        }

        if ((i >> 7) & 0x1) {
            LED_ORANGE = ~LED_ORANGE;
            LED_GREEN = ~LED_GREEN;
        }

        //delay_ms(25);
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
    radioSendPayload(payCreate(12, gyroGetCalibParam(), 0, CMD_GET_GYRO_CALIB_PARAM));
}


/*-----------------------------------------------------------------------------
 *          AUX functions
-----------------------------------------------------------------------------*/
static void cmdEcho(unsigned char status, unsigned char length, unsigned char *frame) {
    radioSendPayload(payCreate(length, frame, status, CMD_ECHO));
}

static void cmdNop(unsigned char status, unsigned char length, unsigned char *frame) {
    Nop();
}
