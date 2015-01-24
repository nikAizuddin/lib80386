;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                              ATM
;                            HS08TEST
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 23-JAN-2015
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
;                   cvt_string2double.asm,
;                   cvt_string2int.asm,
;                   cvt_string2dec.asm,
;                   cvt_dec2hex.asm,
;                   cvt_hex2dec.asm,
;                   cvt_dec2string.asm,
;                   cvt_int2string.asm,
;                   cvt_double2string.asm,
;                   find_int_digits.asm,
;                   pow_int.asm
;
;=====================================================================

extern read4096b_stdin
extern string_append
extern cvt_string2double
extern cvt_string2int
extern cvt_string2dec
extern cvt_dec2hex
extern cvt_hex2dec
extern cvt_dec2string
extern cvt_int2string
extern cvt_double2string
extern find_int_digits
extern pow_int
global _start

section .bss

    rb:                 resd 1025
    rb_ptr:             resd 1
    rb_byte_pos:        resd 1

    withdraw_str:       resd 2
    withdraw_strlen:    resd 1
    withdraw_int:       resd 1

    balance_str:        resd 2
    balance_strlen:     resd 1
    balance_double:     resq 1

section .data

    newline:    dd 0x0000000a
    charge:     dq 0.50

section .text

_start:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get withdraw value
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   withdraw_str = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [withdraw_str], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @withdraw_str,
;                           @withdraw_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 24                  ;reserve 24 bytes
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [withdraw_str]
    lea    esi, [withdraw_strlen]
    xor    edi, edi
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    mov    [esp + 16], esi          ;parameter 5
    mov    [esp + 20], edi          ;parameter 6
    call   read4096b_stdin
    add    esp, 24                  ;restore 24 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   withdraw_int = cvt_string2int( @withdraw_str,
;                                         withdraw_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [withdraw_str]
    mov    ebx, [withdraw_strlen]
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2int
    add    esp, 8                   ;restore 8 bytes
    mov    [withdraw_int], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get balance value
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   balance_str = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [balance_str], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   read4096b_stdin( @rb,
;                           @rb_ptr,
;                           @rb_byte_pos,
;                           @balance_str,
;                           @balance_strlen,
;                           0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 24                  ;reserve 24 bytes
    lea    eax, [rb]
    lea    ebx, [rb_ptr]
    lea    ecx, [rb_byte_pos]
    lea    edx, [balance_str]
    lea    esi, [balance_strlen]
    xor    edi, edi
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    mov    [esp + 16], esi          ;parameter 5
    mov    [esp + 20], edi          ;parameter 6
    call   read4096b_stdin
    add    esp, 24                  ;restore 24 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   balance_double = cvt_string2double( @balance_str,
;                                              balance_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [balance_str]
    mov    ebx, [balance_strlen]
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2double
    add    esp, 8                   ;restore 8 bytes
    fst    qword [balance_double]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Is withdraw_int a multiple of 5 ?
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   withdraw_int / 5;
;   008:   if EDX == 0, goto .withdraw_is_mult_5;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [withdraw_int]
    mov    ebx, 5
    xor    edx, edx
    div    ebx
    cmp    edx, 0
    je     .withdraw_is_mult_5


.withdraw_is_not_mult_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   goto .exit;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .exit


.withdraw_is_mult_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Is balance_double sufficient ?
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   FINIT;
;   011:   FLD balance_double;
;   012:   FSUB charge;
;   013:   FILD withdraw_int;
;   014:   FCOMI ST0, ST1;
;   015:   if withdraw_int <= balance_double, goto .bal_sufficient;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit
    fld    qword [balance_double]
    fsub   qword [charge]
    fild   dword [withdraw_int]
    fcomi  st0, st1
    jbe    .bal_sufficient


.bal_not_sufficient:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   goto .exit;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .exit


.bal_sufficient:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Perform withdraw transaction
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   FXCH ST0, ST1;
;   018:   FSUB ST1;
;   019:   FST balance_double;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fxch   st0, st1
    fsub   st1
    fst    qword [balance_double]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert balance_double to balance_str
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   balance_str = 0;
;   021:   balance_strlen = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [balance_str  ], eax
    mov    [balance_str+4], eax
    mov    [balance_strlen], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:   cvt_double2string( balance_double,
;                             100,
;                             @balance_str,
;                             @balance_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 20                  ;reserve 20 bytes
    mov    eax, [balance_double  ]
    mov    ebx, [balance_double+4]
    mov    ecx, 100
    lea    edx, [balance_str]
    lea    esi, [balance_strlen]
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 1
    mov    [esp +  8], ecx          ;parameter 2
    mov    [esp + 12], edx          ;parameter 3
    mov    [esp + 16], esi          ;parameter 4
    call   cvt_double2string
    add    esp, 20                  ;restore 20 bytes


.exit:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append newline character to balance_str,
;   and print the balance_str to stdout.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   string_append( @balance_str,
;                         @balance_strlen,
;                         @newline,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    lea    eax, [balance_str]
    lea    ebx, [balance_strlen]
    lea    ecx, [newline]
    mov    edx, 1
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    call   string_append
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   write( stdout, @balance_str, balance_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;fd = stdout
    lea    ecx, [balance_str]       ;src = balance_str
    mov    edx, [balance_strlen]    ;strlen = balance_strlen
    int    0x80

    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int   0x80
