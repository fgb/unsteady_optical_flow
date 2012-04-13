/*
 * Setup the ports on the PIC.
 * 
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupPorts(void)
{
    // Disabling all potential ADC AIO's to enable DIO's (will enable the needed ones in SetupADC())
    AD1PCFGL = ENABLE_ALL_DIG_0_15;
    AD2PCFGL = ENABLE_ALL_DIG_0_15;
    
    // LEDs: RB3(AN3), RD11(ext int), and RF0-1 are outputs
    LATB  = 0x0000;
    TRISB = 0b1111111111110111; // A/D Conv: RB0-2(A/D Conv) are analog inputs
    LATD  = 0x000;
    TRISD = 0b011111111111; // Data: RD0-7(PIXEL) and Sync: RD8-10(VSYNC/HREF/PCLK) remain inputs for the camera
    LATF  = 0x00;
    TRISF = 0b1111100; // Switches: RF2-3, Batt Supervisor: RF6(ext int) are all inputs

    // Camera PWDN: RC13-14 are outputs
    LATC  = 0x0000;
    TRISC = 0b1001111111111111;

    // PWM: RE2 is an output managed thru the peripheral 
}
