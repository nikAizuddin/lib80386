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
;     DATE CREATED: 11-APR-2015
;
;     TEST PURPOSE: Make sure the vec_subtract_vv()
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

extern vec_subtract_vv
global _start

section .text

_start:

;C[:,1] = A[:,2] - B[:,1]
    lea    eax, [A]
    lea    ebx, [B]
    lea    ecx, [C]
    mov    edx, 0b111
    mov    esi, (2 | (1<<16))
    mov    edi, 1
    call   vec_subtract_vv
b1:

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
