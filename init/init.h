/*
 * Signatures for initialization functions that configure the dsPIC peripherals.
 *
 * Created on 2009-4-2 by AMH, fgb
 */

#include "p33Fxxxx.h"
#include "ports.h"
#include "interrupts.h"

#include "uart.h"
#include "pwm.h"
#include "dma.h"
#include "adc.h"

#include "ovcam.h"
#include "i2c.h"

#include "utils.h"
#include "consts.h"

#ifndef __INIT_H
#define __INIT_H

void SetupClock(void);
void SetupPorts(void);
void SetupInterrupts(void);
void SetupUART(void);
void SetupI2C(void);
void SetupPWM(void);
void SetupDMA(void);
void SetupADC(void);
void SwitchClocks(void);
void SetupCamera(void);

#endif
