/*
 * Image processing and control of an unsteadily moving robotic platform 
 *
 * Created on 2007-8-8 by fgb, AMH
 */

#include "init.h"

int main ( void )
{

    /* Initialization */
    SetupClock();
    SetupPorts();
    SetupInterrupts();
    SetupUART();
    SetupI2C();
    SetupPWM();
    SetupDMA();
    SetupADC();
    SwitchClocks();
    SetupCamera();


    /* Declarations */
    #define IMCOLS 160
    #define IMROWS 60
    #define IMROWSTART 59
    #define IMROWQUANT 1
    #define VIDROWS 13
    #define VIDCOLS 18
    #define VIDFRAMES 85

    unsigned int i, j, rowcnt, imcnt; // k
    unsigned char command, argument; //, row[IMCOLS];


    /* Program */
    while(1){
    
        // Wait for next command
        while(!DataRdyUART2());
        command = ReadUART2();
        
        switch(command) {

            case RECV_MOTOR_CMD:        // Update duty cycle - Main drive (PWM2L)

                while(!DataRdyUART2());
                argument = ReadUART2();

                // Sense bEMF only if motor instructed to run
                if (argument > 0) {
                    _ADON = 1;
                } else if (argument == 0) {
                    _ADON = 0;
                    _CHEN = 0; _CHEN = 1; // Reset DMA for one-shot operation once ADC1 turns on
                }

                SetDCMCPWM(2, (unsigned int)(2.0 * argument/100.0 * PTPERvalue), 0);

                while(U2STAbits.UTXBF);
                WriteUART2(argument);

                break;

            case HEIGHT_REG:            // Control the altitude from the ground

                // Get velocity threshold to maintain
                while(!DataRdyUART2());
                argument = ReadUART2();

                unsigned char rows[VIDFRAMES][IMCOLS]; //, cols[VIDFRAMES][IMROWS];
                int *Vm = (int *)(DMA_BASE + DMA_START_BUFA); //unsigned int Vm[VIDFRAMES][IMROWQUANT];
                unsigned int sync[VIDFRAMES][4];

                imcnt = 0;
                while(imcnt < VIDFRAMES) {

                    // Throw out frame fraction
                    while(VSYNC);
                    while(!VSYNC);
                    
                    _LATD11 = 1; // Signal start of frame capture

                    sync[imcnt][0] = DSADR; // Get sync signal just before frame                    

                    // Capture image rows
                    rowcnt = 0;
                    while(rowcnt < IMROWS) {
                        
                        // Get rows & related bEMF values 
                        if (rowcnt == IMROWSTART) {
                            
                            sync[imcnt][1] = DSADR; // Get sync signal just before row
                            getRow(rows[imcnt]);
                            sync[imcnt][2] = DSADR; // Get sync signal just after row

                        } else {

                            // Throw out current row
                            while(HREF);
                            while(!HREF);

                        }
                        
                        rowcnt++;
                    }

                    sync[imcnt][3] = DSADR; // Get sync signal just after frame

                    _LATD11 = 0; // Signal end of frame capture
    
                    imcnt++;
                }

                // Send rows off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<IMCOLS; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2(rows[j][i]);
                    }
                }

                // Send collected bEMF measurements off-board
                for (i=0; i<DMA_RAM_SIZE; i++) {
                    while(U2STAbits.UTXBF);
                    WriteUART2((unsigned char)(((Vm[i] >> 5) & 0x001F) | 0x0080));
                    while(U2STAbits.UTXBF);
                    WriteUART2((unsigned char)(Vm[i] & 0x001F));
                }
                while(U2STAbits.UTXBF);
                WriteUART2(0x0060);     // Finalize bEMF transmission

                // Send bEMF/rows sync signal off-board
                for (j=0; j<VIDFRAMES; j++) {
                    for (i=0; i<4; i++) {
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(sync[j][i] >> 8));
                        while(U2STAbits.UTXBF);
                        WriteUART2((unsigned char)(sync[j][i]));
                    }
                }
    
                break;


/*            case TAKE_LINES:        // Take a video sequence of crossing lines

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();
                for (i=0; i<1000; i++) { Delay_us(argument * 1000); }

                unsigned char rows[VIDFRAMES][IMCOLS], cols[VIDFRAMES][IMROWS];
                unsigned int adcbuffer[VIDFRAMES][IMROWS];

                imcnt = 0;
                while(imcnt < VIDFRAMES) {

                    // Throw out frame fraction
                    while(VSYNC);
                    while(!VSYNC);

                    // Signal start of frame capture
                    _LATD11 = 1;

                    // Capture image rows
                    rowcnt = 0;
                    while(rowcnt < IMROWS) {
                        
                        // Get either just the middle pixel or the full middle row
                        if (rowcnt != 59) {
                             
                            getRow(row);
                            cols[imcnt][rowcnt] = row[79];

                        } else {

                            getRow(rows[imcnt]);
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


/*            case TAKE_VIDEO:          // Take a video sequence (IMROWS = 60)

                unsigned char buffer[IMROWS][VIDCOLS], video[VIDFRAMES][VIDROWS][VIDCOLS];
                unsigned int adcbuffer[VIDFRAMES][IMROWS];

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();
                for (i=0; i<1000; i++) { Delay_us(argument * 1000); }
    
                imcnt = 0;
                while(imcnt < VIDFRAMES) {

                    // Throw out frame fraction
                    while(VSYNC);
                    while(!VSYNC);

                    // Signal start of frame capture
                    _LATD11 = 1;

                    // Capture every other image row
                    rowcnt = 0;
                    while(rowcnt < IMROWS) {
                        
                        getRow(row);

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


/*             case TAKE_PICTURE:           // Take a 160x100 picture (IMROWS = 100)

                // Waste approximatelly argument secs
                while(!DataRdyUART2());
                argument = ReadUART2();

                unsigned char image[IMROWS][IMCOLS];
  
                for (i=0; i<1000; i++) { Delay_us(argument * 1000); }
  
                // Throw out frame fraction
                while(VSYNC);
                while(!VSYNC);
  
                // Send rows to RAM
                rowcnt = 0;
                while(rowcnt < IMROWS) {
                    getRow(image[rowcnt]);
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
