;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: vec_absolute_value
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 12-APR-2015
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
global vec_absolute_value

section .text

vec_absolute_value:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = @dstMatrix : Matrix (Input and Output)
;parameter 3) ECX = flag       : DWORD  (Input Only)
;parameter 4) EDX = srcIndex   : DWORD  (Input Only)
;parameter 5) ESI = dstIndex   : DWORD  (Input Only)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 44
    mov    [esp     ], eax        ;pSrcMatrix
    mov    [esp +  4], ebx        ;pDstMatrix
    mov    [esp +  8], ecx        ;flag
    mov    [esp + 12], edx        ;srcIndex
    mov    [esp + 16], esi        ;dstIndex
    mov    dword [esp + 20], 0    ;srcJumpSize
    mov    dword [esp + 24], 0    ;srcNumOfElems
    mov    dword [esp + 28], 0    ;pSrcDataMat
    mov    dword [esp + 32], 0    ;dstJumpSize
    mov    dword [esp + 36], 0    ;srcNumOfElems
    mov    dword [esp + 40], 0    ;pSrcDataMat

    ;Done setup local variables

    ;Get jumpSize, numOfElements, and pointer to dataMatrix
    ;of the source matrix.
    mov    esi, [esp     ]        ;ESI = pSrcMatrix
    mov    ebx, [esp +  8]        ;EBX = flag for source matrix
    and    ebx, 0b01
    mov    ecx, [esp + 12]        ;ECX = srcIndex
    call   get_vector_info
    mov    [esp + 20], ebx        ;srcJumpSize
    mov    [esp + 24], ecx        ;srcNumOfElements
    mov    [esp + 28], edi        ;pSrcDataMat

    ;Get jumpSize, numOfElements, and pointer to dataMatrix
    ;of the destination matrix.
    mov    esi, [esp +  4]        ;ESI = pDstMatrix
    mov    ebx, [esp +  8]        ;EBX = flag for destination matrix
    shr    ebx, 1
    mov    ecx, [esp + 16]        ;ECX = dstIndex
    call   get_vector_info
    mov    [esp + 32], ebx        ;dstJumpSize
    mov    [esp + 36], ecx        ;dstNumOfElements
    mov    [esp + 40], edi        ;pDstDataMat

    mov    esi, [esp + 28]        ;ESI = pSrcDataMat
    mov    edi, [esp + 40]        ;EDI = pDstDataMat
    mov    ecx, [esp + 24]        ;ECX = srcNumOfElements
    mov    ebx, [esp + 20]        ;EBX = srcJumpSize
    mov    edx, [esp + 32]        ;EDX = dstJumpSize

.loop:

    movss  xmm0, [esi]
    mulss  xmm0, xmm0
    sqrtss xmm0, xmm0
    movss  [edi], xmm0

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
