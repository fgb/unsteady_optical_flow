/*
 * Header for Atmel DataFlash
 *
 * Created on 2008-7-23 by fgb
 */

// From SetupPorts.h
// dfmem: SPI2 Slave Select is an output
//LATG  = 0b0000000000;
//TRISG = 0b0111111111;

#include "p33Fxxxx.h"

// DataFlash Function Definitions
void MEM_Write (unsigned int buffer, unsigned int byte, unsigned int page, unsigned int length, unsigned int *data);
unsigned int MEM_Read (unsigned int byte, unsigned int page, unsigned int length, unsigned int *data);
unsigned char MEM_Ready (void);
void MEM_WaitTillReady (void);
void MEM_SendByte (unsigned char byte);
unsigned char MEM_ReceiveByte (void);
void MEM_StartTransmission (void);
void MEM_EndTransmission (void);

// DataFlash Memory Pins
#define _CS _RG9

// Null-data write contents
#define null    0x00

