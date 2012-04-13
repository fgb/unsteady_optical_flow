/*
 * Setup primary oscillator/clock and related functions.
 *
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

/* Configuration Bits (macros defined in processor header) */
_FOSCSEL(FNOSC_PRIPLL & IESO_ON); // Primary OSC (XT, HS, EC) w/ PLL & 2-Speed Startup Enabled (for fast EC)
_FOSC(POSCMD_EC & FCKSM_CSDCMD & OSCIOFNC_OFF); // EC oscillator & CLK Switch./Mon. Dis & OSC2 as CLK Out
_FWDT(FWDTEN_OFF); // Watchdog Timer Dis

void SetupClock(void)
{
    // Setup for 40MIPS(Fcy) w/40MHz XT(Fin): Fcy = Fin * (M / (2 * N1 * N2))
    _PLLDIV = 6;  // M = 8
    _PLLPRE = 0;  // N1 = 2
    _PLLPOST = 0; // N2 = 2
}

void SwitchClocks(void)
{
    // Wait for RC->EC Clock Switch
    while(_COSC != _NOSC);
    _LATF0 = 1;
}
