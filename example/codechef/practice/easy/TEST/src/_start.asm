;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;               Life, the Universe, and Everything
;                             TEST
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 21-JAN-2015
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: read4096b_stdin.asm,
;                   string_append.asm
;
;=====================================================================

%include \
    "../../../../../src/io/read4096b_stdin/src/read4096b_stdin.asm"
%include \
    "../../../../../src/string/string_append/src/string_append.asm"

global _start

section .bss

    rb:              resd 1025
    rb_ptr:          resd 1
    rb_byte_pos:     resd 1

    input_string:    resd 1
    input_strlen:    resd 1

section .data

    newline:    dd 0x0000000a

section .text

_start:


.loop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   input_string = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [input_string], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @input_string,
;                           @input_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 24
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [input_string]
    lea    esi, [input_strlen]
    xor    edi, edi
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    mov    [esp + 16], esi
    mov    [esp + 20], edi
    call   read4096b_stdin
    add    esp, 24


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   if input_string == 0x3234, goto .endloop;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [input_string]
    cmp    eax, 0x3234
    je     .endloop


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   string_append( @input_string,
;                         @input_strlen,
;                         @newline,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16
    lea    eax, [input_string]
    lea    ebx, [input_strlen]
    lea    ecx, [newline]
    mov    edx, 1
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   string_append
    add    esp, 16


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   write( stdout, @input_string, input_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;fd = stdout
    lea    ecx, [input_string]      ;src string
    mov    edx, [input_strlen]      ;src strlen
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   goto .loop;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop


.endloop:


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
