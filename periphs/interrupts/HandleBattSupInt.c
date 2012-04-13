/*
 * Interrupt handler for the battery supervisor. 
 *
 * Created: 2009-4-2
 * Author: fgb, AMH
 */

#include "init.h"

void __attribute__((interrupt, no_auto_psv)) _INT0Interrupt(void)
{
    _INT0IF = 0;    // Clear the interrupt flag

    unsigned int i, j;

    _RF0 = 0;

    //Stop any running motors
    SetDCMCPWM(2, 0, 0);
    SetDCMCPWM(3, 0, 0);    

    for (j=0; j<5; j++) {
        asm volatile("btg   PORTF, #1");
        for (i=0; i<100; i++) { Delay_us(5000); }   // Waste approximatelly .5s
    };
}
