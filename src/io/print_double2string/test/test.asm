;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                          *** TEST ***                               |
;+---------------------------------------------------------------------+
;|          AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                  |
;|    DATE CREATED: 22-DEC-2014                                        |
;|    TEST PURPOSE: Make sure the print_double2string have no errors.  |
;+---------------------------------------------------------------------+
;|        LANGUAGE: x86 Assembly Language                              |
;|          SYNTAX: Intel                                              |
;|       ASSEMBLER: NASM                                               |
;|    ARCHITECTURE: i386                                               |
;|          KERNEL: Linux 32-bit                                       |
;|          FORMAT: elf32                                              |
;|  EXTERNAL FILES: print_double2string.asm                            |
;|                  print_int2string.asm                               |
;|                  append_string.asm                                  |
;|                  pow_int.asm                                        |
;+---------------------------------------------------------------------+
;=======================================================================

extern print_double2string
extern append_string
global _start

section .data

section .text

_start:

.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
