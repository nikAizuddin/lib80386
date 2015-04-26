;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: mat_subtract_mv
;     DOCUMENTATIONS: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 23-APR-2015
;
;       CONTRIBUTORS: ---
;
;           LANGUAGE: x86 Assembly Language
;             SYNTAX: Intel
;          ASSEMBLER: NASM
;       ARCHITECTURE: i386
;             KERNEL: Linux 32-bit
;             FORMAT: elf32
;
; REQ EXTERNAL FILES: get_vector_info
;
;            VERSION: 0.1.0
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

extern get_vector_info
global mat_subtract_mv

section .text

mat_subtract_mv:

;parameter 1) EAX = @matrix1   : Matrix (Input Only)
;parameter 2) EBX = @matrix2   : Matrix (Input Only)
;parameter 3) ECX = @dstMatrix : Matrix (Input and Output)
;parameter 4) EDX = flag       : DWORD  (Input Only)
;parameter 5) ESI = index      : DWORD  (Input Only)

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 64
    mov    [esp     ], eax        ;pMatrix1
    mov    [esp +  4], ebx        ;pMatrix2
    mov    [esp +  8], ecx        ;pDstMatrix
    mov    [esp + 12], edx        ;flag
    mov    [esp + 16], esi        ;index
    mov    dword [esp + 20], 0    ;vecJumpSize
    mov    dword [esp + 24], 0    ;vecNumOfElem
    mov    dword [esp + 28], 0    ;pDataVec
    mov    dword [esp + 32], 0    ;i
    mov    dword [esp + 36], 0    ;j

    ;mat1MaxRows
    mov    eax, [esp]             ;EAX = pMatrix1.numOfRows
    mov    eax, [eax]             ;get the value
    mov    [esp + 40], eax        ;save the value to stack

    ;mat1MaxCols
    mov    eax, [esp]             ;EAX = pMatrix1
    add    eax, (1*4)             ;EAX = .numOfColumns
    mov    eax, [eax]             ;get the value
    mov    [esp + 44], eax        ;save the value to stack

    ;mat1ColSize
    mov    eax, [esp]             ;EAX = pMatrix1
    add    eax, (2*4)             ;EAX = .columnSize
    mov    eax, [eax]             ;get the value
    mov    [esp + 48], eax        ;save the value to stack

    ;matDstColSize
    mov    eax, [esp +  8]        ;EAX = pDstMatrix
    add    eax, (2*4)             ;EAX = .columnSize
    mov    eax, [eax]             ;get the value
    mov    [esp + 52], eax    ;save the value to stack

    ;pDataMat1
    mov    eax, [esp]             ;EAX = pMatrix1
    add    eax, (4*4)             ;EAX = .pData
    mov    eax, [eax]             ;get the value
    mov    [esp + 56], eax        ;save the value to stack

    ;pDataMatDst
    mov    eax, [esp +  8]        ;EAX = pDstMatrix
    add    eax, (4*4)             ;EAX = .pData
    mov    eax, [eax]             ;get the value
    mov    [esp + 60], eax        ;save the value to stack

;;Done setup local variables

;;Get jumpSize, number of elements, and offsetted
;;memory address of vector dataMatrix in matrix2.

    mov    esi, [esp +  4]        ;ESI = pMatrix2
    mov    ebx, [esp + 12]        ;EBX = flag for matrix2
    mov    ecx, [esp + 16]        ;ECX = index from matrix2
    call   get_vector_info
    mov    [esp + 20], ebx        ;vecJumpSize
    mov    [esp + 24], ecx        ;vecNumOfElements
    mov    [esp + 28], edi        ;pDataVec

;;Initialize values for the loop.

    mov    esi, [esp + 56]        ;ESI = pDataMat1
    mov    edi, [esp + 60]        ;EDI = pDataMatDst
    mov    ebx, [esp + 28]        ;EBX = pDataVec
    mov    ecx, [esp + 32]        ;ECX = i
    mov    edx, [esp + 36]        ;EDX = j

;;Check whether matrix2 vector is a column vector
;;or row vector, and will be jumped to
;;specialized operation.

    mov    eax, [esp + 12]        ;EAX = flag
    test   eax, eax
    jz     .is_rowvector
.is_colvector:
    jmp    .perform_colvector
.is_rowvector:
    jmp    .perform_rowvector


;; *** CAUTION ***
;;ESI, EDI, EBX, ECX, and EDX are reserved.
;;Use only EAX for transfering data.


;;If matrix2 vector is a column vector.

.perform_colvector:

    ;i = mat1MaxRows
    mov    eax, [esp + 40]        ;EAX = mat1MaxRows
    mov    [esp + 32], eax        ;i = EAX

.loop_colvector:

    ;j = mat1MaxCols
    mov    eax, [esp + 44]        ;EAX = mat1MaxCols
    mov    [esp + 36], eax        ;j = EAX

.subloop_colvector:

    ;pDataMatDst[i,j] = pDataMat1[i,j] - pDataVec[i]
    movss  xmm0, [esi]            ;XMM0 = pDataMat1
    movss  xmm1, [ebx]            ;XMM1 = pDataVec
    subss  xmm0, xmm1             ;XMM0 -= XMM1
    movss  [edi], xmm0            ;pDataMatDst = XMM0

    ;pDataMat1 += mat1ColSize
    mov    eax, [esp + 48]        ;EAX = mat1ColSize
    add    esi, eax               ;ESI += EAX

    ;pDataMatDst += matDstColSize
    mov    eax, [esp + 52]        ;EAX = matDstColSize
    add    edi, eax               ;EDI += EAX

    ;--j
    ;subloop_colvector if j != 0
    mov    eax, [esp + 36]        ;EAX = j
    sub    eax, 1                 ;--EAX
    mov    [esp + 36], eax        ;j = EAX
    jnz    .subloop_colvector

.endsubloop_colvector:

    ;pDataVec += vecJumpSize
    mov    eax, [esp + 20]        ;EAX = vecJumpSize
    add    ebx, eax               ;EBX += EAX

    ;--i
    ;loop_colvector if i != 0
    mov    eax, [esp + 32]        ;EAX = i
    sub    eax, 1                 ;--EAX
    mov    [esp + 32], eax        ;i = EAX
    jnz    .loop_colvector

.endloop_colvector:
    jmp    .clean_stackframe


;;If matrix2 vector is a row vector.

.perform_rowvector:

    ;i = mat1MaxRows
    mov    eax, [esp + 40]        ;EAX = mat1MaxRows
    mov    [esp + 32], eax        ;i = EAX

.loop_rowvector:

    ;reset pDataVec to its origin address
    mov    ebx, [esp + 28]        ;EBX = pDataVec

    ;j = mat1MaxCols
    mov    eax, [esp + 44]        ;EAX = mat1MaxCols
    mov    [esp + 36], eax        ;j = EAX

.subloop_rowvector:

    ;pDataMatDst[i,j] = pDataMat1[i,j] - pDataVec[j]
    movss  xmm0, [esi]            ;XMM0 = pDataMat1
    movss  xmm1, [ebx]            ;XMM1 = pDataVec
    subss  xmm0, xmm1             ;XMM0 -= XMM1
    movss  [edi], xmm0            ;pDataMatDst = XMM0

    ;pDataMat1 += mat1ColSize
    mov    eax, [esp + 48]        ;EAX = mat1ColSize
    add    esi, eax               ;ESI += EAX

    ;pDataMatDst += matDstColSize
    mov    eax, [esp + 52]        ;EAX = matDstColSize
    add    edi, eax               ;EDI += EAX

    ;pDataVec += vecJumpSize
    mov    eax, [esp + 20]        ;EAX = vecJumpSize
    add    ebx, eax               ;EBX += EAX

    ;--j
    ;subloop_rowvector if j != 0
    mov    eax, [esp + 36]        ;EAX = j
    sub    eax, 1                 ;--EAX
    mov    [esp + 36], eax        ;j = EAX
    jnz    .subloop_rowvector

.endsubloop_rowvector:

    ;--i
    ;loop_rowvector if i != 0
    mov    eax, [esp + 32]        ;EAX = i
    sub    eax, 1                 ;--EAX
    mov    [esp + 32], eax        ;i = EAX
    jnz    .loop_rowvector

.endloop_rowvector:


.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
