;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                           *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;            EMAIL: nickaizuddin93@gmail.com
;     DATE CREATED: 12-APR-2015
;
;     TEST PURPOSE: Make sure the vec_max_value()
;                   have no defects.
;
;         LANGUAGE: x86 Assembly Language
;        ASSEMBLER: NASM
;           SYNTAX: Intel
;     ARCHITECTURE: x86_64
;           KERNEL: Linux x86
;           FORMAT: elf32
;
;   EXTERNAL FILES: ---
;
;=====================================================================

;Include constant symbols and global variables
%include "include/constants.inc"
%include "include/data.inc"

extern vec_max_value
global _start

section .text

_start:

;B = max(A[:,2])
    lea    esi, [A+(2*COLUMNSIZE)]
    mov    ebx, ROWSIZE
    mov    ecx, NUM_OF_ROWS
    call   vec_max_value
    movss  [B], xmm0

;C = max(A[0,:])
    lea    esi, [A]
    mov    ebx, COLUMNSIZE
    mov    ecx, NUM_OF_COLUMNS
    call   vec_max_value
    movss  [C], xmm0

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
