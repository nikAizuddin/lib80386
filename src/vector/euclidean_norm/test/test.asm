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
;     DATE CREATED: 05-APR-2015
;
;     TEST PURPOSE: Make sure the euclidean_norm()
;                   have no errors.
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
%include "constants.inc"
%include "data.inc"

extern euclidean_norm
global _start

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Y_T001 = euclidean_norm(@X, ELEMENTSIZE, ELEMENTS)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    eax, [X_T001]
    mov    ebx, ELEMENTSIZE_T001
    mov    ecx, ELEMENTS_T001
    call   euclidean_norm
    movss  [Y_T001], xmm0


exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
