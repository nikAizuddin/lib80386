;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_string2dec.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 12-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;    EXTERNAL FILES: cvt_string2dec.asm
;
;=====================================================================

extern cvt_string2dec
global _start

section .bss

    decimal: resd 2
    digits:  resd 1

section .data

    string: dd "4294", "9672", "95"
    strlen: dd 10

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   cvt_string2dec( @t0003_string,
;                   t0003_strlen,
;                   @t0003_decimal,
;                   @t0003_digits )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [string]
    mov    ebx, [strlen]
    lea    ecx, [decimal]
    lea    edx, [digits]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
