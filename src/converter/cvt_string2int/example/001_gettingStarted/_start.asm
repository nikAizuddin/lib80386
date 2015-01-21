;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_string2int.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 20-JAN-2015
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
;                   pow_int.asm        (required by cvt_string2int)
;
;=====================================================================

extern cvt_string2int
global _start

section .bss

    integer: resd 1

section .rodata

    string: db "1234"
    strlen: dd 4

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   cvt_string2int( @string, strlen, @integer );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 12                  ;reserve 12 bytes
    lea    eax, [string]
    mov    ebx, [strlen]
    lea    ecx, [integer]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   cvt_string2int
    add    esp, 12                  ;restore 12 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80