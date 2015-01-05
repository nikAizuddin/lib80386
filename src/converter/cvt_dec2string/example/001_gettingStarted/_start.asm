;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_dec2string.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 05-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;    EXTERNAL FILES: cvt_dec2string.asm
;
;=====================================================================

extern cvt_dec2string
global _start

section .bss

    string: resd 2
    strlen: resd 1

section .data

    decimal_number: dd 0x00000256

section .text

_start:


;
;
;   Convert decimal number to ASCII string.
;
;   cvt_dec2string( @decimal_number,
;                   1,
;                   @string,
;                   @strlen )
;
;
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, decimal_number
    mov    ebx, 1
    mov    ecx, string
    mov    edx, strlen
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes

.exit:
    mov    eax, 0x01                ;systemcall exit
    mov    ebx, 0x00                ;return 0
    int    0x80

