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
;     TEST PURPOSE: Make sure cvt_int2string have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: cvt_int2string.asm,
;                   cvt_hex2dec.asm,
;                   cvt_dec2string.asm,
;                   find_int_digits.asm,
;                   string_append.asm
;
;=====================================================================

extern cvt_int2string
global _start

section .bss

    string: resd 4
    strlen: resd 1

section .rdata

    integer_number: dd 2147483646

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert integer_number to string
;
;   For example,
;       Given integer_number = 0x7ffffffe (2147483646),
;       The string should have:
;           string[0] = 0x37343132
;           string[1] = 0x36333834
;           string[2] = 0x00003634
;           string[3] = 0x00000000
;       and the strlen should have: 0x0000000a
;
;   cvt_int2string( integer_number,
;                   @string,
;                   @strlen,
;                   1 )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [integer_number]
    mov    ebx, string
    mov    ecx, strlen
    mov    edx, 1                   ;flag=1
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_int2string
    add    esp, 16                  ;restore 16 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
