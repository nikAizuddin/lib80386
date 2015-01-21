;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    pow_int.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 10-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;    EXTERNAL FILES: pow_int.asm
;
;=====================================================================

extern pow_int
global _start

section .bss

    result: resd 1

section .data

    base:  dd 0x00000009
    power: dd 0x00000005

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   result = pow_int( base, power );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [base]
    xor    ebx, [power]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [result], eax            ;save return value


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
