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
;     DATE CREATED: 10-APR-2015
;
;     TEST PURPOSE: Make sure the vec_subtract_vs()
;                   have no defects.
;
;         LANGUAGE: x86 Assembly Language
;        ASSEMBLER: NASM
;           SYNTAX: Intel
;     ARCHITECTURE: x86_64
;           KERNEL: Linux x86
;           FORMAT: elf32
;
;   EXTERNAL FILES: mat_get_element.asm
;
;=====================================================================

;Include constant symbols and global variables
%include "include/constants.inc"
%include "include/data.inc"

extern mat_get_element
extern vec_subtract_vs
global _start

section .text

_start:

;A[:,0] = A[:,0]-B[0,0]
    lea    eax, [B]
    mov    ebx, 0
    mov    ecx, 0
    call   mat_get_element
    lea    eax, [A]
    lea    ebx, [A]
    mov    ecx, 0b11
    mov    edx, 0
    mov    esi, 0
    call   vec_subtract_vs
b1:

;A[:,2] = A[:,2]-B[2,4]
    lea    eax, [B]
    mov    ebx, 2
    mov    ecx, 4
    call   mat_get_element
    lea    eax, [A]
    lea    ebx, [A]
    mov    ecx, 0b11
    mov    edx, 2
    mov    esi, 2
    call   vec_subtract_vs
b2:

;A[2,:] = A[2,:]-B[1,3]
    lea    eax, [B]
    mov    ebx, 1
    mov    ecx, 3
    call   mat_get_element
    lea    eax, [A]
    lea    ebx, [A]
    mov    ecx, 0b00
    mov    edx, 2
    mov    esi, 2
    call   vec_subtract_vs
b3:

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
