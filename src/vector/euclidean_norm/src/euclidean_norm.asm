;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: euclidean_norm
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 04-APR-2015
;
;           CONTRIBUTORS: ---
;
;               LANGUAGE: x86 Assembly Language
;                 SYNTAX: Intel
;              ASSEMBLER: NASM
;           ARCHITECTURE: i386
;                 KERNEL: Linux 32-bit
;                 FORMAT: elf32
;
;     REQ EXTERNAL FILES: ---
;
;                VERSION: 0.1.0
;                 STATUS: Alpha
;                   BUGS: --- <See doc/bugs/index file>
;
;       REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global euclidean_norm

section .text

euclidean_norm:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = flag       : DWORD  (Input Only)
;parameter 3) ECX = index      : DWORD  (Input Only)
;returns XMM0 = result : SCALAR SINGLE-PRECISION

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 12
    mov    [esp     ], eax    ;pSrcMatrix
    mov    [esp +  4], ebx    ;flag
    mov    [esp +  8], ecx    ;index

    ;Done setting up local variables

    ;Check whether to use row vector or column vector
    ;operation.
    mov    eax, [esp + 4]     ;EAX = flag
    and    eax, 0b01
    jz     .is_row_vector

.is_column_vector:
    ;EBX = pSrcMatrix.rowSize (jumpSize)
    ;EDX = index*columnSize (offset)
    ;ECX = numOfRows
    mov    ebx, [esp]         ;EBX = pSrcMatrix
    add    ebx, (3*4)         ;EBX = .rowSize
    mov    ebx, [ebx]
    mov    eax, [esp]         ;EAX = pSrcMatrix
    add    eax, (2*4)         ;EAX = .columnSize
    mov    eax, [eax]
    mul    ecx                ;EAX = index * columnSize
    mov    edx, eax           ;EDX = EAX
    mov    ecx, [esp]         ;ECX = pSrcMatrix.numOfRows
    mov    ecx, [ecx]
    jmp    .done_check_ops_type

.is_row_vector:
    ;EBX = pSrcMatrix.columnSize (jumpSize)
    ;EDX = index*rowSize (offset)
    ;ECX = numOfColumns
    mov    ebx, [esp]         ;EBX = pSrcMatrix
    add    ebx, (2*4)         ;EBX = .columnSize
    mov    ebx, [ebx]
    mov    eax, [esp]         ;EAX = pSrcMatrix
    add    eax, (3*4)         ;EAX = .rowSize
    mov    eax, [eax]
    mul    ecx                ;EAX = index * rowSize
    mov    edx, eax           ;EDX = EAX
    mov    ecx, [esp]         ;ECX = pSrcMatrix
    add    ecx, (1*4)         ;ECX = .numOfColumns
    mov    ecx, [ecx]

.done_check_ops_type:

    ;ESI = pSrcMatrix.pData + EDX
    mov    esi, [esp]         ;ESI = pSrcMatrix
    add    esi, (4*4)         ;ESI = .pData
    mov    esi, [esi]
    add    esi, edx           ;ESI += EDX

    pxor   xmm1, xmm1

.loop:

    movss  xmm0, [esi]              ;XMM0 = X[ecx]

    mulss  xmm0, xmm0               ;pow(XMM0,2)
    addss  xmm1, xmm0               ;XMM2 += XMM0

    add    esi, ebx                 ;ESI += EBX

    sub    ecx, 1
    jnz    .loop

.endloop:

    sqrtss xmm0, xmm1               ;XMM0 = sqrt(XMM1)

.return:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
