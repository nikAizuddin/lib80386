;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 12-JAN-2015
;
;     TEST PURPOSE: Make sure the cvt_string2dec have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: cvt_string2dec.asm
;
;=====================================================================

extern cvt_string2dec
global _start

section .bss

    t0001_decimal: resd 2
    t0001_digits:  resd 1

    t0002_decimal: resd 2
    t0002_digits:  resd 1

    t0003_decimal: resd 2
    t0003_digits:  resd 1

    t0004_decimal: resd 2
    t0004_digits:  resd 1

section .data

    t0001_string: dd "23"
    t0001_strlen: dd 2

    t0002_string: dd "12345678"
    t0002_strlen: dd 8

    t0003_string: dd "4294", "9672", "95"
    t0003_strlen: dd 10

    t0004_string: dd 0
    t0004_strlen: dd 0

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given,
;           t0001_string = "23", after conversion
;           the t0001_decimal should be 0x00000023,
;           and the t0001_digits should be 2
;
;   cvt_string2dec( @t0001_string,
;                   t0001_strlen,
;                   @t0001_decimal,
;                   @t0001_digits )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [t0001_string]
    mov    ebx, [t0001_strlen]
    lea    ecx, [t0001_decimal]
    lea    edx, [t0001_digits]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0002
;       Given,
;           t0002_string = "12345678", after conversion
;           the t0002_decimal should be 0x12345678,
;           and the t0002_digits should be 8
;
;   cvt_string2dec( @t0002_string,
;                   t0002_strlen,
;                   @t0002_decimal,
;                   @t0002_digits )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [t0002_string]
    mov    ebx, [t0002_strlen]
    lea    ecx, [t0002_decimal]
    lea    edx, [t0002_digits]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0003
;       Given,
;           t0003_string = "4294967295", after conversion
;           the t0003_decimal[0] should be 0x94967295,
;           the t0003_decimal[1] should be 0x00000042,
;           and the t0003_digits should be 10
;
;   cvt_string2dec( @t0003_string,
;                   t0003_strlen,
;                   @t0003_decimal,
;                   @t0003_digits )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [t0003_string]
    mov    ebx, [t0003_strlen]
    lea    ecx, [t0003_decimal]
    lea    edx, [t0003_digits]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0004
;       Given,
;           t0004_string = 0x00000000, after conversion
;           the t0004_decimal[0] should be 0x00000000,
;           the t0004_decimal[1] should be 0x00000000,
;           and the t0004_digits should be 0
;
;   cvt_string2dec( @t0004_string,
;                   t0004_strlen,
;                   @t0004_decimal,
;                   @t0004_digits )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [t0004_string]
    mov    ebx, [t0004_strlen]
    lea    ecx, [t0004_decimal]
    lea    edx, [t0004_digits]
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
