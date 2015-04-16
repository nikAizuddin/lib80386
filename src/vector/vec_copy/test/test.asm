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
    mov    eax, [A.columnSize]    ;ECX = srcOffset
    mov    ebx, 2
    mul    ebx
    mov    ecx, eax
    mov    eax, [B.columnSize]    ;EDX = dstOffset
    mov    ebx, 1
    mul    ebx
    mov    edx, eax
    lea    eax, [A]               ;EAX = @A
    lea    ebx, [B]               ;EBX = @B
    mov    si, [A.rowSize]        ;LOW ESI  = srcJumpSize
    shl    esi, 16
    add    si, [B.rowSize]        ;HIGH ESI = dstJumpSize
    mov    edi, [A.numOfRows]     ;EDI = A.numOfRows
    call   vec_copy

;C[0,:] = A[2,:]
    mov    eax, [A.rowSize]       ;ECX = srcOffset
    mov    ebx, 2
    mul    ebx
    mov    ecx, eax
    mov    edx, 0                 ;EDX = dstOffset
    lea    eax, [A]               ;EAX = @A
    lea    ebx, [C]               ;EBX = @B
    mov    si, [A.columnSize]     ;LOW ESI = srcJumpSize
    shl    esi, 16
    add    si, [B.columnSize]     ;HIGH ESI = dstJumpSize
    mov    edi, [A.numOfColumns]  ;EDI = numOfElements
    call   vec_copy

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
