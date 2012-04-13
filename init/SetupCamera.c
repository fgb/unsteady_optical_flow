/*
 * Configure the camera through SCCB and manage power to it.
 * 
 * Created on 2009-4-2 by fgb, AMH
 */

#include "init.h"

void SetupCamera(void)
{
    // Turn the camera on
    _LATC13 = 0; // PDWN: CAM On
    _LATC14 = 1; // REG2 On
    Delay_us(5000);

    SCCB_SetupOV7660();
}
