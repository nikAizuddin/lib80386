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
;     TEST PURPOSE: Make sure the vec_normalize_0_1()
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

extern vec_normalize_0_1
global _start

section .text

_start:

;B[:,0] = A[:,0] / max( abs(A[:,0]) )
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 0
    mov    esi, 0
    call   vec_normalize_0_1

;B[:,1] = A[:,1] / max( abs(A[:,1]) )
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 1
    mov    esi, 1
    call   vec_normalize_0_1

;B[:,2] = A[:,2] / max( abs(A[:,2]) )
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 2
    mov    esi, 2
    call   vec_normalize_0_1

;B[:,3] = A[:,3] / max( abs(A[:,3]) )
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 3
    mov    esi, 3
    call   vec_normalize_0_1

;B[:,4] = A[:,4] / max( abs(A[:,4]) )
    lea    eax, [A]
    lea    ebx, [B]
    mov    ecx, 0b11
    mov    edx, 4
    mov    esi, 4
    call   vec_normalize_0_1

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
