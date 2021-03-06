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
        .numOfRows:    dd 3
        .numOfColumns: dd 5
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (5*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_A

    align 16, db 0
    B:
        .numOfRows:    dd 3
        .numOfColumns: dd 5
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (5*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_B

    align 16, db 0
    C:
        .numOfRows:    dd 3
        .numOfColumns: dd 5
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (5*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_C

    align 16, db 0
    dataMatrix_A: dd __float32__(32.4012) ;A[0,0]
                  dd __float32__(90.3214) ;A[0,1]
                  dd __float32__(84.1235) ;A[0,2]
                  dd __float32__(90.3213) ;A[0,3]
                  dd __float32__(52.2014) ;A[0,4]
                  dd __float32__(42.1234) ;A[1,0]
                  dd __float32__(49.1230) ;A[1,1]
                  dd __float32__(95.2314) ;A[1,2]
                  dd __float32__(42.2391) ;A[1,3]
                  dd __float32__(69.2405) ;A[1,4]
                  dd __float32__(85.5213) ;A[2,0]
                  dd __float32__(64.2356) ;A[2,1]
                  dd __float32__(33.1456) ;A[2,2]
                  dd __float32__(63.3524) ;A[2,3]
                  dd __float32__(64.3777) ;A[2,4]

    align 16, db 0
    dataMatrix_B: dd __float32__(52.1234) ;B[0,0]
                  dd __float32__(97.3125) ;B[0,1]
                  dd __float32__(12.5512) ;B[0,2]
                  dd __float32__(86.3215) ;B[0,3]
                  dd __float32__(92.9642) ;B[0,4]
                  dd __float32__(12.1524) ;B[1,0]
                  dd __float32__(42.5214) ;B[1,1]
                  dd __float32__(30.1255) ;B[1,2]
                  dd __float32__(42.3215) ;B[1,3]
                  dd __float32__(53.5124) ;B[1,4]
                  dd __float32__(90.4215) ;B[2,0]
                  dd __float32__(50.2050) ;B[2,1]
                  dd __float32__(53.1246) ;B[2,2]
                  dd __float32__(43.6534) ;B[2,3]
                  dd __float32__(86.9240) ;B[2,4]

section .bss

    align 16, resb 1
    dataMatrix_C: resd (3*5)
