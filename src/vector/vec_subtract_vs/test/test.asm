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
;   EXTERNAL FILES: ---
;
;=====================================================================

;Include constant symbols and global variables
%include "include/constants.inc"
%include "include/data.inc"

extern vec_subtract_vs
global _start

section .text

_start:

;A[:,0] = A[:,0]-B[0,0]
    lea    esi, [A]
    lea    edi, [A]
    movss  xmm0, [B]
    mov    ebx, ROWSIZE
    mov    ecx, NUM_OF_ROWS
    call   vec_subtract_vs
b1:

;A[:,2] = A[:,2]-B[2,4]
    lea    esi, [A+(2*COLUMNSIZE)]
    lea    edi, [A+(2*COLUMNSIZE)]
    movss  xmm0, [B+((2*ROWSIZE)+(4*COLUMNSIZE))]
    mov    ebx, ROWSIZE
    mov    ecx, NUM_OF_ROWS
    call   vec_subtract_vs
b2:

;A[2,:] = A[2,:]-B[1,3]
    lea    esi, [A+(2*ROWSIZE)]
    lea    edi, [A+(2*ROWSIZE)]
    movss  xmm0, [B+((1*ROWSIZE)+(3*COLUMNSIZE))]
    mov    ebx, COLUMNSIZE
    mov    ecx, NUM_OF_COLUMNS
    call   vec_subtract_vs
b3:

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
