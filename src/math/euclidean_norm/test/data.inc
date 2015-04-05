;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data.inc
;
; This header file contains data.
;
;=====================================================================

section .bss

    align 16, resb 1
    Y_T001:    resd 1

section .data

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; If you want to increase the number of columns in this
    ; vector X, don't forget to increase the value of
    ; NUM_OF_COLUMNS in constants.inc header file.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, db 0
    X_T001:    dd __float32__(54.2314)
               dd __float32__(-23.1234)
               dd __float32__(90.8656)

