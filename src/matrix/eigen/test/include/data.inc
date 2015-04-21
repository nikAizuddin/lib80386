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
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_A

    eigenvalue:
        .numOfRows:    dd 1
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_eigenvalue

    eigenvector:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_eigenvector

    tempMatrices:
    tempMat1:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_tempMat1
    Q:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_Q
    R:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_R
    u:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_u
    e:
        .numOfRows:    dd 3
        .numOfColumns: dd 3
        .columnSize:   dd 4     ;single-precision elements
        .rowSize:      dd (3*4) ;numOfColumns * columnSize
        .pData:        dd dataMatrix_e


    align 16, db 0
    dataMatrix_A:
          dd __float32__( 11.4445) ;A[0,0]
          dd __float32__(-18.5556) ;A[0,1]
          dd __float32__(  7.1111) ;A[0,2]
          dd __float32__(-18.5556) ;A[1,0]
          dd __float32__( 34.4444) ;A[1,1]
          dd __float32__(-15.8889) ;A[1,2]
          dd __float32__(  7.1111) ;A[2,0]
          dd __float32__(-15.8889) ;A[2,1]
          dd __float32__(  8.7778) ;A[2,2]

section .bss

    align 16, resb 1
    dataMatrix_eigenvalue:  resd (1*3)
    dataMatrix_eigenvector: resd (3*3)
    dataMatrix_tempMat1:    resd (3*3)
    dataMatrix_Q:           resd (3*3)
    dataMatrix_R:           resd (3*3)
    dataMatrix_u:           resd (3*3)
    dataMatrix_e:           resd (3*3)
