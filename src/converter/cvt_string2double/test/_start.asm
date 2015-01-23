;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 23-JAN-2015
;
;     TEST PURPOSE: Make sure the cvt_string2double have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
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

    t0001_double: resq 1
    t0002_double: resq 1

section .rodata

    t0001_string: db "1234.00567", 0x00
    t0001_strlen: dd 10

    t0002_string: db "-1234.00567", 0x00
    t0002_strlen: dd 11

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given,
;           t0001_string = "1234.00567", after conversion
;           the t0001_double should be 1234.00567
;
;   t0001_double = cvt_string2double ( @t0001_string, t0001_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [t0001_string]
    mov    ebx, [t0001_strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2double
    add    esp, 8                   ;restore 8 bytes
    fst    qword [t0001_double]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0002
;       Given,
;           t0002_string = "-1234.00567", after conversion
;           the t0002_double should be -1234.00567
;
;   t0002_double = cvt_string2double ( @t0002_string, t0002_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [t0002_string]
    mov    ebx, [t0002_strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2double
    add    esp, 8                   ;restore 8 bytes
    fst    qword [t0002_double]


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
