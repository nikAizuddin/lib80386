;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 21-JAN-2015
;
;     TEST PURPOSE: Make sure read4096b_stdin have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: read4096b_stdin.asm
;
;=====================================================================

extern read4096b_stdin
global _start

section .bss

    ;READBUFFER
    rb:             resd 1024
    rb_ptr:         resd 1
    rb_byte_pos:    resd 1

    ;RAW_DATA p
    p:              resd 2
    p_len:          resd 1

    ;RAW_DATA q
    q:              resd 2
    q_len:          resd 1

    ;RAW_DATA r
    r:              resd 2
    r_len:          resd 1

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   TEST 0001
;       Fill p, q, and r with data from stdin.
;
;   read4096b_stdin( @rb,
;                    @rb_ptr,
;                    @rb_byte_pos,
;                    @p,
;                    @p_len,
;                    0 );
;
;   read4096b_stdin( @rb,
;                    @rb_ptr,
;                    @rb_byte_pos,
;                    @q,
;                    @q_len,
;                    0 );
;
;   read4096b_stdin( @rb,
;                    @rb_ptr,
;                    @rb_byte_pos,
;                    @r,
;                    @r_len,
;                    0);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 24                  ;reserve 24 bytes

    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [p]
    lea    esi, [p_len]
    mov    edi, 0
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    mov    [esp + 16], esi          ;parameter 5
    mov    [esp + 20], edi          ;parameter 6
    call   read4096b_stdin

    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [q]
    lea    esi, [q_len]
    mov    edi, 0
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    mov    [esp + 16], esi          ;parameter 5
    mov    [esp + 20], edi          ;parameter 6
    call   read4096b_stdin

    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [r]
    lea    esi, [r_len]
    mov    edi, 0
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    mov    [esp + 16], esi          ;parameter 5
    mov    [esp + 20], edi          ;parameter 6
    call   read4096b_stdin

    add    esp, 24                  ;restore 24 bytes


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
