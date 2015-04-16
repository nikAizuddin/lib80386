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

    A:
        .numOfRows:     dd 4
        .numOfColumns:  dd 4
        .columnSize:    dd 4            ;single-precision elements
        .rowSize:       dd (4*4)        ;numOfColumns * columnSize
        .pData:         dd dataMatrix_A

    Q:
        .numOfRows:     dd 4
        .numOfColumns:  dd 4
        .columnSize:    dd 4            ;single-precision elements
        .rowSize:       dd (4*4)        ;numOfColumns * columnSize
        .pData:         dd dataMatrix_Q

    R:
        .numOfRows:     dd 4
        .numOfColumns:  dd 4
        .columnSize:    dd 4            ;single-precision elements
        .rowSize:       dd (4*4)        ;numOfColumns * columnSize
        .pData:         dd dataMatrix_R

    tempMat:
        .numOfRows:     dd 4
        .numOfColumns:  dd 4
        .columnSize:    dd 4            ;single-precision elements
        .rowSize:       dd (4*4)        ;numOfColumns * columnSize
        .pData:         dd dataMatrix_tempMat

    tempVec:
        .numOfElements: dd 4
        .jumpSize:      dd 4            ;single-precision elements
        .pData:         dd dataVector_tempVec

    align 16, db 0
    dataMatrix_A: dd __float32__( 4.000) ;A[0,0]
                  dd __float32__( 0.021) ;A[0,1]
                  dd __float32__(-7.043) ;A[0,2]
                  dd __float32__(21.898) ;A[0,3]
                  dd __float32__( 0.000) ;A[1,0]
                  dd __float32__( 3.000) ;A[1,1]
                  dd __float32__( 0.873) ;A[1,2]
                  dd __float32__( 3.202) ;A[1,3]
                  dd __float32__( 0.000) ;A[2,0]
                  dd __float32__( 0.000) ;A[2,1]
                  dd __float32__( 2.000) ;A[2,2]
                  dd __float32__(-3.642) ;A[2,3]
                  dd __float32__( 0.000) ;A[3,0]
                  dd __float32__( 0.000) ;A[3,1]
                  dd __float32__( 0.000) ;A[3,2]
                  dd __float32__( 1.000) ;A[3,3]

section .bss

    align 16, resb 1
    dataMatrix_Q:          resd (4*4)
    dataMatrix_R:          resd (4*4)
    dataMatrix_tempMat:    resd (4*4)
    dataVector_tempVec:    resd 4

