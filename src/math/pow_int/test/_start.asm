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
;     TEST PURPOSE: Make sure pow_int have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: pow_int.asm
;
;=====================================================================

extern pow_int
global _start

section .bss

    t0001_result: resd 1

section .data

    t0001_base:  dd 0x00000009
    t0001_power: dd 0x00000005

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Given,
;           t0001_base = 0x00000009,
;           t0001_power = 0x00000005, after calculations
;           the t0001_result should be 0x0000e6a9
;
;   t0001_result = pow_int( t0001_base, t0001_power );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [t0001_base]
    mov    ebx, [t0001_power]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [t0001_result], eax      ;save return value


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
