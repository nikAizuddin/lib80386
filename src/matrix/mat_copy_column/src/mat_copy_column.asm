;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: mat_copy_column
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

global mat_copy_column

section .text

mat_copy_column:

;parameter 1) addr_srcMat:EAX
;parameter 2) addr_dstMat:EBX
;parameter 3) numOfRows:ECX
;parameter 4) rowSize:EDX
;returns ---

    mov    esi, eax
    mov    edi, ebx

.loop_copy_column:

    movss  xmm0, [esi]         ;XMM0 = A[:,2]
    movss  [edi], xmm0         ;B[:,1] = XMM0

    add    esi, edx            ;point ESI to next row
    add    edi, edx            ;point EDI to next row

    sub    ecx, 1
    jnz    .loop_copy_column

.endloop_copy_column:

    ret
