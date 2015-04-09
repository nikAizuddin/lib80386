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

;Copy column vector A to column vector B
;B[:,3] = A[:,7]
    lea    esi, [A + (7*COLUMNSIZE)]
    mov    ebx, ROWSIZE
    lea    edi, [B + (3*COLUMNSIZE)]
    mov    edx, ROWSIZE
    mov    ecx, NUM_OF_ROWS
    call   vec_copy

;Copy row vector A to row vector B
;B[6,:] = A[2,:]
    lea    esi, [A + (2*ROWSIZE)]
    mov    ebx, COLUMNSIZE
    lea    edi, [B + (6*ROWSIZE)]
    mov    edx, COLUMNSIZE
    mov    ecx, NUM_OF_COLUMNS
    call   vec_copy

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
