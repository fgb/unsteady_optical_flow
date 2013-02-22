/*
 * Signatures for initialization functions that configure the dsPIC peripherals.
 *
 * Created on 2009-4-2 by AMH, fgb
 */

#ifndef __INIT_H
#define __INIT_H


// Sets up UART2 for RS-232 communication.
//
// Settings: 230.4Kbps, 8bit, No parity, 1 stop bit
void SetupUART(void);

// Sets up PWMs for controlling a motor.
//
// Settings: ip1: Motor/SMA Drivers @ 250Hz (Tpwm = 4ms)
//           ip2: Motor Driver @ 1KHz (Tpwm = 1ms)
void SetupPWM(void);

// Sets up DMA for moving ADC conversions to RAM.
//
// Settings:
void SetupDMA(void);

// Sets up ADC1 for Back-EMF sampling.
//
// Settings: [simultaneous]/continuous/automatic sampling/conversion of:
//           ip1: AN1 (by CH0) synced to the PWM and using an external Vref+,
//           ip2: AN11 (by CH0) synced to the PWM.
#define ADC_MAX 1023.0
void SetupADC(void);


#endif // __INIT_H
