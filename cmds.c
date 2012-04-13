/***************************************************************************
* Name: cmd.c
* Desc: Receiving and transmitting queue handler
* Date: 2010-07-10
* Author: stanbaek
**************************************************************************/

#include "cmd.h"
#include "radio.h"
#include "dfmem.h"
#include "utils.h"
#include "ports.h"
#include "gyro.h"
#include "stopwatch.h"
#include "led.h"
#include "payload.h"
#include "ovcam.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>



// Commands
//
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
#define IM_COLS         160
#define IM_ROWS         100
#define IM_ROWS_START   0
#define IM_ROWS_QUANT   1
#define VID_ROWS        13
#define VID_COLS        18
#define VID_FRAMES      85
#define MEM_PAGES       100
#define MEM_PAGESIZE    528


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


union {
    struct {
        unsigned long timestamp[2];
        unsigned char gyro[3*sizeof(int)];
        unsigned int  bemf;
        unsigned char rows[IM_COLS];
    };
    unsigned char contents[176];
} data;




// use an array of function pointer to avoid a number of case statements
// MAX_CMD_FUNC_SIZE is defined in cmd_const.h
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

    

}

static void cmdRecordSensorDump(unsigned char status, unsigned char length, unsigned char *frame) {


    unsigned int count;
    unsigned long tic;
    const int kDataLength = 176;
    static unsigned char buf_index = 1;
    
    unsigned int mem_byte = 0;
    unsigned int mem_page = 0x0100;


    LED_RED = 1;

    count = frame[0] + (frame[1] << 8);

    swatchReset();
    tic = swatchTic();

    dfmemEraseSector(0x0100);
    dfmemEraseSector(0x0200);


    while (count) {
  
        ovcamGetRow(data.rows);
        data.timestamp[0] = swatchToc();
        gyroGetXYZ(data.gyro);
        data.timestamp[1] = swatchToc();
        
        dfmemWriteBuffer(data.contents, kDataLength, mem_byte, buf_index); 
        mem_byte += kDataLength;
        if (mem_byte + kDataLength > 528) { 
            dfmemWriteBuffer2MemoryNoErase(mem_page++, buf_index);
            mem_byte = 0;
            buf_index ^= 0x01;      // toggle buffer index between 0 and 1
        }

        delay_ms(2);

        count--;

    }

    LED_RED = 0;

}

static void cmdGetMemContents(unsigned char status, unsigned char length, unsigned char *frame) {

    unsigned int start_page = frame[0] + (frame[1] << 8);
    unsigned int end_page = frame[2] + (frame[3] << 8);
    unsigned int tx_data_size = frame[4] + (frame[5] << 8);
    unsigned int i, j;
    unsigned char count = 0;

    Payload pld;

    LED_BLUE = 0;
    LED_GREEN = 1;
    LED_RED = 0;
    
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
            LED_BLUE = ~LED_BLUE;
            LED_GREEN = ~LED_GREEN;
        }

        delay_ms(15);
    }

    // transmission is done !!
    LED_GREEN = 1; LED_RED = 1; LED_BLUE = 1;
    delay_ms(2000);
    LED_GREEN = 0; LED_RED = 0; LED_BLUE = 0;


}


static void cmdRunGyroCalib(unsigned char status, unsigned char length, unsigned char *frame) {

    unsigned int count = frame[0] + (frame[1] << 8);
    LED_BLUE = 1;
    LED_GREEN = 1;
    LED_RED = 0;
    gyroRunCalib(count);
    LED_BLUE = 0;
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


