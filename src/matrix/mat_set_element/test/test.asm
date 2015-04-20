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
;     TEST PURPOSE: Make sure the mat_set_element() have no defects. 
;
;         LANGUAGE: x86 Assembly Language
;        ASSEMBLER: NASM
;           SYNTAX: Intel
;     ARCHITECTURE: x86_64
;           KERNEL: Linux x86
;           FORMAT: elf32
;
;   EXTERNAL FILES: mat_get_element
;
;=====================================================================

;Include constant symbols and global variables
%include "include/constants.inc"
%include "include/data.inc"

extern mat_get_element
extern mat_set_element
global _start

section .text

_start:

;B[1,3] = A[1,3]
    lea    eax, [A]
    mov    ebx, 1
    mov    ecx, 3
    call   mat_get_element
    lea    eax, [B]
    mov    ebx, 1
    mov    ecx, 3
    call   mat_set_element

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
