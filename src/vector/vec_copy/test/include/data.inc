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

    align 16, db 0
    A:
        .numOfRows:    dd 5
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_A

    align 16, db 0
    B:
        .numOfRows:    dd 5
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_B

    C:
        .numOfRows:    dd 5
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_C

    align 16, db 0
    dataMatrix_A: dd __float32__(-32.4012) ;A[0,0]
                  dd __float32__( 42.1234) ;A[0,1]
                  dd __float32__(-85.5213) ;A[0,2]
                  dd __float32__( 90.3214) ;A[1,0]
                  dd __float32__(-49.1230) ;A[1,1]
                  dd __float32__(-64.2356) ;A[1,2]
                  dd __float32__( 84.1235) ;A[2,0]
                  dd __float32__( 95.2314) ;A[2,1]
                  dd __float32__( 33.1456) ;A[2,2]
                  dd __float32__(-90.3213) ;A[3,0]
                  dd __float32__(-42.2391) ;A[3,1]
                  dd __float32__(-63.3524) ;A[3,2]
                  dd __float32__( 52.2014) ;A[4,0]
                  dd __float32__(-69.2405) ;A[4,1]
                  dd __float32__( 64.3777) ;A[4,2]

section .bss

    align 16, resb 1
    dataMatrix_B: resd (5*3)

    align 16, resb 1
    dataMatrix_C: resd (5*3)
