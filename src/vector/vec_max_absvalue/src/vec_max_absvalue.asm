;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_max_absvalue
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 13-APR-2015
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

global vec_max_absvalue

section .text

vec_max_absvalue:

;parameter 1) addr_srcVec:ESI
;parameter 2) vec_jumpSize:EBX
;parameter 3) numOfElements:ECX
;returns ---

    movss  xmm0, [esi]
    mulss  xmm0, xmm0
    sqrtss xmm0, xmm0

.loop_max_absvalue:

    movss   xmm1, [esi]
    mulss   xmm1, xmm1
    sqrtss  xmm1, xmm1
    ucomiss xmm1, xmm0
    jb      .xmm1_lessthan_xmm0
    .xmm1_morethan_xmm0:
    movdqa  xmm0, xmm1
    .xmm1_lessthan_xmm0:

    add    esi, ebx

    sub    ecx, 1
    jnz    .loop_max_absvalue

.endloop_max_absvalue:

    ret
