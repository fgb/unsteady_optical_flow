/*
 * Copyright (c) 2010-2013, Regents of the University of California
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
 * by Stanley S. Baek and Fernando L. Garcia Bermudez
 *
 * v.beta
 *
 * Revisions:
 *  Stanley S. Baek                 2010-7-10   Initial release.
 *  w/Fernando L. Garcia Bermudez   2011-3-8    Adaptation to fgb codebase.
 *  Humphrey Hu                     2012-4-13   Adaptation to latest radio.
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
#include "cam.h"
#include "cambuff.h"
#include "gyro.h"

#include <string.h>


/* Commands */
#define CMD_SET_MOTOR_SPEED       0
#define CMD_ERASE_MEMORY          3
#define CMD_RECORD_SENSOR_DUMP    4
#define CMD_READ_MEMORY           5
#define CMD_GET_SETTINGS          6
#define CMD_SET_SAMPLING_PERIOD   7
#define CMD_SET_MEMORY_PAGE_START 8
#define CMD_CALIBRATE_GYRO        0x0d
#define CMD_GET_GYRO_CALIBRATION  0x0e
#define MAX_NUM_COMMANDS          0xFF

/* Capture Parameters */
#define ROW_SIZE        152  // [bytes]
#define MEM_PAGE_SIZE   528  // [bytes]
#define MEM_SECTOR_SIZE 128  // [pages]


/*-----------------------------------------------------------------------------
 *          Private declarations
 ----------------------------------------------------------------------------*/

void (*cmd_func[MAX_NUM_COMMANDS])(unsigned char,
                                   unsigned char,
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
        unsigned char row[ROW_SIZE];        // (152) camera image row
    };
    unsigned char contents[176];
} sample;

struct {
    unsigned int sampling_period;
    unsigned int mem_page_start;
} settings;


/*----------------------------------------------------------------------------
 *          Declaration of private functions
 ---------------------------------------------------------------------------*/

static void      cmdSetMotorSpeed (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void        cmdEraseMemory (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void   cmdRecordSensorDump (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void         cmdReadMemory (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void        cmdGetSettings (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void  cmdSetSamplingPeriod (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void cmdSetMemoryPageStart (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void      cmdCalibrateGyro (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void cmdGetGyroCalibration (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);


/*-----------------------------------------------------------------------------
 *          Public functions
 ----------------------------------------------------------------------------*/

void cmdSetup (void)
{
    unsigned int i;

    for ( i = 0; i < MAX_NUM_COMMANDS; ++i ) cmd_func[i] = NULL;

    cmd_func[CMD_SET_MOTOR_SPEED]       = &cmdSetMotorSpeed;
    cmd_func[CMD_ERASE_MEMORY]          = &cmdEraseMemory;
    cmd_func[CMD_RECORD_SENSOR_DUMP]    = &cmdRecordSensorDump;
    cmd_func[CMD_READ_MEMORY]           = &cmdReadMemory;
    cmd_func[CMD_GET_SETTINGS]          = &cmdGetSettings;
    cmd_func[CMD_SET_SAMPLING_PERIOD]   = &cmdSetSamplingPeriod;
    cmd_func[CMD_SET_MEMORY_PAGE_START] = &cmdSetMemoryPageStart;
    cmd_func[CMD_CALIBRATE_GYRO]        = &cmdCalibrateGyro;
    cmd_func[CMD_GET_GYRO_CALIBRATION]  = &cmdGetGyroCalibration;
}

void cmdHandleRadioRxBuffer (void)
{
    MacPacket packet;
    Payload pld;
    unsigned char command, status;

    if ( (packet = radioDequeueRxPacket()) != NULL )
    {
        pld     = macGetPayload(packet);
        status  = payGetStatus(pld);
        command = payGetType(pld);

        if ( command < MAX_NUM_COMMANDS )
        {
            cmd_func[command](status, payGetDataLength(pld), payGetData(pld));
        }

        radioReturnPacket(packet);
    }
}


/*-----------------------------------------------------------------------------
 *          Private functions
-----------------------------------------------------------------------------*/

static void cmdSetMotorSpeed (unsigned char status,
                              unsigned char length,
                              unsigned char *frame)
{
    unsigned char dc_chr[4];
    float *duty_cycle = (float*)dc_chr;

    dc_chr[0] = frame[0];
    dc_chr[1] = frame[1];
    dc_chr[2] = frame[2];
    dc_chr[3] = frame[3];

    mcSetDutyCycle(MC_CHANNEL_PWM1, *duty_cycle);
}

static void cmdEraseMemory (unsigned char status,
                            unsigned char length,
                            unsigned char *frame)
{
    // TODO (fgb) : Adapt to any number of samples, not only mult of 3
    unsigned int  samples      = frame[0] + (frame[1] << 8),
                  mem_page     = settings.mem_page_start,
                  mem_page_max = mem_page + samples/3 + MEM_SECTOR_SIZE;

    // Erase as many memory sectors as needed
    LED_GREEN = 0; LED_RED = 1; LED_ORANGE = 0;

    do
    {
        dfmemEraseSector(mem_page);
        mem_page += MEM_SECTOR_SIZE;
    } while (mem_page < mem_page_max);

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdRecordSensorDump (unsigned char status,
                                 unsigned char length,
                                 unsigned char *frame)
{
    unsigned int  samples          = frame[0] + (frame[1] << 8),
                  count            = 0,
                  mem_byte         = 0,
                  mem_page         = settings.mem_page_start;
    unsigned long next_sample_time = sclockGetTime();
    static unsigned char buffer    = 1;
    CamRow row_buff;

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 1;

    camStart(); // Enable camera capture interrupt

    do
    {
        if ( sclockGetTime() > next_sample_time )
        {
            // Capture sensor sample
            if ( cambuffHasNewRow() )                       // Camera
            {
                row_buff         = cambuffGetRow();
                sample.row_ts    = row_buff->timestamp;
                sample.row_num   = (unsigned int) row_buff->row_num;
                sample.row_valid = 1;
                memcpy ( sample.row, row_buff->pixels, ROW_SIZE );
                cambuffReturnRow(row_buff);
            } else {
                sample.row_ts    = 0;
                sample.row_num   = 0xFF;
                sample.row_valid = 0;
                memset(sample.row, 0, ROW_SIZE);
            }

            sample.gyro_ts = sclockGetTime();               // Gyroscope
            gyroGetXYZ(sample.gyro);

            sample.bemf_ts = sclockGetTime();               // Back-EMF
            sample.bemf    = ADC1BUF0;

            sample.id      = count;                         // Sample #

            // Send sample to memory buffer
            dfmemWriteBuffer ( sample.contents, sizeof(sample), mem_byte, buffer );
            mem_byte += sizeof(sample);

            // If buffer is about to overflow, write it to memory
            if ( mem_byte > (MEM_PAGE_SIZE - sizeof(sample)) )
            {
                dfmemWriteBuffer2MemoryNoErase ( mem_page++, buffer );
                buffer ^= 0x1;  // toggle between buffer 0 and 1
                mem_byte = 0;
            }

            // Stop motor while still sampling, to capture final glide/crash
            if ( count == samples/2 ) mcSetDutyCycle(MC_CHANNEL_PWM1, 0);

            next_sample_time += settings.sampling_period;
            count++;
        }
    } while (count < samples);

    camStop(); // Disable camera capture interrupt

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdReadMemory (unsigned char status,
                           unsigned char length,
                           unsigned char *frame)
{
    unsigned int samples  = frame[0] + (frame[1] << 8),
                 pld_size = frame[2] + (frame[3] << 8),
                 page, mem_byte;
    unsigned char count = 0;

    MacPacket packet;
    Payload pld;

    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 0;

    for ( page = settings.mem_page_start;
            page < (settings.mem_page_start + samples/3); ++page )
    {
        mem_byte = 0;
        do
        {
            radioProcess();
            packet = radioRequestPacket(pld_size);
            if(packet == NULL) continue;
            macSetDestPan(packet, PAN_ID);
            macSetDestAddr(packet, DEST_ADDR);

            pld = macGetPayload(packet);
            dfmemRead(page, mem_byte, pld_size, payGetData(pld));
            paySetStatus(pld, count++);
            paySetType(pld, CMD_READ_MEMORY);

            while ( !radioEnqueueTxPacket(packet) ) radioProcess();

            mem_byte += pld_size;

        } while ( mem_byte <= (MEM_PAGE_SIZE - pld_size) );

        if ( (page >> 7) & 0x1 ) LED_GREEN = ~LED_GREEN;

    }

    LED_GREEN = 1; LED_RED = 1; LED_ORANGE = 1;
    delay_ms(2000);
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdGetSettings (unsigned char status,
                            unsigned char length,
                            unsigned char *frame)
{
    unsigned int settings_data[] = {settings.sampling_period,
                                    sizeof(sample),
                                    ROW_SIZE,
                                    MEM_PAGE_SIZE,
                                    MEM_SECTOR_SIZE,
                                    settings.mem_page_start};
    unsigned char *chr_settings_data = (unsigned char *) settings_data;

    radioSendData(DEST_ADDR, 0, CMD_GET_SETTINGS,
                    sizeof(settings_data), chr_settings_data, RADIO_DATA_SAFE);
}

static void  cmdSetSamplingPeriod (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame)
{
    settings.sampling_period = frame[0] + (frame[1] << 8);
}

static void  cmdSetMemoryPageStart (unsigned char status,
                                    unsigned char length,
                                    unsigned char *frame)
{
    settings.mem_page_start = frame[0] + (frame[1] << 8);
}

static void cmdCalibrateGyro (unsigned char status,
                              unsigned char length,
                              unsigned char *frame)
{
    unsigned int count = frame[0] + (frame[1] << 8);

    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 1;

    gyroRunCalib(count);

    LED_GREEN = 0; LED_ORANGE = 0;
}

static void cmdGetGyroCalibration (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame)
{
    radioSendData(DEST_ADDR, 0, CMD_GET_GYRO_CALIBRATION,
                    12, gyroGetCalibParam(), RADIO_DATA_SAFE);
}
