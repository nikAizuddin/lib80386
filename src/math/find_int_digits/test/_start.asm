;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 08-JAN-2015
;
;     TEST PURPOSE: Make sure find_int_digits have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;   EXTERNAL FILES: find_int_digits.asm
;
;=====================================================================

extern find_int_digits
global _start

section .bss

    t0001_digits: resd 1

section .data

    t0001_int: dd 0x00139afe

section .text

_start:


;
;
;   TEST 0001
;       Given,
;           t0001_int = 0x00139afe, after calculations
;           the t0001_digits should be 7
;
;   t0001_digits = find_int_digits( t0001_int, 0 )
;
;
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [t0001_int]
    xor    ebx, ebx
    mov    [esp    ], eax           ;arg1: t0001_int
    mov    [esp + 4], ebx           ;arg2: flag=0
    call   find_int_digits
    add    esp, 8                   ;restore 8 bytes
    mov    [t0001_digits], eax      ;save return value


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
