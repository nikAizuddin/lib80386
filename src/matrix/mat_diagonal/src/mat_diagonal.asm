;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: mat_diagonal
;     DOCUMENTATIONS: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 15-APR-2015
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
; REQ EXTERNAL FILES: ---
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

global mat_diagonal

section .text

mat_diagonal:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = @dstVector : Vector (Input and Output)

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 36
    mov    [esp     ], eax    ;pSrcMatrix
    mov    [esp +  4], ebx    ;pDstVector

    mov    ecx, eax
    add    ecx, (4*4)
    mov    ecx, [ecx]
    mov    [esp +  8], ecx    ;pDataSrcMat

    mov    edx, ebx
    add    edx, (4*4)
    mov    edx, [edx]
    mov    [esp + 12], edx    ;pDataDstVec

    mov    ecx, eax
    add    ecx, (4*3)
    mov    ecx, [ecx]
    mov    [esp + 16], ecx    ;srcMatRowSize

    mov    ecx, eax
    add    ecx, (4*2)
    mov    ecx, [ecx]
    mov    [esp + 20], ecx    ;srcMatColSize

    mov    edx, ebx
    add    edx, (4*2)
    mov    edx, [edx]
    mov    [esp + 24], edx    ;dstVecJumpSize

    mov    ecx, eax
    mov    ecx, [ecx]
    mov    [esp + 28], ecx    ;srcMatRows

    mov    ecx, eax
    add    ecx, (4*1)
    mov    ecx, [ecx]
    mov    [esp + 32], ecx    ;srcMatCols

    ;Done setting up local variables.

    ;It doesn't matter ECX = srcMatRows or ECX = srcMatCols.
    ;Because the source matrix is a square matrix.
    mov    ecx, [esp + 28]    ;ECX = srcMatRows

    mov    esi, [esp +  8]    ;ESI = pDataSrcMat
    mov    edi, [esp + 12]    ;EDI = pDataDstVec

    mov    eax, [esp + 16]    ;EAX = srcMatRowSize
    mov    ebx, [esp + 20]    ;EBX = srcMatColSize
    mov    edx, [esp + 24]    ;EDX = dstVecJumpSize

.loop:

    movss  xmm0, [esi]        ;XMM0 = pDataSrcMat[EAX,EBX]
    movss  [edi], xmm0        ;pDataDstVec[EDX] = XMM0

    add    esi, eax           ;ESI += srcMatRowSize
    add    esi, ebx           ;ESI += srcMatColSize
    add    edi, edx           ;EDI += dstVecJumpSize

    sub    ecx, 1
    jnz    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
