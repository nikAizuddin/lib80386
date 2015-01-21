;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_dec2hex.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 19-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;    EXTERNAL FILES: cvt_dec2hex.asm
;
;=====================================================================

extern cvt_dec2hex
global _start

section .bss

    hexadecimal_number: resd 1

section .rodata

    decimal_number: dd 0x99999999

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   hexadecimal_number = cvt_dec2hex( decimal_number );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [decimal_number]
    mov    [esp], eax
    call   cvt_dec2hex
    add    esp, 4                   ;restore 4 bytes
    mov    [hexadecimal_number], eax


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

