;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_hex2dec.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 04-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;    EXTERNAL FILES: cvt_hex2dec.asm
;
;=====================================================================

extern cvt_hex2dec
global _start

section .bss

    decimal_number: resd 1

section .data

    hexadecimal_number: dd 0x00bc614e  ;+12345678

section .text

_start:


;
;
;   Convert hexadecimal_number to decimal_number.
;   Given,
;       hexadecimal_number = 0x00bc614e,
;       the decimal_number should be 0x12345678
;
;   decimal_number = cvt_hex2dec( hexadecimal_number );
;
;
    sub    esp, 4                      ;reserve 4 bytes
    mov    eax, [hexadecimal_number]
    mov    [esp], eax
    call   cvt_hex2dec
    add    esp, 4                      ;restore 4 bytes
    mov    [decimal_number], eax       ;save return value


.exit:
    mov    eax, 0x01                   ;systemcall exit
    mov    ebx, 0x00                   ;return 0
    int    0x80
