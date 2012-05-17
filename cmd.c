/*
 * Copyright (c) 2010-2012, Regents of the University of California
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of the University of California, Berkeley nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * Command queue handlers
 *
 * by Stanley S. Baek
 *
 * v.beta
 *
 * Revisions:
 *  Stanley S. Baek                 2010-7-10   Initial release
 *  w/Fernando L. Garcia Bermudez   2011-3-8    Adaptation to fgb codebase
 *  Humphrey Hu                     2012        Adaptation to latest radio.
 *
 */

#include "cmd.h"
#include "motor_ctrl.h"
#include "led.h"
#include "sclock.h"

#include "payload.h"
#include "radio_settings.h"
#include "radio.h"

#include "dfmem.h"
#include "ovcam.h"
#include "cam.h"
#include "gyro.h"

//#include <stdio.h>
#include <string.h>
//#include <stdlib.h>


/* Commands */
#define CMD_SET_MOTOR_SPEED         0
#define CMD_RECORD_SENSOR_DUMP      4
#define CMD_GET_MEM_CONTENTS        5
#define CMD_RUN_GYRO_CALIB          0x0d
#define CMD_GET_GYRO_CALIB_PARAM    0x0e
#define MAX_CMD_FUNC_SIZE           0xFF

/* Camera */
#define IM_COLS                     160
#define IM_ROWS                     120
#define IM_ROWS_START               0
#define IM_ROWS_QUANT               1
#define VID_ROWS                    13
#define VID_COLS                    18
#define VID_FRAMES                  85

/* Memory */
#define MEM_PAGES                   100
#define MEM_PAGESIZE                528
#define MEM_DATAPOINT_SIZE          176


/*-----------------------------------------------------------------------------
 *          Private declarations
-----------------------------------------------------------------------------*/

void (*cmd_func[MAX_CMD_FUNC_SIZE])(unsigned char, unsigned char, unsigned char*);

// A datapoint is saved upon completion of a camera row capture.
//
// It contains:
//  sample  : datapoint number (starting from 0)
//  row     : serialized captured row data
//  row_num : physical row number (0 to IM_ROWS)
//  row_ts  : system time when row capture completes [ms]
//  gyro    : raw gyro values
//  gyro_ts : system time when gyro capture completes [ms]
//  bemf    : main motor Back-EMF reading
union {
    struct {
        unsigned int  sample;                   // (2)
        unsigned char row[IM_COLS];             // (160)
        unsigned int  row_num;                  // (2)
        unsigned int  row_ts;                   // (2)
        unsigned char gyro[3*sizeof(int)];      // (6)
        unsigned int  gyro_ts;                  // (2)
        unsigned int  bemf;                     // (2)
    };
    unsigned char contents[MEM_DATAPOINT_SIZE]; // (176)
} data;


/*----------------------------------------------------------------------------
 *          Declaration of private functions
 ---------------------------------------------------------------------------*/

static void cmdSetMotorSpeed(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdRecordSensorDump(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdGetMemContents(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdRunGyroCalib(unsigned char status, unsigned char length, unsigned char *frame);
static void cmdGetGyroCalibParam(unsigned char status, unsigned char length, unsigned char *frame);


/*-----------------------------------------------------------------------------
 *          Public functions
-----------------------------------------------------------------------------*/

void cmdSetup(void)
{
    unsigned int i;

    // initialize the array of func pointers with Nop()
    for(i = 0; i < MAX_CMD_FUNC_SIZE; ++i) {
        cmd_func[i] = NULL;
    }

    cmd_func[CMD_SET_MOTOR_SPEED] = &cmdSetMotorSpeed;
    cmd_func[CMD_RECORD_SENSOR_DUMP] = &cmdRecordSensorDump;
    cmd_func[CMD_GET_MEM_CONTENTS] = &cmdGetMemContents;
    cmd_func[CMD_RUN_GYRO_CALIB] = &cmdRunGyroCalib;
    cmd_func[CMD_GET_GYRO_CALIB_PARAM] = &cmdGetGyroCalibParam;
}

void cmdHandleRadioRxBuffer(void)
{
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
        radioReturnPacket(packet);
    }

    return;
}


/*-----------------------------------------------------------------------------
 *          Private functions
-----------------------------------------------------------------------------*/

static void cmdSetMotorSpeed(unsigned char status, unsigned char length, unsigned char *frame)
{
    unsigned char chr_test[4];
    float *duty_cycle = (float*)chr_test;

    chr_test[0] = frame[0];
    chr_test[1] = frame[1];
    chr_test[2] = frame[2];
    chr_test[3] = frame[3];

    // Update duty cycle - Main drive (PWM1L)
    mcSetDutyCycle(MC_CHANNEL_PWM1, *duty_cycle);
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

    // Dump sensor data to memory
    LED_ORANGE = 1;

    CamRow row_buff;

    next_sample_time = sclockGetGlobalMillis();
    do {

        if (sclockGetGlobalMillis() > next_sample_time) {

            // Capture sensor datapoint

            // OLD CODE
            //data.vsync[0] = OVCAM_VSYNC;
            //ovcamGetRow(data.rows);
            //data.vsync[1] = OVCAM_VSYNC;
            //data.ts = sclockGetGlobalMillis();
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
                data.row_ts = (unsigned int) (row_buff->timestamp & 0x00FF);
            } else {
                memset(data.row, 0, IM_COLS);
                data.row_ts = 0;
            }

            // Read gyro values
            gyroGetXYZ(data.gyro);
            data.gyro_ts = (unsigned int) (sclockGetGlobalMillis() & 0x00FF);
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

            next_sample_time = next_sample_time + 1;
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
            radioProcess();
            packet = radioRequestPacket(tx_data_size);
            if(packet == NULL) {
                continue;
            }
            macSetDestAddr(packet, DEST_ADDR);
            macSetDestPan(packet, PAN_ID);
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

    packet = radioRequestPacket(12);
    if(packet == NULL) { return; }
    macSetDestAddr(packet, DEST_ADDR);
    macSetDestPan(packet, PAN_ID);

    pld = macGetPayload(packet);
    paySetData(pld, 12, gyroGetCalibParam());
    paySetType(pld, CMD_GET_GYRO_CALIB_PARAM);
    paySetStatus(pld, 0);

    while(!radioEnqueueTxPacket(packet)) { radioProcess(); }
}
