/*********************************************************************************************************
* Name: main.c
* Desc: Image Processing of OV7660
* Date: 2007-8-8
* Author: fgb, amh
*********************************************************************************************************/

#include "p33Fxxxx.h"
#include "ovcam.h"
#include "i2c.h"
#include "uart.h"
#include "ports.h"
#include "delay.h"
#include "spi.h"
#include "pwm.h"
#include "adc.h"
#include "dfmem.h"

void __attribute__((interrupt, no_auto_psv)) _INT0Interrupt(void);
void __attribute__((__interrupt__, no_auto_psv)) _AddressError(void);
extern unsigned char convStep(unsigned int prev, unsigned int current, unsigned int next);

/* Configuration Bits (macros defined in processor header) */
_FOSCSEL(FNOSC_PRIPLL & IESO_ON); // Primary OSC (XT, HS, EC) w/ PLL & 2-Speed Startup Enabled (for fast EC)
_FOSC(POSCMD_EC & FCKSM_CSDCMD & OSCIOFNC_OFF); // EC oscillator & CLK Switch./Mon. Dis & OSC2 as CLK Out
_FWDT(FWDTEN_OFF); // Watchdog Timer Dis

int main ( void )
{
    /* Initialization */

    /// Setup for 40MIPS(Fcy) w/40MHz XT(Fin): Fcy = Fin * (M / (2 * N1 * N2))
    _PLLDIV = 6; // M = 8
    _PLLPRE = 0;  // N1 = 2
    _PLLPOST = 0; // N2 = 2

    /// Ports
    // Disabling all ADC2 AIO's to enable DIO's
    AD1PCFGL = ENABLE_ALL_DIG_0_15;
    AD2PCFGL = ENABLE_ALL_DIG_0_15;
    // LEDs: RF0-1 and RD11(ext int) are outputs
    LATF  = 0b0000000;
    TRISF = 0b1111100;
    LATD  = 0x000;
    TRISD = 0b011111111111;
    /* Note that in the above, Data: RD0-7(PIXEL) and Sync:
       RD8-10(VSYNC/HREF/PCLK) remain inputs for the camera */
    // Camera PWDN: RC13-14 are outputs
    LATC  = 0x0000;
    TRISC = 0b1001111111111111;
    // Switches: RF2-3 are inputs
    // Batt Supervisor: RF6(ext int) is an input
    /* Extra: RE2(PWM), RB0-3(A/D Conv) all inputs
       or managed thru the peripheral modules */ 
    // dfmem: SPI2 Slave Select is an output
    //LATG  = 0b0000000000;
    //TRISG = 0b0111111111;

    /// External Interrupts
    ConfigINT0(RISING_EDGE_INT & EXT_INT_ENABLE & EXT_INT_PRI_7); // Battery Supervisor

    /// UART2 for RS-232 w/PC @ 230400, 8bit, No parity, 1 stop bit
    unsigned int U2MODEvalue, U2STAvalue, U2BRGvalue;
    U2MODEvalue = UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE &
                  UART_MODE_FLOW & UART_UEN_10 & UART_DIS_WAKE &
                  UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_UXRX_IDLE_ONE &
                  UART_BRGH_FOUR & UART_NO_PAR_8BIT & UART_1STOPBIT;
    U2STAvalue  = UART_INT_TX_BUF_EMPTY & UART_SYNC_BREAK_DISABLED &
                  UART_TX_ENABLE & UART_ADR_DETECT_DIS & UART_IrDA_POL_INV_ZERO; // If not, whole output inverted.
    U2BRGvalue  = 43; // (Fcy / ({16|4} * baudrate)) - 1
    OpenUART2(U2MODEvalue, U2STAvalue, U2BRGvalue);

    /// I2C for SCCB
    unsigned int I2C1CONvalue, I2C1BRGvalue;
    I2C1CONvalue = I2C1_ON & I2C1_IDLE_CON & I2C1_CLK_HLD &
                   I2C1_IPMI_DIS & I2C1_7BIT_ADD & I2C1_SLW_DIS &
                   I2C1_SM_DIS & I2C1_GCALL_DIS & I2C1_STR_DIS &
                   I2C1_NACK & I2C1_ACK_DIS & I2C1_RCV_DIS &
                   I2C1_STOP_DIS & I2C1_RESTART_DIS & I2C1_START_DIS;
    I2C1BRGvalue = 363; // Fcy(1/Fscl - 1/1111111)-1
    OpenI2C1(I2C1CONvalue, I2C1BRGvalue);
    IdleI2C1();

    /// SPI for Flash Memory
    unsigned int SPI2CON1value, SPI2CON2value, SPI2STATvalue;
    SPI2CON1value = ENABLE_SCK_PIN & ENABLE_SDO_PIN & SLAVE_ENABLE_ON &
                    SPI_SMP_ON & SPI_CKE_ON & CLK_POL_ACTIVE_LOW &
                    SPI_MODE16_OFF & MASTER_ENABLE_ON &
                    PRI_PRESCAL_1_1 & SEC_PRESCAL_4_1;
    SPI2CON2value = FRAME_ENABLE_ON & FRAME_SYNC_OUTPUT &
                    FRAME_POL_ACTIVE_HIGH & FRAME_SYNC_EDGE_PRECEDE;
    SPI2STATvalue = SPI_ENABLE & SPI_IDLE_STOP & SPI_RX_OVFLOW_CLR;
    OpenSPI2(SPI2CON1value, SPI2CON2value, SPI2STATvalue);
    //_CS = 1; // De-select mem (slave)

    /// PWM for Motor Driver @ 1KHz (Tpwm = 1ms)
    unsigned int PTPERvalue, SEVTCMPvalue, PTCONvalue, PWMCON1value, PWMCON2value, PDC2value;
    PTPERvalue = 624; // Fcy/(Fpwm * Prescale) - 1
    SEVTCMPvalue = 0; // Special Event Trigger Compare Value for ADC in phase with PWM
    PTCONvalue = PWM_EN & PWM_IDLE_CON & PWM_OP_SCALE1 &
                  PWM_IPCLK_SCALE64 & PWM_MOD_FREE;
    PWMCON1value = PWM_MOD2_IND & PWM_PEN2L;
    PWMCON2value = PWM_SEVOPS1 & PWM_OSYNC_TCY & PWM_UEN;
    PDC2value = 0;
    ConfigIntMCPWM(PWM_INT_DIS & PWM_FLTA_DIS_INT & PWM_FLTB_DIS_INT);
    SetDCMCPWM(2, PDC2value, 0);
    OpenMCPWM(PTPERvalue, SEVTCMPvalue, PTCONvalue, PWMCON1value, PWMCON2value);

    /// ADC
    unsigned int AD1CON1value, AD1CON2value, AD1CON3value, AD1CON4value, AD1PCFGHvalue, AD1PCFGLvalue, AD1CSSHvalue, AD1CSSLvalue, AD1CHS0value;
    AD1CON1value = ADC_MODULE_ON & ADC_IDLE_CONTINUE & ADC_ADDMABM_ORDER &
                   ADC_AD12B_10BIT & ADC_FORMAT_INTG & ADC_CLK_AUTO &
                   ADC_MULTIPLE & ADC_AUTO_SAMPLING_ON & ADC_SAMP_ON;
    AD1CON2value = ADC_VREF_AVDD_AVSS & ADC_SCAN_OFF & ADC_SELECT_CHAN_0 &
                   ADC_DMA_ADD_INC_1 & ADC_ALT_BUF_OFF & ADC_ALT_INPUT_OFF;
    AD1CON3value = ADC_CONV_CLK_SYSTEM & ADC_CONV_CLK_2Tcy & ADC_SAMPLE_TIME_1;
    AD1CON4value = ADC_DMA_BUF_LOC_1;
    AD1PCFGHvalue = ENABLE_ALL_DIG_16_31;
    AD1PCFGLvalue = ENABLE_AN0_ANA & ENABLE_AN1_ANA & ENABLE_AN2_ANA & ENABLE_AN3_ANA;
    AD1CSSHvalue = SCAN_NONE_16_31;
    AD1CSSLvalue = 0x000F; // Enabling AN0-3
    DisableIntADC1();
    AD1CHS0value = ADC_CH0_NEG_SAMPLEA_VREFN & ADC_CH0_POS_SAMPLEA_AN3;
    SetChanADC1(0x0000, AD1CHS0value);
    OpenADC1(AD1CON1value, AD1CON2value, AD1CON3value, AD1CON4value, AD1PCFGLvalue, AD1PCFGHvalue, AD1CSSHvalue, AD1CSSLvalue);

    /// Wait for RC->EC Clock Switch
    while(_COSC != _NOSC);
    _RF0 = 1;

    /// OV7660 CameraChip through SCCB
    _RC13 = 0; // PDWN: CAM On
    _RC14 = 1; // REG2 On
    delay_us(5000);
    SCCB_SetupOV7660();

/********************************************************************************************************/
/* Program */

    unsigned int i, j, k, rowcnt, imcnt, imrows, imcols=160, vidrows=13, vidcols=18, vidframes=60; //, val, valH, valL;
    unsigned char command, argument, row[imcols];

  	while(1){

    	  // Wait for next command and argument
      	while(!DataRdyUART2());
      	command = ReadUART2();
      	while(!DataRdyUART2());
      	argument = ReadUART2();

      	switch(command) {

       		case 0:
            	// Update duty cycle
              	PDC2value = (unsigned int)(2.0 * argument/100.0 * PTPERvalue);
              	SetDCMCPWM(2, PDC2value, 0);

              	// Send back received duty cycle value
              	while(U2STAbits.UTXBF);
              	WriteUART2(argument);

              	break;

          	case 2:
            	  // Take a 2.4s video sequence
              	imrows = 60;
              	unsigned char buffer[imrows][vidcols], video[vidframes][vidrows][vidcols];

              	// Waste approximatelly argument secs
              	for (i=0; i<1000; i++) { delay_us(argument * 1000); }

              	imcnt = 0;
              	while(imcnt < vidframes) {

                  	// Throw out frame fraction
                  	while(VSYNC);
                  	while(!VSYNC);

                  	// Signal start of frame capture
                  	_RD11 = 1;

                  	// Capture every other image rows
                  	rowcnt = 0;
                  	while(rowcnt < imrows) {
                      	getRow(row);

                      	// Subsample rows 3 times
                      	for (i=0; i<78; i++) {
                          	row[i] = convStep(row[2*i+1], row[2*i+2], row[2*i+3]);
                      	}
                      	for (i=0; i<38; i++) {
                        	row[i] = convStep(row[2*i], row[2*i+1], row[2*i+2]);
                      	}
                      	for (i=0; i<vidcols; i++) {
                        	buffer[rowcnt][i] = convStep(row[2*i], row[2*i+1], row[2*i+2]);
                      	}

                      	rowcnt++;
                  	}

                  	// Signal end of frame capture
                  	_RD11 = 0;

                  	// Subsample columns 2 times (because of every other line capture)
                  	for (i=0; i<vidcols; i++) {
                    	for (j=0; j<28; j++) {
                        	buffer[j][i] = convStep(buffer[2*j+1][i], buffer[2*j+2][i], buffer[2*j+3][i]);
                      	}
                    	for (j=0; j<vidrows; j++) {
                        	video[imcnt][j][i] = convStep(buffer[2*j][i], buffer[2*j+1][i], buffer[2*j+2][i]);
                      	}
                  	}

                  	imcnt++;
              	}

              	// Send lines off-board
              	for (k=0; k<vidframes; k++) {
               		for (j=0; j<vidrows; j++) {
                    	for (i=0; i<vidcols; i++) {
                        	WriteUART2(video[k][j][i]);
                          	while(BusyUART2());
                      	}
                  	}
              	}

              	break;

          	/*
			case 1:
          	   	// Take a 160x100 picture
               	imrows = 100;
               	unsigned char image[imrows][imcols];
               
               	// Waste approximatelly argument secs
               	for (i=0; i<1000; i++) { delay_us(argument * 1000); }
               
               	// Throw out frame fraction
               	while(VSYNC);
               	while(!VSYNC);
               
               	// Send rows to RAM
               	rowcnt = 0;
               	while(rowcnt < imrows) {
                	getRow(row);
                   
                   	for (i=0; i<imcols; i++) {
                    	image[rowcnt][i] = row[i];
                   	}
                   
                   	rowcnt++;
               	}
               
               	// Send the captured image off-board
               	for (j=0; j<imrows; j++) {
                   	for (i=0; i<imcols; i++) {
                       	WriteUART2(image[j][i]);
                       	while(BusyUART2());
                   	}
               	}
               
               	break;
			   	*/
		}
  	}

    /*
	// Sense BackEMF, translate to velocity and send back

    PDC2value = (unsigned int)(2.0 * 50/100.0 * PTPERvalue);
    SetDCMCPWM(2, PDC2value, 0);

    while(1){

        //AD1CON1bits.SAMP = 1;
        while(BusyADC1());
        val = ReadADC1(0);
        valL = val;
        valH = val >> 8;

        for (k=0; k<100; k++) { delay_us(1000); }   // Waste approximatelly 100ms

        // Send back received
        while(U2STAbits.UTXBF);
        WriteUART2(valH);
        while(U2STAbits.UTXBF);
        WriteUART2(valL);

    };
	*/

    // Close the velocity control loop that counteracts battery discharge

    /*
	// Setup Mem
    while(_RF2);
    MEM_WaitTillReady();
    _RF1 = 0;

    while(1){
      _RF1 = MEM_Ready();
      if(_SPIROV) { asm volatile("btg   PORTF, #0"); }
    };
	*/

    return 0;
}

/********************************************************************************************************/
/* Interrupt Service Routines */

// Battery Supervisor
void __attribute__((interrupt, no_auto_psv)) _INT0Interrupt(void) {

    _INT0IF = 0;    // Clear the interrupt flag

    unsigned int i;

    _RF0 = 0;
	//Stop the motor
    SetDCMCPWM(2, 0, 0);
    while(1) {
        asm volatile("btg   PORTF, #1");
        for (i=0; i<100; i++) { delay_us(5000); }   // Waste approximatelly .5s
    };
}

// Useful traps
//
// Note: Adapted from Microchip's traps.c
void __attribute__((__interrupt__, no_auto_psv)) _AddressError(void)
{
		unsigned int k;

        INTCON1bits.ADDRERR = 0;        //Clear the trap flags
        while(1) {
            asm volatile("btg   PORTF, #1");
            for (k=0; k<100; k++) { delay_us(500); }   // Waste approximatelly 50ms
        };
}
