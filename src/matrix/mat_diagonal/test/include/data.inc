;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data.inc
;
; This header file contains data.
;
;=====================================================================

section .data

    ;Matrix A
    align 16, db 0
    A:
        .numOfRows:     dd 6
        .numOfColumns:  dd 6
        .columnSize:    dd 4            ;single-precision element
        .rowSize:       dd (6*4)        ;numOfColumns * columnSize
        .pData:         dd dataMatrix_A

    ;Vector B
    align 16, db 0
    B:
        .numOfRows:     dd 1
        .numOfColumns:  dd 6
        .columnSize:    dd 4            ;single-precision element
        .rowSize:       dd (6*4)        ;numOfColumns * columnSize
        .pData:         dd dataVector_B

    align 16, db 0
    dataMatrix_A: dd __float32__(-32.4012) ;A[0,0]
                  dd __float32__( 42.1234) ;A[0,1]
                  dd __float32__(-85.5213) ;A[0,2]
                  dd __float32__( 90.3214) ;A[0,3]
                  dd __float32__(-49.1230) ;A[0,4]
                  dd __float32__(-64.2356) ;A[0,5]
                  dd __float32__( 84.1235) ;A[1,0]
                  dd __float32__( 95.2314) ;A[1,1]
                  dd __float32__( 33.1456) ;A[1,2]
                  dd __float32__(-90.3213) ;A[1,3]
                  dd __float32__(-42.2391) ;A[1,4]
                  dd __float32__(-63.3524) ;A[1,5]
                  dd __float32__( 52.2014) ;A[2,0]
                  dd __float32__(-69.2405) ;A[2,1]
                  dd __float32__( 64.3777) ;A[2,2]
                  dd __float32__(-52.1234) ;A[2,3]
                  dd __float32__( 97.3125) ;A[2,4]
                  dd __float32__( 12.5512) ;A[2,5]
                  dd __float32__(-86.3215) ;A[3,0]
                  dd __float32__(-92.9642) ;A[3,1]
                  dd __float32__(-12.1524) ;A[3,2]
                  dd __float32__( 42.5214) ;A[3,3]
                  dd __float32__(-30.1255) ;A[3,4]
                  dd __float32__( 42.3215) ;A[3,5]
                  dd __float32__(-53.5124) ;A[4,0]
                  dd __float32__(-90.4215) ;A[4,1]
                  dd __float32__( 50.2050) ;A[4,2]
                  dd __float32__( 53.1246) ;A[4,3]
                  dd __float32__(-43.6534) ;A[4,4]
                  dd __float32__( 86.9240) ;A[4,5]
                  dd __float32__( 90.3215) ;A[5,0]
                  dd __float32__( 24.2159) ;A[5,1]
                  dd __float32__(-99.9999) ;A[5,2]
                  dd __float32__( 12.0415) ;A[5,3]
                  dd __float32__(-11.1145) ;A[5,4]
                  dd __float32__(-41.1245) ;A[5,5]

section .bss

    align 16, resb 1
    dataVector_B: resd 6
