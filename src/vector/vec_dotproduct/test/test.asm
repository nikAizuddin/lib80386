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
;     TEST PURPOSE: Make sure the vec_dotproduct() have no defects.
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

extern vec_dotproduct
global _start

section .text

_start:

;C = A[:,0]'*B[:,0]
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 0
    mov    esi, 0
    call   vec_dotproduct
    movss  [C], xmm0
b1:

;C = A[:,2]'*B[:,4]
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 2
    mov    esi, 4
    call   vec_dotproduct
    movss  [C], xmm0
b2:

;C = A[2,:]*B[1,:]'
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b00
    mov    edx, 2
    mov    esi, 1
    call   vec_dotproduct
    movss  [C], xmm0
b3:

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
