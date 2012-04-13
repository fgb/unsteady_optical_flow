/*
 * Configure the analog to digital converter.
 *
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupADC(void)
{
    // Setup for [simultaneous]/continuous/automatic sampling/conversion of AN1(by CH0) synced to the PWM and using an external Vref+
    #define AD1CON1value (ADC_MODULE_OFF & ADC_IDLE_STOP & ADC_ADDMABM_ORDER & ADC_AD12B_10BIT & ADC_FORMAT_INTG & ADC_CLK_MPWM & ADC_SIMULTANEOUS & ADC_AUTO_SAMPLING_ON & ADC_SAMP_ON)
    #define AD1CON2value (ADC_VREF_EXT_AVSS & ADC_SCAN_OFF & ADC_SELECT_CHAN_0 & ADC_DMA_ADD_INC_1 & ADC_ALT_BUF_OFF & ADC_ALT_INPUT_OFF)
    #define AD1CON3value (ADC_CONV_CLK_SYSTEM & ADC_SAMPLE_TIME_1 & ADC_CONV_CLK_3Tcy)
    #define AD1CON4value ADC_DMA_BUF_LOC_1

    #define AD1CHS123value 0x0000    
    #define AD1CHS0value (ADC_CH0_NEG_SAMPLEA_VREFN & ADC_CH0_POS_SAMPLEA_AN1)

    #define AD1CSSLvalue 0x0003
    #define AD1CSSHvalue SCAN_NONE_16_31    

    #define AD1PCFGLvalue (ENABLE_AN0_ANA & ENABLE_AN1_ANA & ENABLE_AN2_ANA)
    #define AD1PCFGHvalue ENABLE_ALL_DIG_16_31

    DisableIntADC1();
    SetChanADC1(AD1CHS123value, AD1CHS0value);    
    OpenADC1(AD1CON1value, AD1CON2value, AD1CON3value, AD1CON4value, AD1PCFGLvalue, AD1PCFGHvalue, AD1CSSHvalue, AD1CSSLvalue);
}
