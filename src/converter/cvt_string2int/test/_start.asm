;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 20-JAN-2015
;
;     TEST PURPOSE: Make sure the cvt_string2int have no errors.
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
;                   pow_int.asm        (required by cvt_string2int)
;
;=====================================================================

extern cvt_string2int
global _start

section .bss

    t0001_integer: resd 1
    t0002_integer: resd 1
    t0003_integer: resd 1

section .rodata

    t0001_string: db "1234"
    t0001_strlen: dd 4

    t0002_string: db "4294967295"
    t0002_strlen: dd 10

    t0003_string: db "2314125"
    t0003_strlen: dd 7

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given,
;           t0001_string = "1234", after conversion
;           the t0001_integer should be 0x000004d2
;
;   cvt_string2int( @t0001_string, t0001_strlen, @t0001_integer );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 12                  ;reserve 12 bytes
    lea    eax, [t0001_string]
    mov    ebx, [t0001_strlen]
    lea    ecx, [t0001_integer]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   cvt_string2int
    add    esp, 12                  ;restore 12 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0002
;       Given,
;           t0002_string = "4294967295", after conversion
;           the t0002_integer should be 0xffffffff
;
;   cvt_string2int( @t0002_string, t0002_strlen, @t0002_integer );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 12                  ;reserve 12 bytes
    lea    eax, [t0002_string]
    mov    ebx, [t0002_strlen]
    lea    ecx, [t0002_integer]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   cvt_string2int
    add    esp, 12                  ;restore 12 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0003
;       Given,
;           t0003_string = "2314125", after conversion
;           the t0003_integer should be 0x00234f8d
;
;   cvt_string2int( @t0003_string, t0003_strlen, @t0003_integer );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 12                  ;reserve 12 bytes
    lea    eax, [t0003_string]
    mov    ebx, [t0003_strlen]
    lea    ecx, [t0003_integer]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   cvt_string2int
    add    esp, 12                  ;restore 12 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
