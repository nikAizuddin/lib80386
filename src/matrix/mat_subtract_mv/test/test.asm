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
;     DATE CREATED: 26-APR-2015
;
;     TEST PURPOSE: Make sure the mat_subtract_mv()
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

extern mat_subtract_mv
global _start

section .text

_start:

    ;D = A - repmat( B[:,1], 1, 3 )
    lea    eax, [A]
    lea    ebx, [B]
    lea    ecx, [D]
    mov    edx, 0b1 ;B is column vector
    mov    esi, 1   ;B column index
    call   mat_subtract_mv

    ;E = B - repmat(C,1,3)
    lea    eax, [B]
    lea    ebx, [C]
    lea    ecx, [E]
    mov    edx, 0b1 ;C is column vector
    mov    esi, 0   ;C column index
    call   mat_subtract_mv

    ;F = B - repmat( A[1,:], 5, 1 )
    lea    eax, [B]
    lea    ebx, [A]
    lea    ecx, [F]
    mov    edx, 0b0 ;A is row vector
    mov    esi, 1   ;A row index
    call   mat_subtract_mv

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
