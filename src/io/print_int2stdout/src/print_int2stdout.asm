;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: print_int2stdout                                  |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 15/OCT/2014                                       |
;|  PROGRAM PURPOSE: <See README file>                                 |
;+---------------------------------------------------------------------+
;|         LANGUAGE: x86 Assembly Language                             |
;|           SYNTAX: Intel                                             |
;|        ASSEMBLER: NASM                                              |
;|     ARCHITECTURE: i386, i586, i686, x86_64                          |
;|           KERNEL: Linux 32-bit                                      |
;|           FORMAT: elf32                                             |
;|    INCLUDE FILES: calculate_integer_length.asm,                     |
;|                   formula_hex2dec.asm,                              |
;|                   write_dec2string.asm                              |
;+---------------------------------------------------------------------+
;|          VERSION: 0.1.0                                             |
;|           STATUS: Alpha                                             |
;+---------------------------------------------------------------------+
;| REVISION HISTORY:                                                   |
;|                                                                     |
;|     Rev #  |    Date     | Description                              |
;|   ---------+-------------+---------------------------------------   |
;|     0.1.0  | 15/OCT/2014 | First release.                           |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- section instruction codes ---------------------------------------
section .text

extern calculate_integer_length
extern formula_hex2dec
extern write_dec2string

global print_int2stdout
print_int2stdout:

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes
    mov    [esp], ebp ;store ebp to stack
    mov    ebp, esp   ;store stack pointer to ebp

.get_arguments:
    add    ebp, 8         ;+8 offset, to get arguments
    mov    eax, [ebp    ] ;get integer_x
    mov    ebx, [ebp + 4] ;get flag

.set_localvariables:
    sub    esp, 52             ;reserve 52 bytes
    mov    [esp     ], eax     ;integer_x
    mov    [esp +  4], ebx     ;flag
    mov    dword [esp +  8], 0 ;integer_x_len
    mov    dword [esp + 12], 0 ;integer_x_quo
    mov    dword [esp + 16], 0 ;integer_x_rem
    mov    dword [esp + 20], 0 ;decimal_x_b0
    mov    dword [esp + 24], 0 ;decimal_x_b1
    mov    dword [esp + 28], 0 ;ascii_char
    mov    dword [esp + 32], 0 ;ascii_x_b0
    mov    dword [esp + 36], 0 ;ascii_x_b1
    mov    dword [esp + 40], 0 ;ascii_x_b2
    mov    dword [esp + 44], 0 ;ascii_x_len
    mov    dword [esp + 48], 0 ;is_negative

;+---------------------------------------------------------------------+
;|       integer_x_len := calculate_integer_length(integer_x, flag);   |
;+---------------------------------------------------------------------+

; integer_x_len := calculate_integer_length(integer_x, flag)
;-----------------------------------------------------------------------
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + 8 + 0]       ;get integer_x
    mov    ebx, [esp + 8 + 4]       ;get flag
    mov    [esp    ], eax           ;arg1: integer_x
    mov    [esp + 4], ebx           ;arg2: flag
    call   calculate_integer_length
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 8], eax           ;save return value

.is_signed_or_unsigned_int:
;+---------------------------------------------------------------------+
;|       If flag = 1 Then                                              |
;|           If (integer_x & 0x80000000) <> 0 Then                     |
;|               integer_x := (not integer_x) + 1;                     |
;|               is_negative := 1;                                     |
;+---------------------------------------------------------------------+

; If flag = 1 Then continue to .signed_int
;-----------------------------------------------------------------------
    mov    eax, [esp + 4] ;eax := flag
    cmp    eax, 1         ;compare eax with 1
    jne    .unsigned_int  ;if <>, goto .unsigned_int

.signed_int:
; If (integer_x & 0x80000000) <> 0 Then continue to .negative_value
;-----------------------------------------------------------------------
    mov    eax, [esp]      ;eax := integer_x
    and    eax, 0x80000000 ;eax := eax and 0x80000000
    cmp    eax, 0          ;compare eax with 0
    je     .positive_value ;if =, goto .positive_value

.negative_value:
; integer_x := (not integer_x) + 1
;----------------------------------------------------------------------
    mov    eax, [esp] ;eax := integer_x
    not    eax        ;eax := not eax
    add    eax, 1     ;eax := eax + 1
    mov    [esp], eax ;integer_x := eax

; is_negative := 1
;----------------------------------------------------------------------
    mov    eax, 1          ;eax := 1
    mov    [esp + 48], eax ;is_negative := eax

.positive_value:
.unsigned_int:

;+---------------------------------------------------------------------+
;|       If integer_x_len > 8 Then                                     |
;|           integer_x_quo := integer_x / 100000000;                   |
;|           integer_x_rem := remainder from the division;             |
;|           decimal_x_b0 := formula_hex2dec(integer_x_rem);           |
;|           decimal_x_b1 := formula_hex2dec(integer_x_quo);           |
;|           write_dec2string(@decimal_x_b0, 2, @ascii_x_b0,           |
;|               @ascii_x_len);                                        |
;+---------------------------------------------------------------------+

; If integer_x_len > 8 Then continue to .more_than_8
;-----------------------------------------------------------------------
    mov    eax, [esp + 8] ;eax := integer_x_len
    cmp    eax, 8         ;compare eax with 8
    jbe    .less_than_8   ;if <=, goto .less_than_8

.more_than_8:
; integer_x_quo := integer_x / 100000000
;-----------------------------------------------------------------------
    mov    eax, [esp]      ;eax := integer_x
    mov    ebx, 100000000  ;ebx := 100000000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    [esp + 12], eax ;integer_x_quo := eax

; integer_x_rem := remainder from the division
;-----------------------------------------------------------------------
    mov    [esp + 16], edx ;integer_x_rem := edx

; decimal_x_b0 := formula_hex2dec(integer_x_rem)
;-----------------------------------------------------------------------
    sub    esp, 4              ;reserve 4 bytes
    mov    eax, [esp + 4 + 16] ;get integer_x_rem
    mov    [esp], eax          ;arg1: integer_x_rem
    call   formula_hex2dec
    add    esp, 4              ;restore 4 bytes
    mov    [esp + 20], eax     ;save return value

; decimal_x_b1 := formula_hex2dec(integer_x_quo)
;-----------------------------------------------------------------------
    sub    esp, 4              ;reserve 4 bytes
    mov    eax, [esp + 4 + 12] ;get integer_x_quo
    mov    [esp], eax          ;arg1: integer_x_quo
    call   formula_hex2dec
    add    esp, 4              ;restore 4 bytes
    mov    [esp + 24], eax     ;save return value

; write_dec2string(@decimal_x_b0, 2, @ascii_x_b0, @ascii_x_len)
;-----------------------------------------------------------------------
    sub    esp, 16          ;reserve 16 bytes
    mov    eax, esp
    add    eax, (16+20)     ;get @decimal_x_b0
    mov    ebx, 2           ;get number of blocks
    mov    ecx, esp
    add    ecx, (16+32)     ;get @ascii_x_b0
    mov    edx, esp
    add    edx, (16+44)     ;get @ascii_x_len
    mov    [esp     ], eax  ;arg1: @decimal_x_b0
    mov    [esp +  4], ebx  ;arg2: num_of_blocks
    mov    [esp +  8], ecx  ;arg3: @ascii_x_b0
    mov    [esp + 12], edx  ;arg4: @ascii_x_len
    call   write_dec2string
    add    esp, 16          ;restore 16 bytes

; skip .less_than_8
;-----------------------------------------------------------------------
    jmp    .print_value

.less_than_8:
;+---------------------------------------------------------------------+
;|       Else                                                          |
;|           decimal_x_b0 := formula_hex2dec(integer_x);               |
;|           write_dec2string(@decimal_x_b0, 1, @ascii_x_b0,           |
;|               @ascii_x_len);                                        |
;+---------------------------------------------------------------------+

; decimal_x_b0 := formula_hex2dec(integer_x)
;-----------------------------------------------------------------------
    sub    esp, 4             ;reserve 4 bytes
    mov    eax, [esp + 4 + 0] ;get integer_x
    mov    [esp], eax         ;arg1: integer_x
    call   formula_hex2dec
    add    esp, 4             ;restore 4 bytes
    mov    [esp + 20], eax    ;save return value

; write_dec2string(@decimal_x_b0, 1, @ascii_x_b0, @ascii_x_len)
;-----------------------------------------------------------------------
    sub    esp, 16          ;reserve 16 bytes
    mov    eax, esp
    add    eax, (16+20)     ;get @decimal_x_b0
    mov    ebx, 1           ;get number of blocks
    mov    ecx, esp
    add    ecx, (16+32)     ;get @ascii_x_b0
    mov    edx, esp
    add    edx, (16+44)     ;get @ascii_x_len
    mov    [esp     ], eax  ;arg1: @decimal_x_b0
    mov    [esp +  4], ebx  ;arg2: num_of_blocks
    mov    [esp +  8], ecx  ;arg3: @ascii_x_b0
    mov    [esp + 12], edx  ;arg4: @ascii_x_len
    call   write_dec2string
    add    esp, 16          ;restore 16 bytes

.print_value:
;+---------------------------------------------------------------------+
;|       If is_negative = 1 Then                                       |
;|           ascii_char := 0x2d;                                       |
;|           Write(stdout, @ascii_char, 1);                            |
;|                                                                     |
;|       Write(stdout, @ascii_x_b0, ascii_x_len);                      |
;|                                                                     |
;|       ascii_char := 0x0a;                                           |
;|       Write(stdout, @ascii_char, 1);                                |
;+---------------------------------------------------------------------+

.is_print_negative_symbol:
; If is_negative = 1 Then continue below
;-----------------------------------------------------------------------
    mov    eax, [esp + 48]  ;eax := is_negative
    cmp    eax, 1           ;compare eax with 1
    jne    .print_the_value ;if <>, goto .print_the_value

.print_negative_symbol:
; ascii_char := 0x2d;
; Write(stdout, @ascii_char, 1);
;-----------------------------------------------------------------------
    mov    eax, 0x2d       ;eax := 0x2d
    mov    [esp + 28], eax ;ascii_char := eax
    mov    eax, 0x04       ;systemcall write
    mov    ebx, 0x01       ;write to stdout
    mov    ecx, esp
    add    ecx, 28         ;@ascii_char
    mov    edx, 1          ;print 1 character
    int    0x80

.print_the_value:
; Write(stdout, @ascii_x_b0, ascii_x_len);
;-----------------------------------------------------------------------
    mov    eax, 0x04       ;systecmcall write
    mov    ebx, 0x01       ;write to stdout
    mov    ecx, esp
    add    ecx, 32         ;@ascii_x_b0
    mov    edx, [esp + 44] ;ascii_x_len
    int    0x80

.return:

.clean_stackframe:
    sub    ebp, 8     ;-8 offset
    mov    esp, ebp   ;restore esp to its initial value
    mov    ebp, [esp] ;restore ebp to its initial value
    add    esp, 4     ;restore 4 bytes

    ret

