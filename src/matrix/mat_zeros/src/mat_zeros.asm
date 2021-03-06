;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: mat_zeros
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

global mat_zeros

section .text

mat_zeros:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = @dstMatrix : Matrix (Input and Output)

    ;EDI = dstMatrix.pData
    mov    edi, ebx
    add    edi, (4*4)
    mov    edi, [edi]

    ;EBX = srcMatrix.columnSize
    mov    ebx, eax
    add    ebx, (4*2)
    mov    ebx, [ebx]

    ;NOTE: dstMatrix is no longer can be referenced.

    ;ECX = srcMatrix.numOfRows * srcMatrix.numOfColumns
    mov    ecx, eax     ;ECX = srcMatrix.numOfRows
    mov    ecx, [ecx]
    add    eax, (4*1)   ;EAX = srcMatrix.numOfColumns
    mov    eax, [eax]
    mul    ecx
    mov    ecx, eax

    ;NOTE: srcMatrix is no longer can be referenced.

    pxor   xmm0, xmm0

.loop:

    movss  [edi], xmm0

    add    esi, ebx
    add    edi, ebx

    sub    ecx, 1
    jnz    .loop

.endloop:

    ret
