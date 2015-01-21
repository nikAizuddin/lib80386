;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    pow_double.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 10-JAN-2015
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;    EXTERNAL FILES: pow_double.asm
;
;=====================================================================

extern pow_double
global _start

section .bss

    result: resq 1

section .data

    base:  dq 9.12
    power: dq 6.73

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   result = pow_double( base, power );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [base     ]
    mov    ebx, [base  + 4]
    mov    ecx, [power    ]
    mov    edx, [power + 4]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   pow_double
    add    esp, 16                  ;restore 16 bytes
    fst    qword [result]           ;save return value


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
