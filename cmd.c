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
#include "radio.h"
#include "at86rf231_driver.h"
#include "radio_settings.h"

#include "dfmem.h"
#include "cam.h"
#include "cambuff.h"
#include "gyro.h"

#include <string.h>


/* Commands */
#define CMD_MAX     0xFF

// TODO (fgb) : Should these be part of py-generated h file?
#define CMD_RESET                 0
#define CMD_ERASE_MEMORY          3
#define CMD_RECORD_SENSOR_DUMP    4
#define CMD_READ_MEMORY           5
#define CMD_GET_SETTINGS          6
#define CMD_SET_SAMPLING_PERIOD   7
#define CMD_SET_MEMORY_PAGE_START 8
#define CMD_SET_MOTOR_SPEED       9
#define CMD_CALIBRATE_GYRO        10

/* Default Settings */
#define DEFAULT_SAMPLING_PERIOD  1000 // [us]
#define DEFAULT_MEM_PAGE_START   128
#define DEFAULT_MOTOR_DUTY_CYCLE 0

#define DEFAULT_ROW_SIZE         152  // [bytes]
#define DEFAULT_MEM_PAGE_SIZE    528  // [bytes]
#define DEFAULT_MEM_SECTOR_SIZE  128  // [pages]


/*-----------------------------------------------------------------------------
 *          Private declarations
 *---------------------------------------------------------------------------*/

void (*cmd_func[CMD_MAX]) (unsigned char, unsigned char, unsigned char*);

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
        unsigned char row[DEFAULT_ROW_SIZE];// (152) camera image row
    };
    unsigned char contents[176];
} sample;

union {
    struct {
        unsigned int sampling_period;
        unsigned int mem_page_start;
        float        motor_duty_cycle;
    };
    unsigned char contents[2 * sizeof(unsigned int) + sizeof(float)];
} settings;


/*----------------------------------------------------------------------------
 *          Declaration of private functions
 *--------------------------------------------------------------------------*/

static void              cmdReset (unsigned char status,
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
static void      cmdSetMotorSpeed (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);
static void      cmdCalibrateGyro (unsigned char status,
                                   unsigned char length,
                                   unsigned char *frame);


/*-----------------------------------------------------------------------------
 *          Public functions
 *---------------------------------------------------------------------------*/

void cmdSetup (void)
{
    unsigned int i;

    for ( i = 0; i < CMD_MAX; ++i ) cmd_func[i] = NULL;

    cmd_func[CMD_RESET]                 = &cmdReset;
    cmd_func[CMD_ERASE_MEMORY]          = &cmdEraseMemory;
    cmd_func[CMD_RECORD_SENSOR_DUMP]    = &cmdRecordSensorDump;
    cmd_func[CMD_READ_MEMORY]           = &cmdReadMemory;
    cmd_func[CMD_GET_SETTINGS]          = &cmdGetSettings;
    cmd_func[CMD_SET_SAMPLING_PERIOD]   = &cmdSetSamplingPeriod;
    cmd_func[CMD_SET_MEMORY_PAGE_START] = &cmdSetMemoryPageStart;
    cmd_func[CMD_SET_MOTOR_SPEED]       = &cmdSetMotorSpeed;
    cmd_func[CMD_CALIBRATE_GYRO]        = &cmdCalibrateGyro;
}

void cmdResetSettings (void)
{
    settings.sampling_period  = DEFAULT_SAMPLING_PERIOD;
    settings.mem_page_start   = DEFAULT_MEM_PAGE_START;
    settings.motor_duty_cycle = DEFAULT_MOTOR_DUTY_CYCLE;
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

        if ( command < CMD_MAX )
        {
            cmd_func[command](status, payGetDataLength(pld), payGetData(pld));
        }

        radioReturnPacket(packet);
    }
}


/*-----------------------------------------------------------------------------
 *          Private functions
 *---------------------------------------------------------------------------*/

static void cmdReset (unsigned char status,
                      unsigned char length,
                      unsigned char *frame)
{
    asm volatile("reset");
}

static void cmdEraseMemory (unsigned char status,
                            unsigned char length,
                            unsigned char *frame)
{
    unsigned int  samples       = frame[0] + (frame[1] << 8),
                  mem_page      = settings.mem_page_start,
                  mem_page_last = settings.mem_page_start + samples/3;

    LED_GREEN = 0; LED_RED = 1; LED_ORANGE = 0;

    do
    {
        dfmemEraseSector(mem_page);
        mem_page += DEFAULT_MEM_SECTOR_SIZE;
    } while ( mem_page < mem_page_last );

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdRecordSensorDump (unsigned char status,
                                 unsigned char length,
                                 unsigned char *frame)
{
    unsigned int  samples          = frame[0] + (frame[1] << 8),
                  sample_motor_on  = frame[1] + (frame[2] << 8),
                  sample_motor_off = frame[3] + (frame[4] << 8),
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
                sample.row_num   = (unsigned char) row_buff->row_num;
                sample.row_valid = 1;
                memcpy ( sample.row, row_buff->pixels, DEFAULT_ROW_SIZE );
                cambuffReturnRow(row_buff);
            } else {
                sample.row_ts    = 0;
                sample.row_num   = 0;
                sample.row_valid = 0;
                memset ( sample.row, 0, DEFAULT_ROW_SIZE );
            }

            sample.gyro_ts = sclockGetTime();               // Gyroscope
            gyroGetXYZ(sample.gyro);

            sample.bemf_ts = sclockGetTime();               // Back-EMF
            sample.bemf    = ADC1BUF0;

            sample.id      = count++;                       // Sample #

            // Send sample to memory buffer
            dfmemWriteBuffer(sample.contents, sizeof(sample), mem_byte, buffer);
            mem_byte += sizeof(sample);

            // If buffer is about to overflow, write it to memory
            if ( mem_byte > (DEFAULT_MEM_PAGE_SIZE - sizeof(sample)) )
            {
                dfmemWriteBuffer2MemoryNoErase ( mem_page++, buffer );
                buffer  ^= 0x1;  // toggle between buffer 0 and 1
                mem_byte = 0;
            }

            // Control motor during sampling
            if ( count == sample_motor_on )
            {
                mcSetDutyCycle(MC_CHANNEL_PWM1, settings.motor_duty_cycle);
            } else if ( count == sample_motor_off ) {
                mcSetDutyCycle(MC_CHANNEL_PWM1, 0);
            }

            next_sample_time += settings.sampling_period;
        }
    } while (count < samples);

    camStop(); // Disable camera capture interrupt

    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdReadMemory (unsigned char status,
                           unsigned char length,
                           unsigned char *frame)
{
    unsigned int samples       = frame[0] + (frame[1] << 8),
                 pld_size      = frame[2] + (frame[3] << 8),
                 mem_byte      = 0,
                 mem_page      = settings.mem_page_start,
                 mem_page_last = settings.mem_page_start + samples/3;
    unsigned char count = 0;

    MacPacket packet;
    Payload pld;

    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 0;

    do
    {
        do
        {
            radioProcess();
            packet = radioRequestPacket(pld_size);
            if ( packet == NULL ) continue;
            macSetDestPan(packet, PAN_ID);
            macSetDestAddr(packet, DEST_ADDR);

            pld = macGetPayload(packet);
            dfmemRead ( mem_page, mem_byte, pld_size, payGetData(pld) );
            paySetStatus(pld, count++);
            paySetType(pld, CMD_READ_MEMORY);

            while ( !radioEnqueueTxPacket(packet) ) radioProcess();
            //while ( trxGetLastACKd() )              radioProcess();

            mem_byte += pld_size;

        } while ( mem_byte <= (DEFAULT_MEM_PAGE_SIZE - pld_size) );

        mem_page++;
        mem_byte = 0;

        if ( mem_page & DEFAULT_MEM_SECTOR_SIZE ) LED_GREEN = ~LED_GREEN;

    } while ( mem_page < mem_page_last );

    LED_GREEN = 1; LED_RED = 1; LED_ORANGE = 1;
    delay_ms(2000);
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;
}

static void cmdGetSettings (unsigned char status,
                            unsigned char length,
                            unsigned char *frame)
{
    radioSendData(DEST_ADDR, 0, CMD_GET_SETTINGS,
                    sizeof(settings), settings.contents, RADIO_DATA_SAFE);
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

static void cmdSetMotorSpeed (unsigned char status,
                              unsigned char length,
                              unsigned char *frame)
{
    // TODO (fgb) : Simplify extraction of frame
    unsigned char dc_chr[4];
    float *duty_cycle = (float *) dc_chr;

    dc_chr[0] = frame[0];
    dc_chr[1] = frame[1];
    dc_chr[2] = frame[2];
    dc_chr[3] = frame[3];

    settings.motor_duty_cycle = *duty_cycle;
}

static void cmdCalibrateGyro (unsigned char status,
                              unsigned char length,
                              unsigned char *frame)
{
    LED_GREEN = 1; LED_RED = 0; LED_ORANGE = 1;

    gyroRunCalib(2000);

    radioSendData(DEST_ADDR, 0, CMD_CALIBRATE_GYRO,
                    3*sizeof(float), gyroGetCalibParam(), RADIO_DATA_SAFE);

    LED_GREEN = 0; LED_ORANGE = 0;
}
