;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    string_compare.
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
;    EXTERNAL FILES: string_compare.asm
;
;=====================================================================

extern string_compare
global _start

section .bss

    result: resd 1

section .rodata

    string1: db "Hello World"
    string2: db "Hello lib80386"

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Compares the first 5 characters of string1 and string2.
;
;   result = string_compare( @string1, @string2, 5 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 12                  ;reserve 12 bytes
    lea    eax, [string1]
    lea    ebx, [string2]
    mov    ecx, 5
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   string_compare
    add    esp, 12                  ;restore 12 bytes
    mov    [result], eax


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
