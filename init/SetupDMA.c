/*
 * Configure Direct Memory Access (DMA).
 *
 * Created on 2010-3-21 by fgb
 */

#include "init.h"

void SetupDMA(void)
{
    // DMA is being triggered by ADC1 and transfers 1024 words in one shot and ping pong modes.
    #define DMA0CONvalue (DMA0_MODULE_ON & DMA0_SIZE_WORD & PERIPHERAL_TO_DMA0 & DMA0_INTERRUPT_BLOCK & DMA0_NORMAL & DMA0_REGISTER_POST_INCREMENT & DMA0_ONE_SHOT_PING_PONG)
    #define DMAxADC1     0xFF8D // Select ADC1 as DMA request source
    #define DMA0REQvalue (DMA0_AUTOMATIC & DMAxADC1)
    #define DMA0STAvalue DMA_START_BUFA
    #define DMA0STBvalue DMA_START_BUFB
    #define DMA0PADvalue &ADC1BUF0
    #define DMA0CNTvalue 511 // 512 DMA requests per block

    DisableIntDMA0;
    OpenDMA0(DMA0CONvalue, DMA0REQvalue, DMA0STAvalue, DMA0STBvalue, DMA0PADvalue, DMA0CNTvalue);
}
