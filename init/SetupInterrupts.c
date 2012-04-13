/*
 * Configure all interrupts.
 *
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupInterrupts(void)
{
    ConfigINT0(RISING_EDGE_INT & EXT_INT_ENABLE & EXT_INT_PRI_7); // Battery Supervisor
}
