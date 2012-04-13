/*
 * Sets up the SPI for interfacing to flash memory.
 *
 * Created: 2009-4-2
 * Author: fgb, AMH
 */

#include "init.h"

void SetupSPI(void)
{
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
}
