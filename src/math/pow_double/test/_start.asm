;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 10-JAN-2015
;
;     TEST PURPOSE: Make sure pow_double have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: pow_double.asm
;
;=====================================================================

extern pow_double
global _start

section .bss

    t0001_result: resq 1

section .data

    t0001_base:  dq 9.12
    t0001_power: dq 6.73

section .text

_start:


;
;
;   TEST 0001
;       Given,
;           t0001_base = 9.12,
;           t0001_power = 6.73, after calculations
;           the t0001_result should be 2889117.879533143
;
;   t0001_result = pow_double( t0001_base, t0001_power );
;
;
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [t0001_base     ]
    mov    ebx, [t0001_base  + 4]
    mov    ecx, [t0001_power    ]
    mov    edx, [t0001_power + 4]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   pow_double
    add    esp, 16                  ;restore 16 bytes
    fst    qword [t0001_result]     ;save return value


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
