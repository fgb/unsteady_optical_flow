/*
 * Interrupt handlers for useful traps
 *
 * Note: Adapted from Microchip's traps.c
 *
 * Created: 2010-5-3
 * Author: fgb
 */

#include "init.h"

void __attribute__((__interrupt__, no_auto_psv)) _AddressError(void)
{
        INTCON1bits.ADDRERR = 0;        //Clear the trap flags
        while(1) {
            asm volatile("btg   LATF, #1");
            unsigned int k;
            for (k=0; k<100; k++) { Delay_us(500); }   // Waste approximatelly 50ms
        };
}
