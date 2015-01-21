;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;       EXAMPLE 001: Getting Started
;   EXAMPLE PURPOSE: Demonstrates how to use the function
;                    string_append.
;
;            AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;      DATE CREATED: 22-DEC-2014
;
;          LANGUAGE: x86 Assembly Language
;            SYNTAX: Intel
;         ASSEMBLER: NASM
;      ARCHITECTURE: i386
;            KERNEL: Linux 32-bit
;            FORMAT: elf32
;
;    EXTERNAL FILES: string_append.asm
;
;=====================================================================

extern string_append
global _start

section .data

    string1: db "Hello World",\
                "           " ;blank spaces. Reserved for string2.
    strlen1: dd 11

    string2: db "! I am good"
    strlen2: dd 11

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append string2 to string1 and print string1 to stdout
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   append string2 to string1
;
;   string_append( @string1, @strlen1, @string2, strlen2 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, string1             ;get @string1
    mov    ebx, strlen1             ;get @strlen1
    mov    ecx, string2             ;get @string2
    mov    edx, [strlen2]           ;get strlen2
    mov    [esp     ], eax          ;arg1: @string1
    mov    [esp +  4], ebx          ;arg2: @strlen1
    mov    [esp +  8], ecx          ;arg3: @string2
    mov    [esp + 12], edx          ;arg4: strlen2
    call   string_append
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   systemcall write string1 to stdout
;
;   write( stdout, @string1, strlen1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;write to stdout
    mov    ecx, string1             ;src = @string1
    mov    edx, [strlen1]           ;strlen = strlen1
    int    0x80


.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
