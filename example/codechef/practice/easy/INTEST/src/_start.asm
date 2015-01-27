;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                       Enormous Input Test
;                             INTEST
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 25-JAN-2015
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: read4096b_stdin.asm,
;                   string_append.asm,
;                   cvt_string2int.asm,
;                   cvt_string2dec.asm,
;                   cvt_dec2hex.asm,
;                   cvt_hex2dec.asm,
;                   cvt_dec2string.asm,
;                   cvt_int2string.asm,
;                   find_int_digits.asm,
;                   pow_int.asm
;
;=====================================================================

extern read4096b_stdin
extern string_append
extern cvt_string2int
extern cvt_string2dec
extern cvt_dec2hex
extern cvt_hex2dec
extern cvt_dec2string
extern cvt_int2string
extern find_int_digits
extern pow_int
global _start

section .bss

    rb:               resd 1025
    rb_ptr:           resd 1
    rb_byte_pos:      resd 1

    n_str:            resd 3
    n_strlen:         resd 1
    n:                resd 1

    k_str:            resd 3
    k_strlen:         resd 1
    k:                resd 1

    t_str:            resd 3
    t_strlen:         resd 1
    t:                resd 1

    i:                resd 1

    result_str:       resd 3
    result_strlen:    resd 1
    result:           resd 1

section .data

    newline:    dd 0x0000000a

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get n
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   n_str = 0;
;   002:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @n_str,
;                           @n_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [n_str  ], eax
    mov    [n_str+4], eax
    mov    [n_str+8], eax

    sub    esp, 24
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [n_str]
    lea    esi, [n_strlen]
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
;   003:   n = cvt_string2int( @n_str, n_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8
    lea    eax, [n_str]
    mov    ebx, [n_strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2int
    add    esp, 8
    mov    [n], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get k
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   k_str = 0;
;   005:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @k_str,
;                           @k_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [k_str  ], eax
    mov    [k_str+4], eax
    mov    [k_str+8], eax

    sub    esp, 24
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [k_str]
    lea    esi, [k_strlen]
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
;   006:   k = cvt_string2int( @k_str, k_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8
    lea    eax, [k_str]
    mov    ebx, [k_strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2int
    add    esp, 8
    mov    [k], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Mainloop begin
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   if n != 0, goto .dont_exit_program;
;          .exit_program:
;   008:       goto .exit;
;          .dont_exit_program:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [n]
    cmp    eax, 0
    jne    .dont_exit_program
.exit_program:
    jmp    .exit
.dont_exit_program:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   i = n;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [n]
    mov    [i], eax


.loop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   t_str = 0;
;   011:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @t_str,
;                           @t_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [t_str  ], eax
    mov    [t_str+4], eax
    mov    [t_str+8], eax

    sub    esp, 24
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [t_str]
    lea    esi, [t_strlen]
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
;   012:   t = cvt_string2int( @t_str, t_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8
    lea    eax, [t_str]
    mov    ebx, [t_strlen]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   cvt_string2int
    add    esp, 8
    mov    [t], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ???:   if k == 0, goto .not_divisible;
;   013:   t / k;
;   014:   if EDX != 0, goto .not_divisible;
;          .divisible:
;   015:       ++ result;
;          .not_divisible:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ecx, [k]
    cmp    ecx, 0
    je     .not_divisible

    mov    eax, [t]
    mov    ebx, [k]
    xor    edx, edx
    div    ebx
    cmp    edx, 0
    jne    .not_divisible
.divisible:
    mov    eax, [result]
    add    eax, 1
    mov    [result], eax
.not_divisible:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   -- i;
;   017:   if i != 0, goto .loop;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [i]
    sub    eax, 1
    mov    [i], eax
    cmp    eax, 0
    jne    .loop


.endloop:


.exit:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   cvt_int2string( result,
;                          @result_str,
;                          @result_strlen,
;                          0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16
    mov    eax, [result]
    lea    ebx, [result_str]
    lea    ecx, [result_strlen]
    xor    edx, edx
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_int2string
    add    esp, 16


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   string_append( @result_str,
;                         @result_strlen,
;                         @newline,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16
    lea    eax, [result_str]
    lea    ebx, [result_strlen]
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
;   020:   write( stdout, @result_str, result_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04
    mov    ebx, 0x01
    lea    ecx, [result_str]
    mov    edx, [result_strlen]
    int    0x80


    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
