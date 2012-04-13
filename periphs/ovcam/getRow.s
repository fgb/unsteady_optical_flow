;
; Get a row from OV7660
;
; Created on 2007-11-30 by fgb
;

; Definitions:
; - VSYNC    RD8
; - HREF     RD9
; - PIXEL    PORTD
; - row      w1

#include p33Fxxxx.inc

.global _getRow

_getRow:

; Copy row pointer to w1
            mov     w0, w1

; Wait until a new row starts

wROWe:      btst    PORTD, #9
            bra     NZ, wROWe
wROWs:      btst    PORTD, #9
            bra     Z, wROWs

; Capture image row
            mov     PORTD, w0   ; init
            mov.b   w0, [w1++]
            nop
            nop
            nop
            nop
getROW:		mov     PORTD, w0   ; rest
            mov.b   w0, [w1++]
            nop
            nop
            nop
            btst    PORTD, #9
            bra     NZ, getROW

            return
.end
