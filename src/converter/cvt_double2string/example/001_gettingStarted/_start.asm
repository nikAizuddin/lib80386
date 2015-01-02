;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|     EXAMPLE 001: Getting Started                                    |
;+---------------------------------------------------------------------+
;|          AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                  |
;|    DATE CREATED: 26-DEC-2014                                        |
;| EXAMPLE PURPOSE: Demonstrates how to use the function               |
;|                  cvt_double2string.                                 |
;+---------------------------------------------------------------------+
;|        LANGUAGE: x86 Assembly Language                              |
;|          SYNTAX: Intel                                              |
;|       ASSEMBLER: NASM                                               |
;|    ARCHITECTURE: i386                                               |
;|          KERNEL: Linux 32-bit                                       |
;|          FORMAT: elf32                                              |
;|  EXTERNAL FILES: cvt_double2string.asm                              |
;+---------------------------------------------------------------------+
;=======================================================================

extern cvt_double2string
global _start

section .bss

    out_string: resd 6
    out_strlen: resd 1

section .rdata

    double_value:   dq -2147483647.1234567
    decimal_places: dd 10000000

section .text

_start:


;///////////////////////////////////////////////////////////////////////
;//                          EXAMPLE BEGIN                            //
;///////////////////////////////////////////////////////////////////////


;+---------------------------------------------------------+
;| Convert double_value to ASCII value and print to stdout |============
;+---------------------------------------------------------+
;=======================================================================

    ;    +-------------------------------+
    ;----| convert double_value to ASCII |------------------------------
    ;    +-------------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 20                  ;reserve 20 bytes
    mov    eax, [double_value]      ;get double_value[0]
    mov    ebx, [double_value + 4]  ;get double_value[1]
    mov    ecx, [decimal_places]    ;get decimal_places
    mov    edx, out_string          ;get @out_string     
    mov    [esp     ], eax          ;arg1: double_value[0]
    mov    [esp +  4], ebx          ;arg1: double_value[1]
    mov    [esp +  8], ecx          ;arg2: decimal_places
    mov    [esp + 12], edx          ;arg3: @out_string
    mov    eax, out_strlen          ;get @out_strlen
    mov    [esp + 16], eax          ;arg4: @out_strlen
    call   cvt_double2string
    add    esp, 20                  ;restore 20 bytes

    ;    +---------------------------------------+
    ;----| systemcall write out_string to stdout |----------------------
    ;    +---------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;to stdout
    mov    ecx, out_string          ;src string
    mov    edx, [out_strlen]        ;strlen
    int    0x80


;///////////////////////////////////////////////////////////////////////
;//                           EXAMPLE END                             //
;///////////////////////////////////////////////////////////////////////


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

