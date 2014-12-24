;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: pow_double                                        |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 13/DEC/2014                                       |
;|  PROGRAM PURPOSE: <See README file>                                 |
;+---------------------------------------------------------------------+
;|         LANGUAGE: x86 Assembly Language                             |
;|           SYNTAX: Intel                                             |
;|        ASSEMBLER: NASM                                              |
;|     ARCHITECTURE: i386, i586, i686, x86_64                          |
;|           KERNEL: Linux 32-bit                                      |
;|           FORMAT: elf32                                             |
;|    INCLUDE FILES: None                                              |
;+---------------------------------------------------------------------+
;|          VERSION: 0.1.0                                             |
;|           STATUS: Alpha                                             |
;+---------------------------------------------------------------------+
;| REVISION HISTORY:                                                   |
;|                                                                     |
;|     Rev #  |    Date     | Description                              |
;|   ---------+-------------+---------------------------------------   |
;|     0.1.0  | 13/DEC/2014 | First release.                           |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

section .data
    temp dq 1.0

section .text
global pow_double
pow_double:

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes
    mov    [esp], ebp ;store ebp to stack
    mov    ebp, esp   ;store current stack pointer to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get x the base value (part 1/2)
    mov    ebx, [ebp +  4]          ;get x the base value (part 2/2)
    mov    ecx, [ebp +  8]          ;get y the power value (part 1/2)
    mov    edx, [ebp + 12]          ;get y the power value (part 2/2)

.set_local_variables:
    sub    esp, 48                  ;reserve 48 bytes
    mov    [esp     ], eax          ;x (part 1/2)
    mov    [esp +  4], ebx          ;x (part 2/2)
    mov    [esp +  8], ecx          ;y (part 1/2)
    mov    [esp + 12], edx          ;y (part 2/2)
    mov    dword [esp + 16], 0      ;p (part 1/2)
    mov    dword [esp + 20], 0      ;p (part 2/2)
    mov    dword [esp + 24], 0      ;q (part 1/2)
    mov    dword [esp + 28], 0      ;q (part 2/2)
    mov    dword [esp + 32], 0      ;r (part 1/2)
    mov    dword [esp + 36], 0      ;r (part 2/2)
    mov    dword [esp + 40], 0      ;s (part 1/2)
    mov    dword [esp + 44], 0      ;s (part 2/2)

    finit

;///////////////////////////////////////////////////////////////////////
;//                        ALGORITHM BEGIN                            //
;///////////////////////////////////////////////////////////////////////

;+---------------------------------------------------------------------+
;|       p = log2(x) * y;                                              |
;|       q = round p to the nearest;                                   |
;|       r = p - q;                                                    |
;|       s = (2^r) * (2^q);                                            |
;+---------------------------------------------------------------------+
;    +------------------+
;----| p = log2(x) * y; |-----------------------------------------------
;    +------------------+
.b:
    fld    qword [temp]
    fld    qword [esp    ]          ;st(0) := x
    fyl2x                           ;log2( st(0) )
    fld    qword [esp + 8]          ;st(0) := y
    fmul   st0, st1
    fst    st1
;    +-----------------------------+
;----| q = round p to the nearest; |------------------------------------
;    +-----------------------------+
    frndint
;    +------------+
;----| r = p - q; |-----------------------------------------------------
;    +------------+
    fsub    st1, st0
    fxch    st1
;    +-------------------+
;----|s = (2^r) * (2^q); |----------------------------------------------
;    +-------------------+
    f2xm1
    fadd   qword [temp]
    fscale

;///////////////////////////////////////////////////////////////////////
;//                         ALGORITHM END                             //
;///////////////////////////////////////////////////////////////////////

.return:
    ;fld qword [esp + 40] ;return s

.clean_stackframe:
    sub    ebp, 8     ;-8 offset due to arguments
    mov    esp, ebp   ;restore the stack pointer to initial value
    mov    ebp, [esp] ;restore ebp to initial value
    add    esp, 4     ;restore 4 bytes

    ret
