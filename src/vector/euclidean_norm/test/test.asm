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

extern euclidean_norm
global _start

section .text

_start:

    ;B = norm(A[0,:])
    lea    eax, [A]
    mov    ebx, 0b0
    mov    ecx, 0
    call   euclidean_norm
    movss  [B], xmm0

    ;C = norm(A[:,0])
    lea    eax, [A]
    mov    ebx, 0b1
    mov    ecx, 0
    call   euclidean_norm
    movss  [C], xmm0

    ;D = norm(A[2,:])
    lea    eax, [A]
    mov    ebx, 0b0
    mov    ecx, 2
    call   euclidean_norm
    movss  [D], xmm0

    ;E = norm(A[:,1])
    lea    eax, [A]
    mov    ebx, 0b1
    mov    ecx, 1
    call   euclidean_norm
    movss  [E], xmm0

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
