/*
 * Configure I2C for communication with other boards through SCCB.
 *
 * Created on 2009-4-2 by fgb, AMH
 */ 

#include "init.h"

void SetupI2C(void)
{
    unsigned int I2C1CONvalue, I2C1BRGvalue;
    I2C1CONvalue = I2C1_ON & I2C1_IDLE_CON & I2C1_CLK_HLD &
                   I2C1_IPMI_DIS & I2C1_7BIT_ADD & I2C1_SLW_DIS &
                   I2C1_SM_DIS & I2C1_GCALL_DIS & I2C1_STR_DIS &
                   I2C1_NACK & I2C1_ACK_DIS & I2C1_RCV_DIS &
                   I2C1_STOP_DIS & I2C1_RESTART_DIS & I2C1_START_DIS;
    I2C1BRGvalue = 363; // Fcy(1/Fscl - 1/1111111)-1
    OpenI2C1(I2C1CONvalue, I2C1BRGvalue);
    IdleI2C1();
}
