;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 003: Convert larger hexadecimal value
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    cvt_hex2dec on hexadecimal value larger
;                    than 0x05F5E0FF.
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
;
;    EXTERNAL FILES: cvt_hex2dec.asm
;
;=====================================================================

extern cvt_hex2dec
global _start

section .bss

    decimal_number0: resd 1
    decimal_number1: resd 1
    quotient:        resd 1
    remainder:       resd 1

section .data

    hexadecimal_number: dd 0xffffffd6  ;+4294967254

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert larger hexadecimal number to decimal number
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Given,
;       hexadecimal_number = 0xffffffd6,
;       the quotient should be 0x0000002a, and
;       the remainder should be 0x05a915d6.
;
;   quotient = hexadecimal_number / 100000000
;   remainder = the remainder from the division.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [hexadecimal_number]
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx
    mov    [quotient], eax
    mov    [remainder], edx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Given,
;       hexadecimal_number = 0xffffffd6,
;       quotient = 0x0000002a,
;       remainder = 0x05a915d6,
;
;       decimal_number0 should be 0x94967254, and
;       decimal_number1 should be 0x00000042.
;
;   Therefore,
;       The decimal number will become 4294967254.
;
;       +-----------------+-----------------+
;       | decimal_number1 | decimal_number0 |
;       +-----------------+-----------------+
;       |    0x00000042   |   0x94967254    |
;       +-----------------+-----------------+
;       |        0x0000004294967254         |
;       +-----------------------------------+
;
;   decimal_number0 = cvt_hex2dec( remainder );
;   decimal_number1 = cvt_hex2dec( quotient );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                      ;reserve 4 bytes
    mov    eax, [remainder]
    mov    [esp], eax
    call   cvt_hex2dec
    mov    [decimal_number0], eax

    mov    eax, [quotient]
    mov    [esp], eax
    call   cvt_hex2dec
    mov    [decimal_number1], eax
    add    esp, 4                      ;restore 4 bytes


exit:
    mov    eax, 0x01 ;systemcall exit
    mov    ebx, 0x00 ;return 0
    int    0x80
