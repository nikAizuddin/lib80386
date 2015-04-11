;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_subtract_vv
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 11-APR-2015
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

global vec_subtract_vv

section .text

vec_subtract_vv:

;parameter 1) addr_srcVec1:ESI
;parameter 2) addr_srcVec2:EDI
;parameter 3) addr_dstVec:EAX
;parameter 4) vec_jumpSize:EBX
;parameter 5) numOfElements:ECX
;returns ---

.loop_subtract_vv:

    movss  xmm0, [esi]
    movss  xmm1, [edi]
    subss  xmm0, xmm1

    movss  [eax], xmm0

    add    esi, ebx
    add    edi, ebx
    add    eax, ebx

    sub    ecx, 1
    jnz    .loop_subtract_vv

.endloop_subtract_vv:

    ret
