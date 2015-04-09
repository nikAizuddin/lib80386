;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_copy
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

global vec_copy

section .text

vec_copy:

;parameter 1) addr_srcMat:ESI
;parameter 2) src_jumpSize:EBX
;parameter 3) addr_dstMat:EDI
;parameter 4) dst_jumpSize:EDX
;parameter 5) numOfElements:ECX
;returns ---

.loop_vec_copy:

    movss  xmm0, [esi]         ;XMM0 = A[?]
    movss  [edi], xmm0         ;B[?] = XMM0

    add    esi, ebx            ;point ESI to next element
    add    edi, edx            ;point EDI to next element

    sub    ecx, 1
    jnz    .loop_vec_copy

.endloop_vec_copy:

    ret
