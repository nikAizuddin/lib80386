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
;     DATE CREATED: 13-APR-2015
;
;     TEST PURPOSE: Make sure the vec_max_absvalue()
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

extern vec_max_absvalue
global _start

section .text

_start:

;B = max( abs(A[:,2]) )
    lea    eax, [A]
    mov    ebx, 0b1
    mov    ecx, 2
    call   vec_max_absvalue
    movss  [B], xmm0

;C = max( abs(A[0,:]) )
    lea    eax, [A]
    mov    ebx, 0b0
    mov    ecx, 0
    call   vec_max_absvalue
    movss  [C], xmm0

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
