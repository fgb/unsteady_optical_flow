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
#include "utils.h"
#include "sclock.h"

#include "payload.h"
#include "radio_settings.h"
#include "radio.h"

#include "dfmem.h"
#include "cam.h"
#include "gyro.h"

#include <string.h>


/* Commands */
#define CMD_SET_MOTOR_SPEED      0
#define CMD_RECORD_SENSOR_DUMP   4
#define CMD_GET_MEM_CONTENTS     5
#define CMD_RUN_GYRO_CALIB       0x0d
#define CMD_GET_GYRO_CALIB_PARAM 0x0e
#define MAX_CMD_FUNC_SIZE        0xFF

/* Capture Parameters */
#define IM_COLS                  152
#define SAMPLE_SIZE              176
#define MEM_PAGE_SIZE            528


/*-----------------------------------------------------------------------------
 *          Private declarations
-----------------------------------------------------------------------------*/

void (*cmd_func[MAX_CMD_FUNC_SIZE])(unsigned char, unsigned char,
                                    unsigned char*);

union {
    struct {
        unsigned int  id;                   // (2)   sample number
        unsigned long bemf_ts;              // (4)
        unsigned int  bemf;                 // (2)   main motor Back-EMF
        unsigned long gyro_ts;              // (4)
        unsigned char gyro[3*sizeof(int)];  // (6)   raw gyro values
        unsigned long row_ts;               // (4)
        unsigned char row_num;              // (1)   physical row number
        unsigned char row_valid;            // (1)   was row captured?
        unsigned char row[IM_COLS];         // (152) camera image row
    };
    unsigned char contents[SAMPLE_SIZE];    // (176) total
} sample;


/*----------------------------------------------------------------------------
 *          Declaration of private functions
 ---------------------------------------------------------------------------*/

static void cmdSetMotorSpeed(unsigned char status, unsigned char length,
                             unsigned char *frame);
static void cmdRecordSensorDump(unsigned char status, unsigned char length,
                                unsigned char *frame);
static void cmdGetMemContents(unsigned char status, unsigned char length,
                              unsigned char *frame);
static void cmdRunGyroCalib(unsigned char status, unsigned char length,
                            unsigned char *frame);
static void cmdGetGyroCalibParam(unsigned char status, unsigned char length,
                                 unsigned char *frame);


/*-----------------------------------------------------------------------------
 *          Public functions
-----------------------------------------------------------------------------*/

void cmdSetup(void)
{
    unsigned int i;

    for( i = 0; i < MAX_CMD_FUNC_SIZE; ++i ) cmd_func[i] = NULL;

    cmd_func[CMD_SET_MOTOR_SPEED]      = &cmdSetMotorSpeed;
    cmd_func[CMD_RECORD_SENSOR_DUMP]   = &cmdRecordSensorDump;
    cmd_func[CMD_GET_MEM_CONTENTS]     = &cmdGetMemContents;
    cmd_func[CMD_RUN_GYRO_CALIB]       = &cmdRunGyroCalib;
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

// Update duty cycle - Main drive (PWM1L)
static void cmdSetMotorSpeed(unsigned char status, unsigned char length,
                             unsigned char *frame)
{
    unsigned char chr_test[4];
    float *duty_cycle = (float*)chr_test;

    chr_test[0] = frame[0];
    chr_test[1] = frame[1];
    chr_test[2] = frame[2];
    chr_test[3] = frame[3];

    mcSetDutyCycle(MC_CHANNEL_PWM1, *duty_cycle);
}

static void cmdRecordSensorDump (unsigned char status, unsigned char length,
                                 unsigned char *frame)
{
    unsigned int  samples          = frame[0] + (frame[1] << 8),
                  count            = 0,
                  mem_byte         = 0,
                  mem_page         = 0x80,
                  mem_page_max     = mem_page + samples/3 + 0x80,
                  mem_sector       = mem_page,
                  millis_factor    = sclockGetMillisFactor();
    unsigned long next_sample_time = sclockGetLocalTicks();
    static unsigned char buffer    = 1;

    CamRow row_buff;

    // Erase as many memory sectors as needed
    // TODO (fgb) : adapt to any number of samples, not only mult of 3
    LED_GREEN = 0; LED_RED = 1; LED_ORANGE = 0;

    do
    {
        dfmemEraseSector(mem_sector);
        mem_sector += 0x80;
    } while (mem_sector < mem_page_max);

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;

    camStart(); // Enable camera capture interrupt

    // Dump sensor data to memory
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 1;

    do
    {
        if (sclockGetLocalTicks() > next_sample_time)
        {
            // Capture sensor sample
            if (camHasNewRow())                             // Camera
            {
                row_buff         = camGetRow();
                sample.row_ts    = row_buff->timestamp;
                sample.row_num   = (unsigned int) row_buff->row_num;
                sample.row_valid = 1;
                memcpy(sample.row, row_buff->pixels, IM_COLS);
            } else {
                sample.row_ts    = 0;
                sample.row_num   = 0xFF;
                sample.row_valid = 0;
                memset(sample.row, 0, IM_COLS);
            }

            sample.gyro_ts = sclockGetLocalTicks();         // Gyroscope
            gyroGetXYZ(sample.gyro);

            sample.bemf_ts = sclockGetLocalTicks();         // Back-EMF
            sample.bemf    = ADC1BUF0;

            sample.id      = count;                         // Sample #

            // Send sample to memory buffer
            dfmemWriteBuffer(sample.contents, SAMPLE_SIZE, mem_byte, buffer);
            mem_byte += SAMPLE_SIZE;

            // If buffer is about to overflow, write it to memory
            if ( mem_byte > (MEM_PAGE_SIZE - SAMPLE_SIZE) )
            {
                dfmemWriteBuffer2MemoryNoErase(mem_page++, buffer);
                buffer ^= 0x1;  // toggle between buffer 0 and 1
                mem_byte = 0;
            }

            // Stop motor while still sampling, to capture final glide/crash
            if ( count == samples/2 ) mcSetDutyCycle(MC_CHANNEL_PWM1, 0);

            next_sample_time += millis_factor; // 1 KHz sampling
            count++;
        }
    } while (count < samples);

    camStop(); // Disable camera capture interrupt

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdGetMemContents(unsigned char status, unsigned char length,
                              unsigned char *frame)
{
    unsigned int start_page = frame[0] + (frame[1] << 8),
                 end_page   = frame[2] + (frame[3] << 8),
                 pld_size   = frame[4] + (frame[5] << 8),
                 page, mem_byte;
    unsigned char count = 0;

    Payload pld;
    MacPacket packet;

    // Send back memory contents
    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 0;

    for ( page = start_page; page < end_page; ++page )
    {
        mem_byte = 0;
        do
        {
            radioProcess();
            packet = radioRequestPacket(pld_size);
            if(packet == NULL) { continue; }
            macSetDestPan(packet, PAN_ID);
            macSetDestAddr(packet, DEST_ADDR);
            pld = macGetPayload(packet);
            dfmemRead(page, mem_byte, pld_size, payGetData(pld));
            paySetStatus(pld, count++);
            paySetType(pld, CMD_GET_MEM_CONTENTS);
            while(!radioEnqueueTxPacket(packet)) { radioProcess(); }
            mem_byte += pld_size;
        } while ( mem_byte <= (MEM_PAGE_SIZE - pld_size) );

        if ((page >> 7) & 0x1)
        {
            LED_GREEN = ~LED_GREEN; LED_ORANGE = ~LED_ORANGE;
        }

        delay_ms(20);
    }

    LED_GREEN = 1; LED_RED = 1; LED_ORANGE = 1;
    delay_ms(2000);
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdRunGyroCalib(unsigned char status, unsigned char length,
                            unsigned char *frame)
{
    unsigned int count = frame[0] + (frame[1] << 8);

    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 1;

    gyroRunCalib(count);

    LED_GREEN = 0; LED_ORANGE = 0;
}

static void cmdGetGyroCalibParam(unsigned char status, unsigned char length,
                                 unsigned char *frame)
{
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
