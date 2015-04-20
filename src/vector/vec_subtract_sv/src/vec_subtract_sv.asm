;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: vec_subtract_sv
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
global vec_subtract_sv

section .text

vec_subtract_sv:

;parameter 1) EAX  = @diminisher : Matrix (Input Only)
;parameter 2) EBX  = @dstMatrix  : Matrix (Input and Output)
;parameter 3) ECX  = flag        : DWORD  (Input Only)
;parameter 4) EDX  = dimIndex    : DWORD  (Input Only)
;parameter 5) ESI  = dstIndex    : DWORD  (Input Only)
;parameter 6) XMM0 = base : SCALAR SINGLE-PRECISION (Input Only)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 44
    mov    [esp     ], eax        ;pDiminisher
    mov    [esp +  4], ebx        ;pDstMatrix
    mov    [esp +  8], ecx        ;flag
    mov    [esp + 12], edx        ;dimIndex
    mov    [esp + 16], esi        ;dstIndex
    mov    dword [esp + 20], 0    ;dimJumpSize
    mov    dword [esp + 24], 0    ;dimNumOfElements
    mov    dword [esp + 28], 0    ;pDataMatDim
    mov    dword [esp + 32], 0    ;dstJumpSize
    mov    dword [esp + 36], 0    ;dstNumOfElements
    mov    dword [esp + 40], 0    ;pDataMatDst

    ;Done setup local variables

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of matrix diminsher
    mov    esi, [esp]             ;ESI = pDiminisher
    mov    ebx, [esp +  8]        ;EBX = flag for matrix diminisher
    and    ebx, 0b01
    mov    ecx, [esp + 12]        ;ECX = index for matrix diminisher
    call   get_vector_info
    mov    [esp + 20], ebx        ;dimJumpSize = EBX
    mov    [esp + 24], ecx        ;dimNumOfElements = ECX
    mov    [esp + 28], edi        ;pDataMatDim = EDI

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of destination matrix
    mov    esi, [esp +  4]        ;ESI = pDstMatrix
    mov    ebx, [esp +  8]        ;EBX = flag for dstMatrix
    shr    ebx, 1
    mov    ecx, [esp + 16]        ;ECX = index for dstMatrix
    call   get_vector_info
    mov    [esp + 32], ebx        ;dstJumpSize = EBX
    mov    [esp + 36], ecx        ;dstNumOfElements = ECX
    mov    [esp + 40], edi        ;pDataMatDst = EDI

    mov    esi, [esp + 28]        ;ESI = pDataMatDim
    mov    ebx, [esp + 20]        ;EBX = dimJumpSize
    mov    ecx, [esp + 24]        ;ECX = dimNumOfElements
    mov    edi, [esp + 40]        ;EDI = pDataMatDst
    mov    edx, [esp + 32]        ;EDX = dstJumpSize

    ;XMM0 = base (from the input parameter)

.loop:

    movss  xmm2, xmm0
    movss  xmm1, [esi]
    subss  xmm2, xmm1
    movss  [edi], xmm2

    add    esi, ebx
    add    edi, edx

    sub    ecx, 1
    jnz    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
