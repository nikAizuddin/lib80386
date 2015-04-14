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
;     DATE CREATED: 14-APR-2015
;
;     TEST PURPOSE: Make sure the mat_multiply()
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

extern mat_multiply
global _start

section .text

_start:

    ;C = A*B
    lea    eax, [A]
    lea    ebx, [B]
    lea    ecx, [C]
    call   mat_multiply

    ;D = B*A
    lea    eax, [B]
    lea    ebx, [A]
    lea    ecx, [D]
    call   mat_multiply

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
