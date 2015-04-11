;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_divide_elements
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 10-APR-2015
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

global vec_divide_elements

section .text

vec_divide_elements:

;parameter 1) addr_srcVec:ESI
;parameter 2) addr_dstVec:EDI
;parameter 3) factor:XMM0[scalar_single-precision]
;parameter 4) vec_jumpSize:EBX
;parameter 5) numOfElements:ECX
;returns ---

.loop_divide_elements:

    movss  xmm1, [esi]
    divss  xmm1, xmm0
    movss  [edi], xmm1

    add    esi, ebx
    add    edi, ebx

    sub    ecx, 1
    jnz    .loop_divide_elements

.endloop_divide_elements:

    ret