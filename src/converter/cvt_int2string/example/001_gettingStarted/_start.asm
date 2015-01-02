;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|     EXAMPLE 001: Getting Started                                    |
;+---------------------------------------------------------------------+
;|          AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                  |
;|    DATE CREATED: 27-DEC-2014                                        |
;| EXAMPLE PURPOSE: Demonstrates how to use the function               |
;|                  print_int2string.                                  |
;+---------------------------------------------------------------------+
;|        LANGUAGE: x86 Assembly Language                              |
;|          SYNTAX: Intel                                              |
;|       ASSEMBLER: NASM                                               |
;|    ARCHITECTURE: i386                                               |
;|          KERNEL: Linux 32-bit                                       |
;|          FORMAT: elf32                                              |
;|  EXTERNAL FILES: print_int2string.asm                               |
;+---------------------------------------------------------------------+
;=======================================================================

extern print_int2string
global _start

section .bss

    out_string: resd 4
    out_strlen: resd 1

section .rdata

    integer_value: dd 2147483646

section .text

_start:


;///////////////////////////////////////////////////////////////////////
;//                          EXAMPLE END                              //
;///////////////////////////////////////////////////////////////////////


;+-------------------------------------------------------+
;| Convert integer value to ascii and print it to stdout |==============
;+-------------------------------------------------------+
;=======================================================================

    ;    +--------------------------+
    ;----| convert integer to ascii |-----------------------------------
    ;    +--------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [integer_value]     ;get integer_value
    mov    ebx, out_string          ;get @out_string
    mov    ecx, out_strlen          ;get @out_strlen
    mov    edx, 1                   ;get flag
    mov    [esp     ], eax          ;arg1: integer_value
    mov    [esp +  4], ebx          ;arg2: @out_string
    mov    [esp +  8], ecx          ;arg3: @out_strlen
    mov    [esp + 12], edx          ;arg4: flag
    call   print_int2string
    add    esp, 16                  ;restore 16 bytes

    ;    +---------------------------------------+
    ;----| systemcall write out_string to stdout |----------------------
    ;    +---------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                ;system call write
    mov    ebx, 0x01                ;write to stdout
    mov    ecx, out_string          ;src string
    mov    edx, [out_strlen]        ;strlen
    int    0x80


;///////////////////////////////////////////////////////////////////////
;//                          EXAMPLE END                              //
;///////////////////////////////////////////////////////////////////////


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

