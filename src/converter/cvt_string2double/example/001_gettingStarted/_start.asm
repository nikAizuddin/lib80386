;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_string2double.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 23-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;   EXTERNAL FILES: cvt_string2int.asm
;                   cvt_string2dec.asm (required by cvt_string2int)
;                   cvt_dec2hex.asm    (required by cvt_string2int)
;                   pow_int.asm
;                   find_int_digits.asm
;
;=====================================================================

extern cvt_string2double
global _start

section .bss

    double: resq 1

section .rodata

    string: db "1234.00567", 0x00
    strlen: dd 10

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   double = cvt_string2double ( @string, strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [string]
    mov    ebx, [strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2double
    add    esp, 8                   ;restore 8 bytes
    fst    qword [double]


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80