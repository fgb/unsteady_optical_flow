/*
 * Configure the PWM module.
 *
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupPWM(void)
{
    // Motor/SMA Drivers @ 250Hz (Tpwm = 4ms)
    #define SEVTCMPvalue 2490 //620 // Special Event Trigger Compare Value for ADC in phase with PWM
    #define PTCONvalue (PWM_EN & PWM_IDLE_STOP & PWM_OP_SCALE1 & PWM_IPCLK_SCALE64 & PWM_MOD_FREE)
    #define PWMCON1value (PWM_MOD2_IND & PWM_PEN2L & PWM_MOD3_IND & PWM_PEN3L)
    #define PWMCON2value (PWM_SEVOPS1 & PWM_OSYNC_TCY & PWM_UEN)

    SetDCMCPWM(2, 0, 0);
    SetDCMCPWM(3, 0, 0);

    DisableIntMCPWM; DisableIntFLTA; DisableIntFLTB;
    OpenMCPWM(PTPERvalue, SEVTCMPvalue, PTCONvalue, PWMCON1value, PWMCON2value);
}
