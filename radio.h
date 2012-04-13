/******************************************************************************
* Name: radio.h
* Desc: Software module for AT86RF231 (SPI)
* Date: 2010-06-02
* Author: stanbaek
******************************************************************************/
#ifndef __RADIO_H
#define __RADIO_H

#include "payload.h"

void radioSetup(unsigned int tx_queue_length, unsigned int rx_queue_length);
void radioReadTrxId(unsigned char *id);
unsigned char radioGetTrxState(void);
int radioIsTxQueueFull(void);
int radioIsRxQueueEmpty(void);
void radioDeleteQueues(void);
Payload radioGetRxPayload(void);
unsigned char radioSendPayload(Payload pay, ...);
unsigned char radioGetChar(unsigned char *c);
void radioPutChar(unsigned char c);


#endif // __RADIO_H
