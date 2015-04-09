;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_dotproduct
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 09-APR-2015
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

global vec_dotproduct

section .text

vec_dotproduct:

;parameter 1) addr_vec1:ESI
;parameter 2) vec1_jumpSize:EBX
;parameter 3) addr_vec2:EDI
;parameter 4) vec2_jumpSize:EDX
;parameter 5) numOfElements:ECX
;returns result:XMM0

    pxor   xmm0, xmm0

.loop_dotproduct:

    movss  xmm1, [esi]
    movss  xmm2, [edi]

    mulss  xmm1, xmm2
    addss  xmm0, xmm1

    add    esi, ebx
    add    edi, edx

    sub    ecx, 1
    jnz    .loop_dotproduct

.endloop_dotproduct:

    ret
