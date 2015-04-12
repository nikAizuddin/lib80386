;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_absolute_value
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 12-APR-2015
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
;      INCLUDE FILES: ---
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

global vec_absolute_value

section .text

vec_absolute_value:

;parameter 1) addr_srcVec:ESI
;parameter 2) addr_dstVec:EDI
;parameter 3) vec_jumpSize:EBX
;parameter 4) numOfElements:ECX
;returns ---

.loop_absolute_value:

    movss  xmm0, [esi]
    mulss  xmm0, xmm0
    sqrtss xmm0, xmm0
    movss  [edi], xmm0

    add    esi, ebx
    add    edi, ebx

    sub    ecx, 1
    jnz    .loop_absolute_value

.endloop_absolute_value:

    ret
