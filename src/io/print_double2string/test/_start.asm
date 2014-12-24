;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                          *** TEST ***                               |
;+---------------------------------------------------------------------+
;|          AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                  |
;|    DATE CREATED: 25-DEC-2014                                        |
;|    TEST PURPOSE: Make sure the print_double2string have no errors.  |
;+---------------------------------------------------------------------+
;|        LANGUAGE: x86 Assembly Language                              |
;|          SYNTAX: Intel                                              |
;|       ASSEMBLER: NASM                                               |
;|    ARCHITECTURE: i386                                               |
;|          KERNEL: Linux 32-bit                                       |
;|          FORMAT: elf32                                              |
;|  EXTERNAL FILES: print_double2string.asm                            |
;|                  append_string.asm                                  |
;+---------------------------------------------------------------------+
;=======================================================================

extern print_double2string
extern append_string
global _start

section .bss

    t0001_str: resd 8
    t0001_len: resd 1

    t0002_str: resd 8
    t0002_len: resd 1

section .data

    newline: db 0x0a

    t0001_doux: dq 12.092
    t0001_decp: dd 10
    t0001_ibeg: db "TEST 0001: ", 0x0a,\
                   "    double_x = 12.092", 0x0a,\
                   "    decimal_places = 10", 0x0a,\
                   "    the output should be 12.1", 0x0a,\
                   "    output = "
    t0001_iend:

    t0002_doux: dq -12302.0003200
    t0002_decp: dd 10000000
    t0002_ibeg: db "TEST 0002: ", 0x0a,\
                   "    double_x = -12302.0003200", 0x0a,\
                   "    decimal_places = 10000000", 0x0a,\
                   "    the output should be -12302.0003200", 0x0a,\
                   "    output = "
    t0002_iend:

section .text

_start:


;///////////////////////////////////////////////////////////////////////
;//                           TEST BEGIN                              //
;///////////////////////////////////////////////////////////////////////


;+-----------+
;| TEST 0001 |==========================================================
;+-----------+
;=======================================================================

    ;    +--------------+
    ;----| display info |-----------------------------------------------
    ;    +--------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                      ;systemcall write
    mov    ebx, 0x01                      ;to stdout
    mov    ecx, t0001_ibeg                ;src = t0001_ibeg
    mov    edx, (t0001_iend - t0001_ibeg) ;strlen
    int    0x80

    ;    +---------------------+
    ;----| print_double2string |----------------------------------------
    ;    +---------------------+
    ;-------------------------------------------------------------------
    sub    esp, 20                        ;reserve 20 bytes
    mov    eax, [t0001_doux    ]          ;get t0001_doux[0]
    mov    ebx, [t0001_doux + 4]          ;get t0001_doux[1]
    mov    [esp     ], eax                ;arg1: t0001_doux[0]
    mov    [esp +  4], ebx                ;arg1: t0001_doux[1]
    mov    eax, [t0001_decp]              ;get t0001_decp
    mov    ebx, t0001_str                 ;get @t0001_str
    mov    ecx, t0001_len                 ;get @t0001_len
    mov    [esp +  8], eax                ;arg2: t0001_decp
    mov    [esp + 12], ebx                ;arg3: @t001_str
    mov    [esp + 16], ecx                ;arg4: @t001_len
    call   print_double2string
    add    esp, 20                        ;restore 20 bytes

    ;    +-----------------------------+
    ;----| append newline to t0001_str |--------------------------------
    ;    +-----------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 16                        ;reserve 16 bytes
    mov    eax, t0001_str                 ;get @t0001_str
    mov    ebx, t0001_len                 ;get @t0001_len
    mov    ecx, newline                   ;get @newline
    mov    edx, 1                         ;append 1 char only
    mov    [esp     ], eax                ;arg1: @t0001_str
    mov    [esp +  4], ebx                ;arg2: @t0001_len
    mov    [esp +  8], ecx                ;arg3: @newline
    mov    [esp + 12], edx                ;arg4: append 1 char only
    call   append_string
    add    esp, 16                        ;restore 16 bytes

    ;    +--------------------------------------+
    ;----| systemcall write t0001_str to stdout |-----------------------
    ;    +--------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                      ;systemcall write
    mov    ebx, 0x01                      ;to stdout
    mov    ecx, t0001_str                 ;src = t0001_ibeg
    mov    edx, [t0001_len]               ;strlen
    int    0x80


;+-----------+
;| TEST 0002 |==========================================================
;+-----------+
;=======================================================================

    ;    +--------------+
    ;----| display info |-----------------------------------------------
    ;    +--------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                      ;systemcall write
    mov    ebx, 0x01                      ;to stdout
    mov    ecx, t0002_ibeg                ;src
    mov    edx, (t0002_iend - t0002_ibeg) ;strlen
    int    0x80

    ;    +---------------------+
    ;----| print_double2string |----------------------------------------
    ;    +---------------------+
    ;-------------------------------------------------------------------
    sub    esp, 20                        ;reserve 20 bytes
    mov    eax, [t0002_doux    ]          ;get t0002_doux[0]
    mov    ebx, [t0002_doux + 4]          ;get t0002_doux[1]
    mov    [esp     ], eax                ;arg1: t0002_doux[0]
    mov    [esp +  4], ebx                ;arg1: t0002_doux[1]
    mov    eax, [t0002_decp]              ;get t0002_decp
    mov    ebx, t0002_str                 ;get @t0002_str
    mov    ecx, t0002_len                 ;get @t0002_len
    mov    [esp +  8], eax                ;arg2: t0002_decp
    mov    [esp + 12], ebx                ;arg3: t0002_str
    mov    [esp + 16], ecx                ;arg4: t0002_len
    call   print_double2string
    add    esp, 20                        ;restore 20 bytes

    ;    +-----------------------------+
    ;----| append newline to t0002_str |--------------------------------
    ;    +-----------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 16                        ;reserve 16 bytes
    mov    eax, t0002_str                 ;get @t0002_str
    mov    ebx, t0002_len                 ;get @t0002_len
    mov    ecx, newline                   ;get @newline
    mov    edx, 1                         ;append 1 char only
    mov    [esp     ], eax                ;arg1: @t0002_str
    mov    [esp +  4], ebx                ;arg2: @t0002_len
    mov    [esp +  8], ecx                ;arg3: @newline
    mov    [esp + 12], edx                ;arg4: append 1 char only
    call   append_string
    add    esp, 16                        ;restore 16 bytes

    ;    +--------------------------------------+
    ;----| systemcall write t0002_str to stdout |-----------------------
    ;    +--------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, 0x04                      ;systemcall write
    mov    ebx, 0x01                      ;to stdout
    mov    ecx, t0002_str                 ;src
    mov    edx, [t0002_len]               ;strlen
    int    0x80


;///////////////////////////////////////////////////////////////////////
;//                           TEST END                                //
;///////////////////////////////////////////////////////////////////////


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
