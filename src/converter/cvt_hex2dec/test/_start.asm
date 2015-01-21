;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 04-JAN-2015
;
;     TEST PURPOSE: Make sure the cvt_hex2dec have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: cvt_hex2dec.asm
;
;=====================================================================

extern cvt_hex2dec
global _start

section .bss

    t0001_dec: resd 1
    t0002_dec: resd 1
    t0003_dec: resd 1

section .data

    t0001_hex: dd 0x0000000a
    t0002_hex: dd 0x00000003
    t0003_hex: dd 0x05f5e0ff

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given t0001_hex = 0x0000000a,
;       the t0001_dec should be 0x00000010
;
;   Convert t0001_hex to decimal number.
;
;   t0001_dec = cvt_hex2dec( t0001_hex );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [t0001_hex]         ;get t0001_hex
    mov    [esp], eax               ;arg1: t0001_hex
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [t0001_dec], eax         ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0002
;       Given t0002_hex = 0x00000003,
;       the t0002_dec should be 0x00000003
;
;   Convert t0002_hex to decimal number.
;
;   t0002_dec = cvt_hex2dec( t0002_hex );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [t0002_hex]         ;get t0002_hex
    mov    [esp], eax               ;arg1: t0002_hex
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [t0002_dec], eax         ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0003
;       Given t0003_hex = 0x05f5e0ff,
;       the t0003_dec should be 0x99999999
;
;   Convert t0003_hex to decimal number.
;
;   t0003_dec = cvt_hex2dec( t0003_hex );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [t0003_hex]         ;get t0003_hex
    mov    [esp], eax               ;arg1: t0003_hex
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [t0003_dec], eax         ;save return value


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int  0x80

