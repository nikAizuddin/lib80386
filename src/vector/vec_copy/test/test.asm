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
;     DATE CREATED: 09-APR-2015
;
;     TEST PURPOSE: Make sure the vec_copy() have no defects. 
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

extern vec_copy
global _start

section .text

_start:

;B[:,1] = A[:,2]
    lea    eax, [A]         ;srcMatrix
    lea    ebx, [B]         ;dstMatrix
    mov    ecx, 0b11        ;src and dst are column vectors
    mov    edx, 2           ;srcIndex (column number)
    mov    esi, 1           ;dstIndex (column number)
    call   vec_copy

;C[0,:] = A[2,:]
    lea    eax, [A]         ;srcMatrix
    lea    ebx, [C]         ;dstMatrix
    mov    ecx, 0b00        ;src and dst are row vectors
    mov    edx, 2           ;srcIndex (row number)
    mov    esi, 0           ;dstIndex (row number)
    call   vec_copy

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
