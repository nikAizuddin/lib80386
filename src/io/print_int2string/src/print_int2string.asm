;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|         FUNCTION: print_int2string                                  |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 01/NOV/2014                                       |
;| FUNCTION PURPOSE: <See doc/description file>                        |
;+---------------------------------------------------------------------+
;|         LANGUAGE: x86 Assembly Language                             |
;|           SYNTAX: Intel                                             |
;|        ASSEMBLER: NASM                                              |
;|     ARCHITECTURE: i386                                              |
;|           KERNEL: Linux 32-bit                                      |
;|           FORMAT: elf32                                             |
;|    INCLUDE FILES: calculate_integer_length.asm,                     |
;|                   formula_hex2dec.asm,                              |
;|                   write_dec2string.asm                              |
;+---------------------------------------------------------------------+
;|          VERSION: 0.1.1                                             |
;|           STATUS: Alpha                                             |
;|             BUGS: --- <See doc/bugs/index file>                     |
;+---------------------------------------------------------------------+
;| REVISION HISTORY: <See doc/revision_history/index file>             |
;+---------------------------------------------------------------------+
;|                 MIT Licensed. See /LICENSE file.                    |
;+---------------------------------------------------------------------+
;=======================================================================

extern calculate_integer_length
extern formula_hex2dec
extern write_dec2string
global print_int2string

section .text

print_int2string:

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get integer_x
    mov    ebx, [ebp +  4]          ;get addr_out_string
    mov    ecx, [ebp +  8]          ;get addr_out_strlen
    mov    edx, [ebp + 12]          ;get flag

.set_local_variables:
    sub    esp, 72                  ;reserve 72 bytes
    mov    [esp     ], eax          ;integer_x
    mov    [esp +  4], ebx          ;addr_out_string
    mov    [esp +  8], ecx          ;addr_out_strlen
    mov    [esp + 12], edx          ;flag
    mov    dword [esp + 16], 0      ;integer_x_len
    mov    dword [esp + 20], 0      ;integer_x_quo
    mov    dword [esp + 24], 0      ;integer_x_rem
    mov    dword [esp + 28], 0      ;decimal_x[0]
    mov    dword [esp + 32], 0      ;decimal_x[1]
    mov    dword [esp + 36], 0      ;ascii_x[0]
    mov    dword [esp + 40], 0      ;ascii_x[1]
    mov    dword [esp + 44], 0      ;ascii_x[2]
    mov    dword [esp + 48], 0      ;ascii_x_len
    mov    dword [esp + 52], 0      ;ascii_char
    mov    dword [esp + 56], 0      ;byte_pos
    mov    dword [esp + 60], 0      ;ctr
    mov    dword [esp + 64], 0      ;temp_ptr
    mov    dword [esp + 68], 0      ;is_negative

    ;    +-----------------------------------------------------------+
    ;----|001: integer_x_len = calc._integer_length( int._x, flag ); |--
    ;    +-----------------------------------------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + 8     ]      ;get integer_x
    mov    ebx, [esp + 8 + 12]      ;get flag
    mov    [esp    ], eax           ;arg1: integer_x
    mov    [esp + 4], ebx           ;arg2: flag
    call   calculate_integer_length
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 16], eax          ;save return value

    ;    +-------------------------+
    ;----| 002: if flag != 1, then |------------------------------------
    ;    +-------------------------+
    ;       goto .flag_notequal_1
    ;-------------------------------------------------------------------
    mov    eax, [esp + 12]          ;eax = flag
    cmp    eax, 1
    jne    .flag_notequal_1

.flag_equal_1:

    ;    +------------------------------------------------------+
    ;----| 003: if (integer_x & 0x80000000) != 0x80000000, then |-------
    ;    +------------------------------------------------------+
    ;       goto .sign_false
    ;-------------------------------------------------------------------
    mov    eax, [esp    ]           ;eax = integer_x
    and    eax, 0x80000000
    cmp    eax, 0x80000000
    jne    .sign_false

.sign_true:

    ;    +------------------------------------+
    ;----| 004: integer_x = (!integer_x) + 1; |-------------------------
    ;    +------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp]               ;eax = integer_x
    not    eax
    add    eax, 1
    mov    [esp], eax               ;integer_x = eax

    ;    +-----------------------+
    ;----| 005: is_negative = 1; |--------------------------------------
    ;    +-----------------------+
    ;-------------------------------------------------------------------
    mov    eax, 1
    mov    [esp + 68], eax          ;is_negative := eax

.sign_false:
.flag_notequal_1:

    ;    +----------------------------------+
    ;----| 006: if integer_x_len <= 8, then |---------------------------
    ;    +----------------------------------+
    ;       goto .integer_x_len_lessequal_8
    ;-------------------------------------------------------------------
    mov    eax, [esp + 16]          ;eax = integer_x_len
    cmp    eax, 8
    jbe    .integer_x_len_lessequal_8

.integer_x_len_morethan_8:

    ;    +---------------------------------------------+
    ;----| 007: integer_x_quo = integer_x / 100000000; |----------------
    ;    +---------------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp     ]          ;eax = integer_x
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx                      ;eax /= ebx
    mov    [esp + 20], eax          ;integer_x_quo = eax

    ;    +---------------------------------------------------+
    ;----| 008: integer_x_rem = remainder from the division; |----------
    ;    +---------------------------------------------------+
    ;-------------------------------------------------------------------
    mov    [esp + 24], edx          ;integer_x_rem = edx

    ;    +-------------------------------------------------------+
    ;----| 009: decimal_x[0] = formula_hex2dec( integer_x_rem ); |------
    ;    +-------------------------------------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 24]      ;get integer_x_rem
    mov    [esp         ], eax      ;arg1: integer_x_rem
    call   formula_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value

    ;    +-------------------------------------------------------+
    ;----| 010: decimal_x[1] = formula_hex2dec( integer_x_quo ); |------
    ;    +-------------------------------------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 20]      ;get integer_x_quo
    mov    [esp         ], eax      ;arg1: integer_x_quo
    call   formula_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 32], eax          ;save return value

    ;    +---------------------------------+
    ;----| 011: write decimal_x to ascii_x |----------------------------
    ;    +---------------------------------+
    ;       write_dec2string( @decimal_x[0],
    ;                         2,
    ;                         @ascii_x[0],
    ;                         @ascii_x_len );
    ;-------------------------------------------------------------------
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, esp
    mov    ecx, esp
    mov    edx, esp
    add    eax, (16+28)             ;get @decimal_x[0]
    mov    ebx, 2                   ;get num_of_blocks=2
    add    ecx, (16+36)             ;get @ascii_x[0]
    add    edx, (16+48)             ;get @ascii_x_len
    mov    [esp     ], eax          ;arg1: @decimal_x[0]
    mov    [esp +  4], ebx          ;arg2: num_of_blocks=2
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: @ascii_x_len
    call   write_dec2string
    add    esp, 16                  ;restore 16 bytes

    ;    +--------------------------------------------+
    ;----| 012: goto .skip_integer_x_len_equalmore_8; |--------------
    ;    +--------------------------------------------+
    ;-------------------------------------------------------------------
    jmp    .skip_integer_x_len_equalmore_8

.integer_x_len_lessequal_8:

    ;    +-------------------------------------------------+
    ;----| 013: decimal_x[0] = formula_hex2dec(integer_x); |------------
    ;    +-------------------------------------------------+
    ;-------------------------------------------------------------------
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4    ]       ;get integer_x
    mov    [esp        ], eax       ;arg1: integer_x
    call   formula_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value

    ;    +---------------------------------+
    ;----| 014: write decimal_x to ascii_x |----------------------------
    ;    +---------------------------------+
    ;       write_dec2string( @decimal_x[0],
    ;                         1,
    ;                         @ascii_x[0],
    ;                         @ascii_x_len );
    ;-------------------------------------------------------------------
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, esp
    mov    ecx, esp
    mov    edx, esp
    add    eax, (16+28)             ;get @decimal_x[0]
    mov    ebx, 1                   ;get num_of_blocks=1
    add    ecx, (16+36)             ;get @ascii_x[0]
    add    edx, (16+48)             ;get @ascii_x_len
    mov    [esp     ], eax          ;arg1: @decimal_x[0]
    mov    [esp +  4], ebx          ;arg2: num_of_blocks=1
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: @ascii_x_len
    call   write_dec2string
    add    esp, 16          ;restore 16 bytes

.skip_integer_x_len_equalmore_8:

;+---------------------------------------------------------------------+
;|       If is_negative = 1 Then                                       |
;|           addr_ascii_str^ := 0x2d;                                  |
;|           ++ byte_pos;                                              |
;|           ++ addr_ascii_len^;                                       |
;+---------------------------------------------------------------------+

; If is_negative = 1 Then
;-----------------------------------------------------------------------
    mov    eax, [esp + 68]    ;eax := is_negative
    cmp    eax, 1             ;compare eax with 1
    jne    .is_negative_false ;if <>, goto .is_negative_false

.is_negative_true:

; addr_ascii_str^ := 0x2d;
;-----------------------------------------------------------------------
    mov    eax, [esp + 4] ;eax := addr_ascii_str
    mov    ebx, 0x2d      ;ebx := 0x2d
    mov    [eax], ebx     ;[eax] := ebx

; ++ byte_pos;
;-----------------------------------------------------------------------
    mov    eax, [esp + 56] ;eax := byte_pos
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 56], eax ;byte_pos := eax

; ++ addr_ascii_len^;
;-----------------------------------------------------------------------
    mov    ebx, [esp + 8] ;ebx := addr_ascii_len
    mov    eax, [ebx]     ;eax := [ebx]
    add    eax, 1         ;eax := eax + 1
    mov    [ebx], eax     ;[ebx] := eax

.is_negative_false:

;+---------------------------------------------------------------------+
;|       { Fill ascii string with ascii_x }                            |
;|                                                                     |
;|       ctr := ascii_x_len;                                           |
;|       temp_ptr := @ascii_x_b0;                                      |
;|       While ctr <> 0 Do                                             |
;|       Begin                                                         |
;|           If byte_pos = 4 Then                                      |
;|               addr_ascii_str := addr_ascii_str + 4;                 |
;|               byte_pos := 0;                                        |
;|           If temp_ptr^ := 0 Then                                    |
;|               temp_ptr := temp_ptr + 4;                             |
;|           ascii_char := (temp_ptr^ and 0xff) << (byte_pos*8);       |
;|           addr_ascii_str^ := addr_ascii_str^ or ascii_char;         |
;|           ++ byte_pos;                                              |
;|           ++ (addr_ascii_len^);                                     |
;|           temp_ptr^ := temp_ptr^ >> 8;                              |
;|           -- ctr;                                                   |
;|       End.                                                          |
;+---------------------------------------------------------------------+

; ctr := ascii_x_len;
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := ascii_x_len
    mov    [esp + 60], eax ;ctr := eax

; temp_ptr := @ascii_x_b0;
;-----------------------------------------------------------------------
    mov    eax, esp
    add    eax, 36         ;eax := @ascii_x_b0
    mov    [esp + 64], eax ;temp_ptr := eax

.loop_1:

; If byte_pos = 4 Then
;-----------------------------------------------------------------------
    mov    eax, [esp + 56]      ;eax := byte_pos
    cmp    eax, 4               ;compare eax with 4
    jne    .byte_pos_notequal_4 ;if <>, goto .byte_pos_notequal_4

.byte_pos_equal_4:

; addr_ascii_str := addr_ascii_str + 4;
;-----------------------------------------------------------------------
    mov    eax, [esp + 4] ;eax := addr_ascii_str
    add    eax, 4         ;eax := eax + 4
    mov    [esp + 4], eax ;addr_ascii_str := eax

; byte_pos := 0;
;-----------------------------------------------------------------------
    xor    eax, eax        ;eax := 0
    mov    [esp + 56], eax ;byte_pos := eax

.byte_pos_notequal_4:

; If temp_ptr^ := 0 Then
;-----------------------------------------------------------------------
    mov    ebx, [esp + 64]    ;ebx := temp_ptr
    mov    eax, [ebx]         ;eax := ebx^
    cmp    eax, 0             ;compare eax with 0
    jne    .temp_ptr_notempty ;if <>, goto .temp_ptr_notempty

.temp_ptr_empty:

; temp_ptr := temp_ptr + 4;
;-----------------------------------------------------------------------
    mov    eax, [esp + 64] ;eax := temp_ptr
    add    eax, 4          ;eax := eax + 4
    mov    [esp + 64], eax ;temp_ptr := eax

.temp_ptr_notempty:

; ascii_char := (temp_ptr^ and 0xff) << (byte_pos*8);
;-----------------------------------------------------------------------
    mov    eax, [esp + 56] ;eax := byte_pos
    mov    ebx, 8          ;ebx := 8
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    ecx, eax        ;ecx := eax

    mov    eax, [esp + 64] ;eax := temp_ptr
    mov    eax, [eax]      ;eax := eax^
    and    eax, 0xff       ;eax := eax and 0xff
    shl    eax, cl         ;eax := eax << cl
    mov    [esp + 52], eax ;ascii_char := eax

; addr_ascii_str^ := addr_ascii_str^ or ascii_char;
;-----------------------------------------------------------------------
    mov    ecx, [esp + 4]  ;ecx := addr_ascii_str
    mov    eax, [ecx]      ;eax := ecx^
    mov    ebx, [esp + 52] ;ebx := ascii_char
    or     eax, ebx        ;eax := eax or ebx
    mov    [ecx], eax      ;ecx^ := eax

; ++ byte_pos;
;-----------------------------------------------------------------------
    mov    eax, [esp + 56] ;eax := byte_pos
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 56], eax ;byte_pos := eax

; ++ (addr_ascii_len^);
;-----------------------------------------------------------------------
    mov    ebx, [esp + 8] ;ebx := addr_ascii_len
    mov    eax, [ebx]     ;eax := ebx^
    add    eax, 1         ;eax := eax + 1
    mov    [ebx], eax     ;ebx^ := eax

; temp_ptr^ := temp_ptr^ >> 8;
;-----------------------------------------------------------------------
    mov    ebx, [esp + 64] ;ebx := temp_ptr
    mov    eax, [ebx]      ;eax := ebx^
    shr    eax, 8          ;eax := eax >> 8
    mov    [ebx], eax      ;ebx^ := eax

; -- ctr;
;-----------------------------------------------------------------------
    mov    eax, [esp + 60] ;eax := ctr
    sub    eax, 1          ;eax := eax - 1
    mov    [esp + 60], eax ;ctr := eax

; While ctr <> 0, goto .loop_1
;-----------------------------------------------------------------------
    mov    eax, [esp + 60] ;eax := ctr
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_1         ;if <>, goto .loop_1

.endloop:

.return:

.clean_stackframe:
    sub    ebp, 8     ;-8 offset to remove arguments
    mov    esp, ebp   ;restore stack ptr to initial value
    mov    ebp, [esp] ;restore ebp to initial value
    add    esp, 4     ;restore 4 bytes

    ret

