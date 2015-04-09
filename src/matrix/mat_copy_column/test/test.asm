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
;     TEST PURPOSE: Make sure the mat_copy_column have no errors. 
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

extern mat_copy_column
global _start

section .text

_start:

;B[:,3] = A[:,7]
    lea    eax, [A + (7*COLUMNSIZE)]
    lea    ebx, [B + (3*COLUMNSIZE)]
    mov    ecx, NUM_OF_ROWS
    mov    edx, ROWSIZE
    call   mat_copy_column

;B[:,6] = A[:,2]
    lea    eax, [A + (2*COLUMNSIZE)]
    lea    ebx, [B + (6*COLUMNSIZE)]
    mov    ecx, NUM_OF_ROWS
    mov    edx, ROWSIZE
    call   mat_copy_column

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
