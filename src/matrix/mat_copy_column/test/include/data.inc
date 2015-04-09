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


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; B = destination matrix with size 9x9
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, resb 1
    B:    resd (9*9)


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; A = source matrix with size 9x9
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, db 0
    A:    ;row 0
          dd __float32__(0.1) ;A[0,0]
          dd __float32__(1.4) ;A[0,1]
          dd __float32__(3.3) ;A[0,2]
          dd __float32__(3.9) ;A[0,3]
          dd __float32__(4.4) ;A[0,4]
          dd __float32__(1.0) ;A[0,5]
          dd __float32__(6.8) ;A[0,6]
          dd __float32__(7.2) ;A[0,7]
          dd __float32__(8.0) ;A[0,8]

          ;row 1
          dd __float32__(2.0) ;A[1,0]
          dd __float32__(9.7) ;A[1,1]
          dd __float32__(5.3) ;A[1,2]
          dd __float32__(8.5) ;A[1,3]
          dd __float32__(4.2) ;A[1,4]
          dd __float32__(8.3) ;A[1,5]
          dd __float32__(4.1) ;A[1,6]
          dd __float32__(6.5) ;A[1,7]
          dd __float32__(8.6) ;A[1,8]

          ;row 2
          dd __float32__(7.9) ;A[2,0]
          dd __float32__(4.6) ;A[2,1]
          dd __float32__(8.8) ;A[2,2]
          dd __float32__(5.7) ;A[2,3]
          dd __float32__(9.3) ;A[2,4]
          dd __float32__(5.7) ;A[2,5]
          dd __float32__(8.9) ;A[2,6]
          dd __float32__(5.5) ;A[2,7]
          dd __float32__(3.2) ;A[2,8]

          ;row 3
          dd __float32__(1.4) ;A[3,0]
          dd __float32__(8.7) ;A[3,1]
          dd __float32__(4.5) ;A[3,2]
          dd __float32__(7.9) ;A[3,3]
          dd __float32__(3.4) ;A[3,4]
          dd __float32__(5.7) ;A[3,5]
          dd __float32__(9.5) ;A[3,6]
          dd __float32__(5.3) ;A[3,7]
          dd __float32__(3.9) ;A[3,8]

          ;row 4
          dd __float32__(0.0) ;A[4,0]
          dd __float32__(1.0) ;A[4,1]
          dd __float32__(2.0) ;A[4,2]
          dd __float32__(3.0) ;A[4,3]
          dd __float32__(4.0) ;A[4,4]
          dd __float32__(5.0) ;A[4,5]
          dd __float32__(6.0) ;A[4,6]
          dd __float32__(7.0) ;A[4,7]
          dd __float32__(8.0) ;A[4,8]

          ;row 5
          dd __float32__(0.0) ;A[5,0]
          dd __float32__(1.0) ;A[5,1]
          dd __float32__(2.0) ;A[5,2]
          dd __float32__(3.0) ;A[5,3]
          dd __float32__(4.0) ;A[5,4]
          dd __float32__(5.0) ;A[5,5]
          dd __float32__(6.0) ;A[5,6]
          dd __float32__(7.0) ;A[5,7]
          dd __float32__(8.0) ;A[5,8]

          ;row 6
          dd __float32__(0.0) ;A[6,0]
          dd __float32__(1.0) ;A[6,1]
          dd __float32__(2.0) ;A[6,2]
          dd __float32__(3.0) ;A[6,3]
          dd __float32__(4.0) ;A[6,4]
          dd __float32__(5.0) ;A[6,5]
          dd __float32__(6.0) ;A[6,6]
          dd __float32__(7.0) ;A[6,7]
          dd __float32__(8.0) ;A[6,8]

          ;row 7
          dd __float32__(0.0) ;A[7,0]
          dd __float32__(1.0) ;A[7,1]
          dd __float32__(2.0) ;A[7,2]
          dd __float32__(3.0) ;A[7,3]
          dd __float32__(4.0) ;A[7,4]
          dd __float32__(5.0) ;A[7,5]
          dd __float32__(6.0) ;A[7,6]
          dd __float32__(7.0) ;A[7,7]
          dd __float32__(8.0) ;A[7,8]

          ;row 8
          dd __float32__(0.0) ;A[8,0]
          dd __float32__(1.0) ;A[8,1]
          dd __float32__(2.0) ;A[8,2]
          dd __float32__(3.0) ;A[8,3]
          dd __float32__(4.0) ;A[8,4]
          dd __float32__(5.0) ;A[8,5]
          dd __float32__(6.0) ;A[8,6]
          dd __float32__(7.0) ;A[8,7]
          dd __float32__(8.0) ;A[8,8]
