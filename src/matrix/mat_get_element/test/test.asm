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
;     DATE CREATED: 18-APR-2015
;
;     TEST PURPOSE: Make sure the mat_get_element() have no defects. 
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

extern mat_get_element
global _start

section .text

_start:

;B = A[3,2]
    lea    eax, [A]
    mov    ebx, 3
    mov    ecx, 2
    call   mat_get_element
    movss  [B], xmm0

;C = A[4,1]
    lea    eax, [A]
    mov    ebx, 4
    mov    ecx, 1
    call   mat_get_element
    movss  [C], xmm0

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
