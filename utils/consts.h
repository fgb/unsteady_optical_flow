/*
 * Constant Definitions
 *
 * Created on 2009-4-? by AMH
 */

// Peripheral-specific
#define PTPERvalue 2499 // Fcy/(Fpwm * Prescale) - 1
#define ADC_MAX 1023.0
#define DMA_BASE 0x4000 // Mirrored after __DMA_BASE, to enable it's use in a program
#define DMA_RAM_SIZE 1024 // When addressed as words
#define DMA_START_BUFA 0x0000 // DMA Buffer A address offset from DMA_BASE leading to 1 Kb from 0x4000-0x43FF
#define DMA_START_BUFB 0x0400 // DMA Buffer B address offset from DMA_BASE leading to 1 Kb from 0x4400-0x47FF

// Commands for the main loop
#define RECV_MOTOR_CMD 0
#define TAKE_PICTURE 1
#define TAKE_VIDEO 2
#define TAKE_LINES 3
#define HEIGHT_REG 4
#define TEST_UART 11
#define TEST_ADC 12
#define RECORD_BACK_EMF 13
#define SET_P_GAIN 14
#define SET_I_GAIN 15
#define SET_D_GAIN 16
#define SET_I_STATE_MIN 17
#define SET_I_STATE_MAX 18
