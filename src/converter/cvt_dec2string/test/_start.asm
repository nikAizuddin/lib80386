;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 05-JAN-2015
;
;     TEST PURPOSE: Make sure the cvt_dec2string have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: cvt_dec2string.asm
;
;=====================================================================

extern cvt_dec2string
global _start

section .bss

    t0001_string: resd 2
    t0001_strlen: resd 1

section .data

    t0001_dec: dd 0x00000123

section .text

_start:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given,
;           t0001_dec = 0x00000123, after conversion
;           the t0001_string should be 0x00333231
;
;   cvt_dec2string( @t0001_dec,
;                   1,
;                   @t0001_string,
;                   @t0001_strlen )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, t0001_dec
    mov    ebx, 1
    mov    ecx, t0001_string
    mov    edx, t0001_strlen
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
