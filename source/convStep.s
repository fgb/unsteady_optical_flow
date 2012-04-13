;********************************************************
; Name: convStep.s
; Desc: Apply discrete gaussian filter to 3 pixels
; Date: 2007-12-04
; Author: fgb
;*******************************************************/
;* Definitions
;- prev        w0
;- current     w1
;- next        w2
;
;* Operation: (prev + 2 * current + next) / 4

#include p33Fxxxx.inc

.global _convStep

_convStep:
;* Convolve 3 pixels
            add    w0, w1, w0
            add    w0, w1, w0
            add    w0, w2, w0
            bclr   SR, #0
            rrc    w0, w0
            bclr   SR, #0
            rrc    w0, w0

            return
.end
