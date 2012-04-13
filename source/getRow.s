;********************************************************
; Name: getRow.asm
; Desc: Get a row from OV7660
; Date: 2007-11-30
; Author: fgb
;*******************************************************/
;* Definitions
;- VSYNC    RD8
;- HREF     RD9
;- PIXEL    PORTD
;- row      w1

#include p33Fxxxx.inc

.global _getRow

_getRow:

;* Copy row pointer to w1
            mov     w0, w1

;** Wait until a new row starts

wROWe:      btst    PORTD, #9
            bra     NZ, wROWe
wROWs:      btst    PORTD, #9
            bra     Z, wROWs

;*** Capture image row
            mov     PORTD, w0   ;0
            mov.b   w0, [w1++]
            nop
            nop
            nop
            nop
getROW:		mov     PORTD, w0   ;1
            mov.b   w0, [w1++]
            nop
            nop
            nop
            btst    PORTD, #9
            bra     NZ, getROW

            return
.end
