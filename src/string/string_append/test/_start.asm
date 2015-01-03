;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                           *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 26-DEC-2014
;
;     TEST PURPOSE: Make sure the string_append have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;   EXTERNAL FILES: string_append.asm
;
;---------------------------------------------------------------------
;
;   TERM ABBREVIATIONS USED IN THIS SOURCE CODE:
;
;       ====================================================
;             Term       |          Abbreviation
;       ----------------------------------------------------
;         src            |  source.
;         dst            |  destination.
;         strlen         |  string length.
;         t0001          |  test 0001.
;         s01            |  string 01.
;         beg            |  begin.
;         outstr         |  output string.
;         t0001_s04_beg  |  begin of test 0001 string 04.
;       ====================================================
;
;=====================================================================

extern string_append
global _start

section .bss

    t0001_outstr: resd 192
    t0001_outlen: resd 1

section .data

    t0001_s01_beg: db \
        "For humans, written communication is crucial.",\
        0x0a,\
        "Unfortunately, computers were not specifically",\
        0x0a,\
        "designed for ease of communication with",\
        0x0a,\
        "humans. Most high-level languages provide",\
        0x0a,\
        "specific functions for helping programmers",\
        0x0a,\
        "write programs to interact with humans.",\
        0x0a, 0x0a
    t0001_s01_end:

    t0001_s02_beg: db \
        "As an assembly language programmer, you do not",\
        0x0a,\
        "have the luxury of these functions. It is up",\
        0x0a,\
        "to you to code your programs to interact with",\
        0x0a,\
        "humans in their own language.",\
        0x0a, 0x0a
    t0001_s02_end:

    t0001_s03_beg: db \
        "The use of strings helps programs communicate",\
        0x0a,\
        "with humans in their own language. While using",\
        0x0a,\
        "strings is not a simple matter in assembly",\
        0x0a,\
        "language programming, it is not impossible.",\
        0x0a, 0x0a
    t0001_s03_end:

    t0001_s04_beg: db \
        "~Professional Assembly Language,",\
        0x0a,\
        " by Richard Blum. Page 273",\
        0x0a, 0x0a
    t0001_s04_end:

section .text

_start:


;
;
;   *** TEST 0001 begin ***
;
;


;
;
;   append t0001_s01_beg to t0001_outstr.
;
;       string_append( @t0001_outstr,
;                      @t0001_outlen,
;                      @t0001_s01_beg,
;                      @t0001_s01_end - @t0001_s01_beg );
;
;
    sub    esp, 16                              ;reserve 16 bytes
    mov    eax, t0001_outstr                    ;get addr dst string
    mov    ebx, t0001_outlen                    ;get addr dst strlen
    mov    ecx, t0001_s01_beg                   ;get addr src string
    mov    edx, (t0001_s01_end - t0001_s01_beg) ;get src strlen
    mov    [esp     ], eax                      ;arg1: addr dst string
    mov    [esp +  4], ebx                      ;arg2: addr dst strlen
    mov    [esp +  8], ecx                      ;arg3: addr src string
    mov    [esp + 12], edx                      ;arg4: src strlen
    call   string_append
    add    esp, 16                              ;restore 16 bytes


;
;
;   append t0001_s02_beg to t0001_outstr.
;
;       string_append( @t0001_outstr,
;                      @t0001_outlen,
;                      @t0001_s02_beg,
;                      @t0001_s02_end - @t0001_s02_beg );
;
;
    sub    esp, 16                              ;reserve 16 bytes
    mov    eax, t0001_outstr                    ;get addr dst string
    mov    ebx, t0001_outlen                    ;get addr dst strlen
    mov    ecx, t0001_s02_beg                   ;get addr src string
    mov    edx, (t0001_s02_end - t0001_s02_beg) ;get src strlen
    mov    [esp     ], eax                      ;arg1: addr dst string
    mov    [esp +  4], ebx                      ;arg2: addr dst strlen
    mov    [esp +  8], ecx                      ;arg3: addr src string
    mov    [esp + 12], edx                      ;arg4: src strlen
    call   string_append
    add    esp, 16                              ;restore 16 bytes


;
;
;   append t0001_s03_beg to t0001_outstr.
;
;       string_append( @t0001_outstr,
;                      @t0001_outlen,
;                      @t0001_s03_beg,
;                      @t0001_s03_end - @t0001_s03_beg );
;
;
    sub    esp, 16                              ;reserve 16 bytes
    mov    eax, t0001_outstr                    ;get addr dst string
    mov    ebx, t0001_outlen                    ;get addr dst strlen
    mov    ecx, t0001_s03_beg                   ;get addr src string
    mov    edx, (t0001_s03_end - t0001_s03_beg) ;get src strlen
    mov    [esp     ], eax                      ;arg1: addr dst string
    mov    [esp +  4], ebx                      ;arg2: addr dst strlen
    mov    [esp +  8], ecx                      ;arg3: addr src string
    mov    [esp + 12], edx                      ;arg4: src strlen
    call   string_append
    add    esp, 16                              ;restore 16 bytes


;
;
;   append t0001_s04_beg to t0001_outstr.
;
;       string_append( @t0001_outstr,
;                      @t0001_outlen,
;                      @t0001_s04_beg,
;                      @t0001_s04_end - @t0001_s04_beg );
;
;
    sub    esp, 16                              ;reserve 16 bytes
    mov    eax, t0001_outstr                    ;get addr dst string
    mov    ebx, t0001_outlen                    ;get addr dst strlen
    mov    ecx, t0001_s04_beg                   ;get addr src string
    mov    edx, (t0001_s04_end - t0001_s04_beg) ;get src strlen
    mov    [esp     ], eax                      ;arg1: addr dst string
    mov    [esp +  4], ebx                      ;arg2: addr dst strlen
    mov    [esp +  8], ecx                      ;arg3: addr src string
    mov    [esp + 12], edx                      ;arg4: src strlen
    call   string_append
    add    esp, 16                              ;restore 16 bytes


;
;
;   systemcall write t0001_outstr to stdout.
;
;       write( stdout, @t0001_outstr, t0001_outlen );
;
;
    mov    eax, 0x04                            ;systemcall write
    mov    ebx, 0x01                            ;to stdout
    mov    ecx, t0001_outstr                    ;source string
    mov    edx, [t0001_outlen]                  ;strlen
    int    0x80


;
;
;   *** TEST 0001 end ***
;
;


.exit:
    mov    eax, 0x01                            ;systemcall exit
    xor    ebx, ebx                             ;return 0
    int    0x80
