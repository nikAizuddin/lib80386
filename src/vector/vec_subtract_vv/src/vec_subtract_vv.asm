;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: vec_subtract_vv
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 11-APR-2015
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
;     REQ EXTERNAL FILES: get_vector_info.asm
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

extern get_vector_info
global vec_subtract_vv

section .text

vec_subtract_vv:

;parameter 1) EAX = @matrix1   : Matrix     (Input Only)
;parameter 2) EBX = @matrix2   : Matrix     (Input Only)
;parameter 3) ECX = @dstMatrix : Matrix     (Input and Output)
;parameter 4) EDX = flag       : DWORD      (Input Only)
;parameter 5) ESI = index1     : LOW DWORD  (Input Only)
;parameter 6) ESI = index2     : HIGH DWORD (Input Only)
;parameter 7) EDI = dstIndex   : DWORD      (Input Only)
;returns ---

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
    mov    ebx, esi
    mov    ecx, esi
    and    ebx, 0xffff
    shr    ecx, 16
    mov    [esp + 16], ebx        ;index1
    mov    [esp + 20], ecx        ;index2
    mov    [esp + 24], edi        ;dstIndex
    mov    dword [esp + 28], 0    ;mat1JumpSize
    mov    dword [esp + 32], 0    ;mat1NumOfElements
    mov    dword [esp + 36], 0    ;pDataMat1
    mov    dword [esp + 40], 0    ;mat2JumpSize
    mov    dword [esp + 44], 0    ;mat2NumOfElements
    mov    dword [esp + 48], 0    ;pDataMat2
    mov    dword [esp + 52], 0    ;dstJumpSize
    mov    dword [esp + 56], 0    ;dstNumOfElements
    mov    dword [esp + 60], 0    ;pDataMatDst

    ;Done setup local variables

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of matrix1
    mov    esi, [esp]             ;ESI = pMatrix1
    mov    ebx, [esp + 12]        ;EBX = flag for matrix1
    and    ebx, 0b001
    mov    ecx, [esp + 16]        ;ECX = index for matrix1
    call   get_vector_info
    mov    [esp + 28], ebx        ;mat1JumpSize = EBX
    mov    [esp + 32], ecx        ;mat1NumOfElements = ECX
    mov    [esp + 36], edi        ;pDataMat1 = EDI

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of matrix2
    mov    esi, [esp +  4]        ;ESI = pMatrix2
    mov    ebx, [esp + 12]        ;EBX = flag for matrix2
    and    ebx, 0b010
    shr    ebx, 1
    mov    ecx, [esp + 20]        ;ECX = index for matrix2
    call   get_vector_info
    mov    [esp + 40], ebx        ;mat2JumpSize = EBX
    mov    [esp + 44], ecx        ;mat2NumOfElements = ECX
    mov    [esp + 48], edi        ;pDataMat2 = EDI

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of destination matrix
    mov    esi, [esp +  8]        ;ESI = pdstMatrix
    mov    ebx, [esp + 12]        ;EBX = flag for dstMatrix
    shr    ebx, 2
    mov    ecx, [esp + 24]        ;ECX = index for dstMatrix
    call   get_vector_info
    mov    [esp + 52], ebx        ;dstJumpSize = EBX
    mov    [esp + 56], ecx        ;dstNumOfElements = ECX
    mov    [esp + 60], edi        ;pDataMatDst = EDI

    mov    eax, [esp + 36]        ;EAX = pDataMat1
    mov    ebx, [esp + 48]        ;EBX = pDataMat2
    mov    ecx, [esp + 32]        ;ECX = mat1NumOfElements
                                  ;EDX = general jumpSize
    mov    esi, [esp + 52]        ;ESI = dstJumpSize
    mov    edi, [esp + 60]        ;EDI = pDataMatDst

.loop:

    movss  xmm0, [eax]
    movss  xmm1, [ebx]
    subss  xmm0, xmm1
    movss  [edi], xmm0

    mov    edx, [esp + 28]        ;EDX = mat1JumpSize
    add    eax, edx
    mov    edx, [esp + 40]        ;EDX = mat2JumpSize
    add    ebx, edx
    add    edi, esi

    sub    ecx, 1
    jnz    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
