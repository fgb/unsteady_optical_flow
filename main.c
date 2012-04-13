/*
 * Copyright (c) 2007-2010, Regents of the University of California
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
 * Image processing and control of an unsteadily moving robotic platform
 *
 * by Fernando L. Garcia Bermudez
 *
 * v.beta
 *
 * Revisions:
 *  Fernando L. Garcia Bermudez     2007-8-8    Initial release
 *
 */

#include "init_default.h"
#include "init.h"
#include "interrupts.h"
#include "utils.h"

#include "dfmem.h"
#include "ovcam.h"
#include "stopwatch.h"
#include "gyro.h"

#include "pwm.h"


// Commands
#define CMD_SET_MOTOR_SPEED     0
#define CMD_GET_PICTURE         1
#define CMD_GET_VIDEO           2
#define CMD_GET_LINES           3
#define CMD_RECORD_SENSOR_DUMP  4
#define CMD_GET_MEM_CONTENTS    5


int main ( void )
{

    /* Initialization */
    SetupClock();
    SetupPorts();
    SetupInterrupts();
    SetupUART();
    SetupPWM();
    //SetupDMA();
    SetupADC();
    SwitchClocks();
    swatchSetup();
    //gyroSetup(); // UART2 & I2C2 shouldn't run concurrently
    dfmemSetup();
    ovcamSetup();
    LED_1 = 1;


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

    unsigned int  i, j, pagecnt; //rowcnt, imcnt,
    unsigned long next_sample_time = 0;
    unsigned char command, argument, buffer;

    union {
        struct {
            unsigned char rows[IM_ROWS_QUANT][IM_COLS];
            unsigned char gyro[3*sizeof(int)];
            unsigned int  bemf;
            unsigned long timestamp[2];
        };
        unsigned char contents[176];
    } data;


    /* Program */
    while(1){
                      
        // Wait for next command
        while(!U2STAbits.URXDA);
        command = U2RXREG;

        switch(command) {

            case CMD_SET_MOTOR_SPEED:       // Update duty cycle - Main drive (PWM1L)

                while(!U2STAbits.URXDA);
                argument = U2RXREG;

                SetDCMCPWM(1, (unsigned int)(2.0 * argument/100.0 * PTPER), 0);                

                //// Sense bEMF only if motor instructed to run
                //if (argument > 0) {
                //    _ADON = 1;
                //} else if (argument == 0) {
                //    _ADON = 0;
                //    _CHEN = 0; _CHEN = 1; // Reset DMA for one-shot operation once ADC1 turns on
                //}
                //
                //SetDCMCPWM(2, (unsigned int)(2.0 * argument/100.0 * PTPER), 0);
                
                while(U2STAbits.UTXBF);
                U2TXREG = argument;

                break;


            case CMD_RECORD_SENSOR_DUMP:       // Dump sensor data to memory

                // Send back image resolution
                while(U2STAbits.UTXBF);
                U2TXREG = IM_COLS;
                while(U2STAbits.UTXBF);
                U2TXREG = IM_ROWS_QUANT;
                while(U2STAbits.UTXBF);
                U2TXREG = sizeof(data.gyro);
                while(U2STAbits.UTXBF);
                U2TXREG = sizeof(data.timestamp);

                // Reset memory chip
                dfmemEraseSector(0); // pages 0-7
                dfmemEraseSector(8); // pages 8 - 255
                buffer = 1;

                // Disabling UART2 to enable I2C2
                U2MODEbits.UARTEN = 0;
                LED_1 = 0; LED_2 = 1;
                for (i=0; i<1000; i++) { delay_us(5 * 1000); }
                LED_2 = 0; LED_1 = 1;
                gyroSetup();

                // Reset stopwatch
                swatchReset();
                swatchTic();

                ovcamWaitForNewFrame();
                
                pagecnt = 0;
                while(pagecnt < MEM_PAGES) {
        
                    if (swatchToc() > next_sample_time) {

                        LED_1 = 0; // Signal start of capture

                        data.timestamp[1] = swatchToc();

                        if (OVCAM_VSYNC) {
                            ovcamGetRow(data.rows);
                        } else {
                            for (i=0; i<IM_ROWS_QUANT; i++) {
                                for (j=0; j<IM_COLS; j++) {
                                    data.rows[i][j] = 0;
                                }
                            }
                        }

                        data.bemf = ADC1BUF0;
                        data.timestamp[0] = swatchToc();
                        gyroGetXYZ(data.gyro);

                        LED_1 = 1; // Signal end of capture

                        dfmemWriteBuffer(data.contents, sizeof(data), 0, buffer);
                        dfmemWriteBuffer2MemoryNoErase(pagecnt, buffer);
                        //dfmemWrite(data.contents, sizeof(data), pagecnt, 0, buffer);
                        buffer = ~buffer;

                        next_sample_time = data.timestamp[1] + 10000;
                        pagecnt++;

                    }

                }

                // Disabling I2C2 to enable UART2
                I2C2CONbits.I2CEN = 0;
                SetupUART(); 

                break;


            case CMD_GET_MEM_CONTENTS:       // Send memory contents

                // Send back memory details
                while(U2STAbits.UTXBF);
                U2TXREG = MEM_PAGES;
                while(U2STAbits.UTXBF);
                U2TXREG = sizeof(data);

                LED_2 = 1; // Signal start of transfer

                // Send back memory contents
                for (pagecnt = 0; pagecnt < MEM_PAGES; pagecnt++) 
                {
                    dfmemRead(pagecnt, 0, sizeof(data), data.contents);
    
                    for (i = 0; i < sizeof(data); i++)
                    {
                        while(U2STAbits.UTXBF);
                        U2TXREG = data.contents[i];
                    }
                }

                LED_2 = 0; // Signal end of transfer
    
                break;


/*            case CMD_GET_LINES:        // Take a video sequence of crossing lines

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();
                for (i=0; i<1000; i++) { delay_us(argument * 1000); }

                unsigned char rows[VIDFRAMES][IMCOLS], cols[VIDFRAMES][IMROWS];
                unsigned int adcbuffer[VIDFRAMES][IMROWS];

                imcnt = 0;
                while(imcnt < VIDFRAMES) {

                    // Throw out frame fraction
                    while(OVCAM_VSYNC);
                    while(!OVCAM_VSYNC);

                    // Signal start of frame capture
                    _LATD11 = 1;

                    // Capture image rows
                    rowcnt = 0;
                    while(rowcnt < IMROWS) {
                        
                        // Get either just the middle pixel or the full middle row
                        if (rowcnt != 59) {
                             
                            ovcamGetRow(row);
                            cols[imcnt][rowcnt] = row[79];

                        } else {

                            ovcamGetRow(rows[imcnt]);
                            cols[imcnt][rowcnt] = rows[imcnt][79];

                        }

                        // Get backEMF at every row of the image
                        adcbuffer[imcnt][rowcnt] = ReadADC1(0);
 
                        rowcnt++;
                    }

                    // Signal end of frame capture
                    _LATD11 = 0;
    
                    imcnt++;
                }
    
                // Send rows off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<IMCOLS; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2(rows[j][i]);
                    }
                }

                // Send columns off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<IMROWS; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2(cols[j][i]);
                    }
                }

                // Send backEMF measurements off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<IMROWS; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(((adcbuffer[j][i] >> 5) & 0x001F) | 0x0080));
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(adcbuffer[j][i] & 0x001F));
                    }
                }
                while(U2STAbits.UTXBF);
                WriteUART2(0x0060);
    
                break; */


/*            case CMD_GET_VIDEO:          // Take a video sequence (IMROWS = 60)

                unsigned char buffer[IMROWS][VIDCOLS], video[VIDFRAMES][VIDROWS][VIDCOLS];
                unsigned int adcbuffer[VIDFRAMES][IMROWS];

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();
                for (i=0; i<1000; i++) { delay_us(argument * 1000); }
    
                imcnt = 0;
                while(imcnt < VIDFRAMES) {

                    // Throw out frame fraction
                    while(OVCAM_VSYNC);
                    while(!OVCAM_VSYNC);

                    // Signal start of frame capture
                    _LATD11 = 1;

                    // Capture every other image row
                    rowcnt = 0;
                    while(rowcnt < IMROWS) {
                        
                        ovcamGetRow(row);

                        // Subsample rows 3 times
                        for (i=0; i<78; i++) {
                            row[i] = convStep(row[2*i+1], row[2*i+2], row[2*i+3]);
                        }
                        for (i=0; i<38; i++) {
                            row[i] = convStep(row[2*i], row[2*i+1], row[2*i+2]);
                        }
                        for (i=0; i<VIDCOLS; i++) {
                            buffer[rowcnt][i] = convStep(row[2*i], row[2*i+1], row[2*i+2]);
                        }
                        
                        // Get backEMF at every row of the image
                        adcbuffer[imcnt][rowcnt] = ReadADC1(0);
 
                        rowcnt++;
                    }

                    // Signal end of frame capture
                    _LATD11 = 0;
    
                    // Subsample columns 2 times (because of every other row capture)
                    for (i=0; i<VIDCOLS; i++) {
                        for (j=0; j<28; j++) {
                            buffer[j][i] = convStep(buffer[2*j+1][i], buffer[2*j+2][i], buffer[2*j+3][i]);
                        }
                        for (j=0; j<VIDROWS; j++) {
                            video[imcnt][j][i] = convStep(buffer[2*j][i], buffer[2*j+1][i], buffer[2*j+2][i]);
                        }
                    }
    
                    imcnt++;
                }
    
                // Send video off-board
                for (k=0; k<VIDFRAMES; k++) {
                    for (j=0; j<VIDROWS; j++) {
                        for (i=0; i<VIDCOLS; i++) {
                            while(U2STAbits.UTXBF);
                            WriteUART2(video[k][j][i]);
                        }
                    }
                }

                // Send backEMF measurements off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<IMROWS; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(((adcbuffer[j][i] >> 5) & 0x001F) | 0x0080));
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(adcbuffer[j][i] & 0x001F));
                    }
                }
                while(U2STAbits.UTXBF);
                WriteUART2(0x0060);
    
                break;*/


/*             case CMD_GET_PICTURE:           // Take a 160x100 picture (IMROWS = 100)

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();

                unsigned char image[IMROWS][IMCOLS];
  
                for (i=0; i<1000; i++) { delay_us(argument * 1000); }
  
                // Throw out frame fraction
                while(OVCAM_VSYNC);
                while(!OVCAM_VSYNC);
  
                // Send rows to RAM
                rowcnt = 0;
                while(rowcnt < IMROWS) {
                    ovcamGetRow(image[rowcnt]);
                    rowcnt++;
                }
  
                // Send the captured image off-board
                for (i=0; i<IMROWS; i++) {
                    for (j=0; j<IMCOLS; j++) {
                        WriteUART2(image[i][j]);
                        while(BusyUART2());
                    }
                }
  
                break;*/

            }
    }

    return 0;
}
