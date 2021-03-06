/*
 * Copyright (c) 2010-2013, Regents of the University of California
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of the University of California, Berkeley nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * Image processing and control of an unsteadily moving robotic platform
 *
 * by Stanley S. Baek and Fernando L. Garcia Bermudez
 *
 * v.beta
 *
 * Revisions:
 *  Stanley S. Baek                 2010-7-8    Initial release.
 *  w/Fernando L. Garcia Bermudez   2011-3-4    Adaptation to fgb codebase.
 *  Humphrey Hu                     2012-4-13   Adaptation to latest radio.
 *
 */

#include "init_default.h"
#include "init.h"       // only used for SetupADC() for bemf
#include "battery.h"
#include "cmd.h"
#include "motor_ctrl.h"
#include "led.h"
#include "sclock.h"

#include "radio.h"
#include "radio_settings.h"

#include "dfmem.h"
#include "cam.h"
#include "cambuff.h"
#include "gyro.h"


int main (void)
{
    unsigned int i;

    /* Initialization */
    SetupClock();
    SetupPorts();
    batSetup();
    cmdSetup();
    mcSetup();
    SetupADC();
    SwitchClocks();
    sclockSetup();

    radioInit(TXPQ_MAX_SIZE, RXPQ_MAX_SIZE);
    radioSetChannel(MY_CHAN);
    radioSetSrcPanID(PAN_ID);
    radioSetSrcAddr(SRC_ADDR);

    dfmemSetup();
    camSetup();
    cambuffSetup();
    gyroSetup();

    cmdResetSettings();

    for (i = 0; i < 6; i++)
    {
        LED_GREEN  = ~LED_GREEN;  delay_ms(50);
        LED_RED    = ~LED_RED;    delay_ms(50);
        LED_ORANGE = ~LED_ORANGE; delay_ms(50);
    }
    LED_GREEN = 0; LED_RED = 0; LED_ORANGE = 0;

    /* Program */
    while (1)
    {
        cmdHandleRadioRxBuffer();
        radioProcess();
    }
}
