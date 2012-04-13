/*
 * Configuration code for enabling UART2 for RS232 w/ a PC.
 *
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupUART(void)
{
    /// UART2 for RS-232 w/PC @ 230400, 8bit, No parity, 1 stop bit
    unsigned int U2MODEvalue, U2STAvalue, U2BRGvalue;
    U2MODEvalue = UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE &
                  UART_MODE_FLOW & UART_UEN_10 & UART_DIS_WAKE &
                  UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_UXRX_IDLE_ONE &
                  UART_BRGH_FOUR & UART_NO_PAR_8BIT & UART_1STOPBIT;
    U2STAvalue  = UART_INT_TX_BUF_EMPTY & UART_SYNC_BREAK_DISABLED &
                  UART_TX_ENABLE & UART_ADR_DETECT_DIS & UART_IrDA_POL_INV_ZERO; // If not, whole output inverted.
    U2BRGvalue  = 43; // (Fcy / ({16|4} * baudrate)) - 1
    OpenUART2(U2MODEvalue, U2STAvalue, U2BRGvalue);
}
