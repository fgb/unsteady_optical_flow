/*
 * A file that contains all signatures for interrupt handlers
 *
 * Created: 2009-4-8
 * Author: AMH, fgb
 */

#ifndef __INTERRUPTS_H
#define __INTERRUPTS_H

void __attribute__((interrupt, no_auto_psv)) _INT0Interrupt(void);
void __attribute__((__interrupt__, no_auto_psv)) _AddressError(void);

#endif
