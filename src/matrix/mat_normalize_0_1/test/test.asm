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
;     DATE CREATED: 21-APR-2015
;
;     TEST PURPOSE: Make sure the mat_normalize_0_1()
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

extern mat_normalize_0_1
global _start

section .text

_start:

    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b1
    call   mat_normalize_0_1

    lea    eax, [A]
    lea    ebx, [C]
    mov    ecx, 0b0
    call   mat_normalize_0_1

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
