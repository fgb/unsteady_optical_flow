/*
 * Initialization routines
 *
 * Created on 2010-6-17 by fgb, AMH
 */


#include "init.h"
#include "p33Fxxxx.h"
#include "uart.h"
#include "pwm.h"
#include "dma.h"
#include "adc.h"


void SetupUART(void)
{
#if (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))

    U2BRG  = 43; // (Fcy / ({16|4} * baudrate)) - 1
    U2MODE = UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_FLOW &
             UART_UEN_10 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD &
             UART_UXRX_IDLE_ONE & UART_BRGH_FOUR & UART_NO_PAR_8BIT &
             UART_1STOPBIT;
    U2STA  = UART_INT_TX_BUF_EMPTY & UART_SYNC_BREAK_DISABLED &
             UART_TX_ENABLE & UART_ADR_DETECT_DIS &
             UART_IrDA_POL_INV_ZERO; // If not, whole output inverted.

#endif // (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))
}


void SetupPWM(void)
{
#if (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))

    #if defined(__IMAGEPROC1)

        PTPER   = 2499; // Fcy/(Fpwm * Prescale) - 1
        SEVTCMP = 2490; //620; // Special Event Trigger Compare Value for ADC in phase with PWM
        PWMCON1 = PWM_MOD2_IND & PWM_PEN2L & PWM_MOD3_IND & PWM_PEN3L;

        SetDCMCPWM(2, 0, 0);
        SetDCMCPWM(3, 0, 0);

    #elif defined(__IMAGEPROC2)

        PTPER   = 624; // Fcy/(Fpwm * Prescale) - 1
        SEVTCMP = 620; // Special Event Trigger Compare Value for ADC in phase with PWM
        PWMCON1 = PWM_MOD1_IND & PWM_PEN1L;

        SetDCMCPWM(1, 0, 0);

    #endif

    PWMCON2 = PWM_SEVOPS1 & PWM_OSYNC_TCY & PWM_UEN;
    PTCON   = PWM_EN & PWM_IDLE_STOP & PWM_OP_SCALE1 & PWM_IPCLK_SCALE64 &
              PWM_MOD_FREE;
    DisableIntMCPWM; DisableIntFLTA; DisableIntFLTB;

#endif // (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))
}


void SetupDMA(void)
{
#if defined(__IMAGEPROC1)

    // DMA is being triggered by ADC1 and transfers 1024 words in one shot and
    // ping pong modes.
    DMA0REQ  = DMA_AUTOMATIC & DMAxADC1;
    DMA0STA  = DMA_START_BUFA;
    DMA0STB  = DMA_START_BUFB;
    DMA0PAD  = (unsigned int)(&ADC1BUF0);
    DMA0CNT  = 511; // 512 DMA requests per block
    DMA0CON  = DMA_MODULE_ON & DMA_SIZE_WORD & PERIPHERAL_TO_DMA &
               DMA_INTERRUPT_BLOCK & DMA_NORMAL &
               DMA_REGISTER_POST_INCREMENT & DMA_ONE_SHOT_PING_PONG;
    DisableIntDMA0;

#endif // defined(__IMAGEPROC1)
}


void SetupADC(void)
{
#if (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))

    AD1CHS123 = 0x0000;
    AD1CON4 = ADC_DMA_BUF_LOC_1;
    AD1CON3 = ADC_CONV_CLK_SYSTEM & ADC_SAMPLE_TIME_1 & ADC_CONV_CLK_3Tcy;

    #if defined(__IMAGEPROC1)

        AD1PCFGL = ENABLE_AN0_ANA & ENABLE_AN1_ANA & ENABLE_AN2_ANA;
        AD1CSSL = 0x0003;
        AD1CHS0 = ADC_CH0_NEG_SAMPLEA_VREFN & ADC_CH0_POS_SAMPLEA_AN1;
        AD1CON2 = ADC_VREF_EXT_AVSS & ADC_SCAN_OFF & ADC_SELECT_CHAN_0 &
                  ADC_DMA_ADD_INC_1 & ADC_ALT_BUF_OFF & ADC_ALT_INPUT_OFF;
        AD1CON1 = ADC_MODULE_OFF & ADC_IDLE_STOP & ADC_ADDMABM_ORDER &
                  ADC_AD12B_10BIT & ADC_FORMAT_INTG & ADC_CLK_MPWM &
                  ADC_SIMULTANEOUS & ADC_AUTO_SAMPLING_ON & ADC_SAMP_ON;

    #elif defined(__IMAGEPROC2)

        AD1PCFGL = ENABLE_AN11_ANA;
        AD1CSSL = 0x0800;
        AD1CHS0 = ADC_CH0_NEG_SAMPLEA_VREFN & ADC_CH0_POS_SAMPLEA_AN11;
        AD1CON2 = ADC_VREF_AVDD_AVSS & ADC_SCAN_OFF & ADC_SELECT_CHAN_0 &
                  ADC_DMA_ADD_INC_1 & ADC_ALT_BUF_OFF & ADC_ALT_INPUT_OFF;
        AD1CON1 = ADC_MODULE_ON & ADC_IDLE_STOP & ADC_ADDMABM_ORDER &
                  ADC_AD12B_10BIT & ADC_FORMAT_INTG & ADC_CLK_MPWM &
                  ADC_SIMULTANEOUS & ADC_AUTO_SAMPLING_ON & ADC_SAMP_ON;

    #endif

    DisableIntADC1();

#endif // (defined(__IMAGEPROC1) || defined(__IMAGEPROC2))
}
