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
;   INCLUDED FILES: read4096b_stdin.asm,
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
;       HOW TO RUN: $ nasm submit.asm -o submit.o -felf32
;                   $ ld submit.o -o exe -melf_i386
;                   $ ./exe
;
;=====================================================================

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


;#####################################################################


cvt_dec2hex:

;parameter 1 = decimal_number:32bit
;returns = the hexadecimal number (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get decimal_number

.setup_localvariables:
    sub    esp, 36                  ;reserve 36 bytes
    mov    [esp     ], eax          ;decimal_number
    mov    dword [esp +  4], 0      ;A
    mov    dword [esp +  8], 0      ;B
    mov    dword [esp + 12], 0      ;C
    mov    dword [esp + 16], 0      ;D
    mov    dword [esp + 20], 0      ;E
    mov    dword [esp + 24], 0      ;F
    mov    dword [esp + 28], 0      ;G
    mov    dword [esp + 32], 0      ;H


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     A =  decimal_number >>  4;  
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 4
    mov    [esp +  4], eax          ;A = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:     B = (decimal_number >>  8) * 0xa;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 8
    mov    ebx, 0xa
    xor    edx, edx
    mul    ebx
    mov    [esp +  8], eax          ;B = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:     C = (decimal_number >> 12) * 0x64;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 12
    mov    ebx, 0x64
    xor    edx, edx
    mul    ebx
    mov    [esp + 12], eax          ;C = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:     D = (decimal_number >> 16) * 0x3e8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 16
    mov    ebx, 0x3e8
    xor    edx, edx
    mul    ebx
    mov    [esp + 16], eax          ;D = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:     E = (decimal_number >> 20) * 0x2710;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 20
    mov    ebx, 0x2710
    xor    edx, edx
    mul    ebx
    mov    [esp + 20], eax          ;E = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:     F = (decimal_number >> 24) * 0x186a0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 24
    mov    ebx,  0x186a0
    xor    edx, edx
    mul    ebx
    mov    [esp + 24], eax          ;F = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:     G = (decimal_number >> 28) * 0xf4240;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 28
    mov    ebx, 0xf4240
    xor    edx, edx
    mul    ebx
    mov    [esp + 28], eax          ;G = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:     H = 0x6 * (A + B + C + D + E + F + G); 
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = A
    mov    ebx, [esp +  8]          ;ebx = B
    mov    ecx, [esp + 12]          ;ecx = C
    mov    edx, [esp + 16]          ;edx = D
    mov    esi, [esp + 20]          ;esi = E
    mov    edi, [esp + 24]          ;edi = F
    add    eax, ebx
    add    eax, ecx
    add    eax, edx
    add    eax, esi
    add    eax, edi
    mov    ebx, 0x6
    mov    ecx, [esp + 28]          ;ecx = G
    xor    edx, edx
    add    eax, ecx
    mul    ebx
    mov    [esp + 32], eax          ;H = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:     EAX = decimal_number - H;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    mov    ebx, [esp + 32]          ;ebx = H
    sub    eax, ebx


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_dec2string:

;parameter 1 = addr_decimal_x:32bit
;parameter 2 = num_of_blocks:32bit
;parameter 3 = addr_out_string:32bit
;parameter 4 = addr_out_strlen:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_decimal_x
    mov    ebx, [ebp +  4]          ;get num_of_blocks
    mov    ecx, [ebp +  8]          ;get addr_out_string
    mov    edx, [ebp + 12]          ;get addr_out_strlen

.setup_localvariables:
    sub    esp, 52                  ;reserve 52 bytes
    mov    [esp     ], eax          ;decimal_x_ptr
    mov    [esp +  4], ebx          ;num_of_blocks
    mov    [esp +  8], ecx          ;addr_out_string
    mov    [esp + 12], edx          ;addr_out_strlen
    mov    dword [esp + 16], 0      ;out_strlen 
    mov    dword [esp + 20], 0      ;decimal_y[0]
    mov    dword [esp + 24], 0      ;decimal_y[1]
    mov    dword [esp + 28], 0      ;decimal_y[0]_len
    mov    dword [esp + 32], 0      ;decimal_y[1]_len
    mov    dword [esp + 36], 0      ;temp
    mov    dword [esp + 40], 0      ;i
    mov    dword [esp + 44], 0      ;ascii_char
    mov    dword [esp + 48], 0      ;byte_pos


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check the number of decimal_x memory blocks.
;
;   If there are 2 memory blocks, that means decimal_x has
;   an integer value that more than 8 digits, such as 9 or 10
;   digits.
;
;   001:   if num_of_blocks == 2, goto .skip_decimal_x_1_block;
;          .goto_decimal_x_1_block:
;   002:       goto .decimal_x_1_block;
;          .skip_decimal_x_1_block:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = num_of_blocks
    cmp    eax, 2
    je     .skip_decimal_x_1_block
.goto_decimal_x_1_block:
    jmp    .decimal_x_1_block
.skip_decimal_x_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If the decimal_x has 2 memory blocks.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.decimal_x_2_blocks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   decimal_y[0] = addr_decimal_x^
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = addr_decimal_x
    mov    eax, [eax]               ;eax = addr_decimal_x^
    mov    [esp + 20], eax          ;decimal_y[0] = addr_decimal_x^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   decimal_y[1] = (addr_decimal_x+4)^
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = addr_decimal_x
    add    eax, 4
    mov    eax, [eax]               ;eax = (addr_decimal_x+4)^
    mov    [esp + 24], eax          ;decimal_y[1] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   decimal_y[0]_len = 8
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 8
    mov    [esp + 28], eax          ;decimal_y[0]_len = 8


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_1: Find the number of nibbles in decimal_y[1].
;            The decimal_y[1]_len itself stores the number of
;            nibbles from decimal_y[1].
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_1
;
;   006:   temp = decimal_y[1]
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_y[1]
    mov    [esp + 36], eax          ;temp = eax


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   temp >>= 4
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   ++ decimal_y[1]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_y[1]_len
    add    eax, 1
    mov    [esp + 32], eax          ;decimal_y[1]_len = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   if temp != 0, then
;              goto .loop_1
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_2: Convert decimal_y[1] to ASCII string,
;            and stores to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_2
;
;   010:   i = decimal_y[1]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_y[1]_len
    mov    [esp + 40], eax          ;i = decimal_y[1]_len


.loop_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   ascii_char = ((decimal_y[1] >> ( (i-1)*4 )) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    ecx, eax
    mov    eax, [esp + 24]          ;eax = decimal_y[1]
    shr    eax, cl                  ;decimal_y[1] >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    ecx, eax
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax <<= (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;addr_out_string^ |= result
    mov    [ecx], eax               ;save result to addr_out_string^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   ++ out_strlen
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   ++ byte_pos
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pox + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   -- i 
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i - 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   if i != 0, then
;              goto .loop_2;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]         ;eax = i
    cmp    eax, 0
    jne    .loop_2


.endloop_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_3: Convert decimal_y[0] to ASCII string,
;            and append to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_3
;
;   017:   i = decimal_y[0]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    mov    [esp + 40], eax          ;i = decimal_y[0]_len


.loop_3:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   ascii_char = ((decimal_y[0] >> ( (i-1)*4) ) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= 4
    mov    ecx, eax                 ;ecx = ((i-1)*4)
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    shr    eax, cl                  ;eax >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;byte_pos *= 8
    mov    ecx, eax                 ;ecx = (byte_pos*8)
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax <<= (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;addr_out_string^ |= result
    mov    [ecx], eax               ;save result to addr_out_string^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   ++ out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen 
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   ++ byte_pos
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pos + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if output string memory block is full.
;
;   TRUE  = The output string memory block is not yet full.
;   FALSE = The output string memory block is full.
;
;   If the output string memory block is full, point the
;   addr_out_string to the next memory block of output string,
;   and reset the byte position to 0.
;
;   022:   if byte_pos != 4, then
;              goto .cond1_out_string_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    cmp    eax, 4
    jne    .cond1_out_string_not_full      


.cond1_out_string_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   addr_out_string += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = addr_out_string
    add    eax, 4
    mov    [esp + 8], eax           ;addr_out_string = (eax + 4)


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   byte_pos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 48], eax          ;byte_pos = eax


.cond1_out_string_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   if i != 0, then
;             goto .loop_3;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    cmp    eax, 0
    jne    .loop_3


.endloop_3:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Skip .decimal_x_1_block.
;
;   027:   goto .save_out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .save_out_strlen


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If the decimal_x has only 1 memory block.
;   Means, the decimal_x's value is less than 8 digits.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.decimal_x_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   decimal_y[0] = addr_out_string^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_out_string
    mov    eax, [eax]               ;eax = addr_out_string^
    mov    [esp + 20], eax          ;decimal_x_b0 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_4: Find the number of nibbles in decimal_y[0].
;            The decimal_y[0]_len itself stores the number
;            of nibbles from decimal_y[0].
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_4
;
;   029:   temp = decimal_y[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    mov    [esp + 36], eax          ;temp = eax


.loop_4:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:   temp >>= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = temp >> 4


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:   ++ decimal_y[0]_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    add    eax, 1
    mov    [esp + 28], eax          ;decimal_y[0]_len = eax + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   032:   if temp != 0, then
;              goto .loop_4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    cmp    eax, 0
    jne    .loop_4


.endloop_4:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_5: Convert decimal_y[0] to ASCII string,
;            and stores to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_5
;
;   033:   i = decimal_y[0]_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    mov    [esp + 40], eax          ;counter = eax


.loop_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   034:   ascii_char = ((decimal_y[0] >> ((i-1)*4)) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax = (i-1) * 4
    mov    ecx, eax
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    shr    eax, cl                  ;eax = decimal_y[0] >> ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   035:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax = byte_pos * 8
    mov    ecx, eax
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax = ascii_char << (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;eax = result | addr_out_string
    mov    [ecx], eax               ;addr_out_string^ = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   036:   ++ out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   037:   ++ byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pos + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if output string memory block is full.
;
;   TRUE  = The output string memory block is not yet full.
;   FALSE = The output string memory block is full.
;
;   If the output string memory block is full, point the
;   addr_out_string to the next memory block of output string,
;   and reset the byte position to 0.
;
;   038:   if byte_pos != 4 then
;              goto .cond2_out_string_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    cmp    eax, 4
    jne    .cond2_out_string_not_full


.cond2_out_string_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   039:   addr_out_string += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = addr_out_string
    add    eax, 4
    mov    [esp + 8], eax           ;addr_out_string += 4


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   040:   byte_pos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 48], eax          ;byte_pos = 0


.cond2_out_string_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   041:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   042:   if i != 0, then
;              goto .loop_5;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    cmp    eax, 0
    jne    .loop_5


.endloop_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the length of out_string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.save_out_strlen:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   043:   addr_out_strlen^ = out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    mov    ebx, [esp + 12]          ;ebx = addr_out_strlen
    mov    [ebx], eax               ;addr_out_strlen^ = out_strlen


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_double2string:

;parameter 1 = double_x:64bit
;parameter 2 = decimal_places:32bit
;parameter 3 = addr_out_string^:32bit
;parameter 4 = addr_out_strlen^:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack pointer to ebp

.get_arg_set_local_variables:
    sub    esp, 92                  ;reserve 92 bytes
    add    ebp, 8                   ;+8 offset to get the arguments

    mov    eax, [ebp    ]           ;get double_x[0]
    mov    ebx, [ebp + 4]           ;get double_x[1]
    mov    ecx, [ebp + 8]           ;get decimal_places
    mov    [esp     ], eax          ;double_x[0]
    mov    [esp +  4], ebx          ;double_x[1]
    mov    [esp +  8], ecx          ;decimal_places

    mov    eax, [ebp + 12]          ;get addr_out_string^
    mov    ebx, [ebp + 16]          ;get addr_out_strlen^
    mov    [esp + 12], eax          ;addr_out_string^
    mov    [esp + 16], ebx          ;addr_out_strlen^

    mov    dword [esp + 20], 0      ;integer_part
    mov    dword [esp + 24], 0      ;decimal_part[0]
    mov    dword [esp + 28], 0      ;decimal_part[1]
    mov    dword [esp + 32], 0      ;decimal_part_str[0]
    mov    dword [esp + 36], 0      ;decimal_part_str[1]
    mov    dword [esp + 40], 0      ;decimal_part_strlen
    mov    dword [esp + 44], 0      ;fpu_controlword
    mov    dword [esp + 48], 0      ;temp
    mov    dword [esp + 52], 0x2e   ;dot_character
    mov    dword [esp + 56], 0      ;cur_dec_places
    mov    dword [esp + 60], 0x30303030 ;zeroes_str[0]
    mov    dword [esp + 64], 0x30303030 ;zeroes_str[1]
    mov    dword [esp + 68], 0      ;zeroes_strlen


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the integer part from the double_x
;
;   For example:
;   Given double_x = 2147483647.12345678
;   The integer_part will be 2147483647
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   initialize FPU stacks;
;
;   Initializes the FPU to its default state. Flags all
;   FPU registers as empty, clears the top stack pointer.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set the RC Bit = 11 (Bit 10 and Bit 11). See diagram
;   below:
;
;          +-----+
;   BIT  0 | IM  | --> Invalid operation Mask
;          +-----+
;   BIT  1 | DM  | --> Denormalized operand Mask
;          +-----+
;   BIT  2 | ZM  | --> Zero divide Mask
;          +-----+
;   BIT  3 | OM  | --> Overflow Mask
;          +-----+
;   BIT  4 | UM  | --> Underflow Mask
;          +-----+
;   BIT  5 | PM  | --> Precision Mask
;          +-----+
;   BIT  6 |     |
;          +-----+
;   BIT  7 | IEM | --> Interrupt Enable Mask
;          +-----+
;   BIT  8 | PC  | --> Precision Control
;   BIT  9 |     |
;          +-----+
;   BIT 10 | RC  | --> Rounding Control, 11B = truncate
;   BIT 11 |     |
;          +-----+
;   BIT 12 | IC  | --> Infinity control
;          +-----+
;   BIT 13 |     |
;          +-----+
;   BIT 14 |     |
;          +-----+
;   BIT 15 |     |
;          +-----+
;
;             Diagram 1: FPU Control word register.
;
;   reference: http://www.website.masmforum.com/tutorials/fptute/
;              fpuchap1.htm
;
;   002:   set FPU rounding mode to truncate;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fstcw  word [esp + 44]          ;save fpu controlword to memory
    mov    ax, [esp + 44]           ;ax = fpu controlword
    or     eax, 110000000000B       ;rounding control = truncate
    mov    [esp + 44], ax           ;save ax value to memory
    fldcw  word [esp + 44]          ;use our fpu control word value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Copy double_x into FPU, so that later we can convert
;   to integer value, without rounding (truncate).
;
;   003:   push double_x into FPU;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fld    qword [esp]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This will convert the double_x into integer value.
;   Lets say the double_x = 3.8992, when convert to int
;   it will becomes 3 and store into integer_part variable.
;
;   004:   convert double_x to int and save to integer_part;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fist   dword [esp + 20]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the decimal part from the double_x
;
;   For example:
;   Given double_x = 2147483647.12345678
;
;   The decimal_part will be 12345678, but however this depends
;   on the value of decimal_places. If the decimal_places is 100,
;   the decimal_part will becomes 12.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   reinitialize FPU stacks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   push double_x into FPU;
;
;   FPU stacks before this instruction:
;       st0 = <empty>
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = double_x
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fld    qword [esp]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   push integer_part into FPU;
;
;   FPU stacks before this instruction:
;       st0 = double_x
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = integer_part
;       st1 = double_x
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 20]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   st0 = st1 - st0;
;
;   Purpose of this subtraction (double_x - integer_part),
;   is to get the decimal part of the double_x.
;
;   How? Lets say,
;       double_x = 2147483647.12345678,
;       integer_part = 2147483647.00000000
;
;   After subtraction we will get 0.12345678, this is the
;   decimal part of the double_x.
;       
;   FPU stacks before this instruction:
;       st0 = integer_part
;       st1 = double_x
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_part = double_x - integer_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fsub                            ;st0 = st1 - st0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   push decimal_places into FPU;
;
;   This will set how many decimal places that we want to
;   print to stdout.
;
;   FPU stacks before this instruction:
;       st0 = decimal_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_places
;       st1 = decimal_part
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp +  8]         ;push decimal_places into fpu


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   st0 = st1 * st0;
;
;   This multiplication will set how many decimal places
;   of double_x that we want. Lets say the decimal_part is
;   0.1234567, when multiply with 100, it becomes 12.34567.
;   So, only 12 will be taken as decimal part value.
;
;   FPU stacks before this instruction:
;       st0 = decimal_places
;       st1 = decimal_part
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_part = decimal_places * decimal_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fmul                            ;st0 = st1 * st0;


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   save and pop st0 to decimal_part;
;
;   Now we have done obtaining the decimal part of the
;   double_x. Store the result into decimal_part variable,
;   and pop the FPU register.
;
;   However, there are 2 problems arise:
;      1) When the decimal_part >= 0.5, for example
;         0.675, 0.999999, 0.9, 0.543, and so on...
;
;      2) When there is zeroes in front of decimal_part,
;         for example when decimal_part = 0.031, 0.00213,
;         0.0005412, and so on....
;
;   Fortunately, these problems already solved :)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fistp  qword [esp + 24]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Solve problem if the decimal_part >= 0.5
;
;   The solution is, we have to round the integer_part by 1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   if decimal_part[0] & 0x80000000 != 0x80000000, then
;              goto .decimal_part_is_pos.
;
;   This check positive/negative sign of the decimal_part.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    and    eax, 0x80000000
    cmp    eax, 0x80000000
    jne    .decimal_part_is_pos


.decimal_part_is_neg:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If we found that decimal_part is negative, we first
;   have to reverse two's complement value.
;
;   013:   decimal_part[0] = (!decimal_part[0]) + 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    not    eax
    add    eax, 1
    mov    [esp + 24], eax          ;decimal_part[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set the temp value as -1.
;
;   014:   temp = -1;
;
;   Because later, lets say the decimal_part is -0.999,
;   we have to -1 so that the decimal_part becomes -1.000.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, -1
    mov    [esp + 48], eax          ;temp = eax
    jmp    .end_decimal_part_check_sign


.decimal_part_is_pos:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If we found that the decimal_part is positive, we just
;   set the temp value as 1. Because later, if we found that
;   decimal_part needs to be rounded, we just add temp to
;   the decimal_part.
;
;   015:   temp = 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 1                   ;eax = 1
    mov    [esp + 48], eax          ;temp = eax


.end_decimal_part_check_sign:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert the decimal part to ascii string
;
;   016:   cvt_int2string( decimal_part[0],
;                          @decimal_part_str[0],
;                          @decimal_part_strlen,
;                          0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ebx, esp
    mov    ecx, esp
    mov    eax, [esp + 16 + 24]     ;get decimal_part[0]
    add    ebx, (16 + 32)           ;get @decimal_part_str[0]
    add    ecx, (16 + 40)           ;get @decimal_part_strlen
    xor    edx, edx                 ;get flag=0
    mov    [esp     ], eax          ;arg1: decimal_part[0]
    mov    [esp +  4], ebx          ;arg2: @decimal_part_str[0]
    mov    [esp +  8], ecx          ;arg3: @decimal_part_strlen
    mov    [esp + 12], edx          ;arg4: flag=0
    call   cvt_int2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
;   017:   if decimal_part[0] != decimal_places, then
;              goto .dont_round_integer_part.
;
;   This checks whether we need to add integer_part
;   by 1 or not. If we must add integer_part by 1,
;   we also need to zero the decimal_part.
;
;   Consider this decimal_part problem, assume we want
;   to print only 2 decimal places:
;
;       0.9250 * 100 = 99.25
;       when convert to integer, round to nearest = 99
;       NO PROBLEM. Because 99 is still 2 decimal places.
;       Just jump to .dont_round_integer_part.
;
;       0.9750 * 100 = 99.75
;       when convert to integer, round to nearest = 100
;       PROBLEM!!! 100 is more than 2 decimal places.
;       Need to execute .round_integer_part to solve this.
;
;   SOLUTION TO THE PROBLEM:
;   If we found that decimal_part = 100 = decimal_places,
;   then:
;
;       integer_part += 1
;
;       decimal_part_str[0] &= 0xfffffff0
;       means that if decimal_part_str[0] = 0x00303031,
;       then we mask it with 0xfffffff0 so that it becomes
;       0x00303030.
;
;       decimal_part_strlen -= 1, so, we only use 0x00003030
;       in the decimal_part_str.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jne    .dont_round_integer_part ;if !=, .dont_round_integer_part


.round_integer_part:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   integer_part = integer_part + temp;
;
;   This will add the integer_part by temp value. Note that
;   the temp value can be +1 or -1, depends on the
;   decimal_part sign. If decimal_part is negative, then
;   the value of temp will be -1. Otherwise, if decimal_part
;   is positive, then the value of temp will be +1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = integer_part
    mov    ebx, [esp + 48]          ;ebx = temp
    add    eax, ebx
    mov    [esp + 20], eax          ;integer_part = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   decimal_part_str[0] &= 0xfffffff0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_part_str[0]
    and    eax, 0xfffffff0
    mov    [esp + 32], eax          ;decimal_part_str[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   -- decimal_part_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 40]          ;ebx = decimal_part_strlen
    sub    ebx, 1
    mov    [esp + 40], ebx          ;decimal_part_strlen = ebx


.dont_round_integer_part:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert the integer part to out string
;
;   For example:
;
;   Given integer_part = 2147483647
;   The out_string[0] will be 0x37343132,
;   the out_string[1] will be 0x36333834,
;   the out_string[2] will be 0x3734,
;   and the out_strlen will be 10
;
;   If given integer_part = -2147483647
;   The out_string[0] will be 0x3431322d,
;   the out_string[1] will be 0x33383437,
;   the out_string[2] will be 0x373436,
;   and the out_strlen will be 11
;
;   021:   cvt_int2string( integer_part,
;                         addr_out_string,
;                         addr_out_strlen,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp + (16 + 20)]   ;get integer_part
    mov    ebx, [esp + (16 + 12)]   ;get addr_out_string
    mov    ecx, [esp + (16 + 16)]   ;get addr_out_strlen
    mov    edx, 1                   ;get flag=1
    mov    [esp     ], eax          ;arg1: integer_part
    mov    [esp +  4], ebx          ;arg2: addr_out_string
    mov    [esp +  8], ecx          ;arg3: addr_out_strlen
    mov    [esp + 12], edx          ;arg4: flag=1
    call   cvt_int2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append a dot character into ascii string
;
;   For example:
;   Given ascii_string 0x37343132363338343734
;
;   After inserting the dot character at the end,
;   the ascii_string will be 0x2e37343132363338343734
;
;   022:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @dot_character,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 52)           ;get @dot_character
    mov    edx, 1                   ;get src_strlen = 1 character
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @dot_character
    mov    [esp + 12], edx          ;arg4: src_strlen = 1 character
    call   string_append
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Solve problem for heading zeroes in decimal_part
;
;   If decimal_part = 0.00214 or any number that has heading
;   zeroes, the problem occurs after we multiply it with
;   decimal_places. Example problem:
;
;       decimal_places = 1000
;       decimal_part = decimal_part * decimal_places
;       decimal_part = 0.00214 * 1000
;       decimal_part = 2.14
;
;   See that? The program supposed to print 0.002, but the
;   program prints only 0.2.
;
;   To solve this, before we append the decimal_part_str to the
;   out_string, first we append the required heading zeroes string
;   to the out_string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the current decimal places of the decimal_part_str.
;
;   023:   cur_dec_places = pow_int( 10, decimal_part_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;get base_value = 10
    mov    ebx, [esp + (8 + 40)]    ;get pow_val = decimal_part_strlen
    mov    [esp    ], eax           ;arg1: base_val = 10
    mov    [esp + 4], ebx           ;arg2: pow_val=decimal_part_strlen
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 56], eax          ;cur_dec_places = eax (ret value)


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   if cur_dec_places >= decimal_places, then
;              goto .dont_insert_heading_zeroes
;
;   But if we found that current decimal places of
;   decimal part string is less, execute this condition.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jge    .dont_insert_heading_zeroes


.insert_heading_zeroes:


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This loop will find out how many heading zeroes characters
;   that are required to append to the out_string.
;
;   025:   cur_dec_places *= 10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, 10
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 56], eax          ;cur_dec_places = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   ++ zeroes_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 68]          ;eax = zeroes_strlen
    add    eax, 1
    mov    [esp + 68], eax          ;zeroes_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:   if cur_dec_places != decimal_places, .loop_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jne    .loop_1


.endloop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Now, we have found out how many required heading zeroes.
;   Append the heading zeroes string to the out_string.
;
;   028:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @zeroes_str[0],
;                         zeroes_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 60)           ;get @zeroes_str[0]
    mov    edx, [esp + (16 + 68)]   ;get zeroes_strlen
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @zeroes_str[0]
    mov    [esp + 12], edx          ;arg4: zeroes_strlen
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.dont_insert_heading_zeroes:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Finally, append the decimal_part to the out_string.
;
;   029:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @decimal_part_str[0],
;                         decimal_part_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 32)           ;get @decimal_part_str[0]
    mov    edx, [esp + (16 + 40)]   ;get decimal_part_strlen
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @decimal_part_str[0]
    mov    [esp + 12], edx          ;arg4: decimal_part_strlen
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp value to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_hex2dec:

;parameter 1 = hexadecimal_num:32bit
;returns = decimal number (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offsets, to get arguments
    mov    eax, [ebp]               ;get hexadecimal_num

.setup_localvariables:
    sub    esp, 80                  ;reserve 80 bytes of stack
    mov    [esp     ], eax          ;hexadecimal_num
    mov    dword [esp +  4], 0      ;decimal_num
    mov    dword [esp +  8], 0      ;A
    mov    dword [esp + 12], 0      ;B
    mov    dword [esp + 16], 0      ;C
    mov    dword [esp + 20], 0      ;D
    mov    dword [esp + 24], 0      ;E
    mov    dword [esp + 28], 0      ;F
    mov    dword [esp + 32], 0      ;G
    mov    dword [esp + 36], 0      ;H
    mov    dword [esp + 40], 0      ;I
    mov    dword [esp + 44], 0      ;J
    mov    dword [esp + 48], 0      ;K
    mov    dword [esp + 52], 0      ;L
    mov    dword [esp + 56], 0      ;M
    mov    dword [esp + 60], 0      ;N
    mov    dword [esp + 64], 0      ;O
    mov    dword [esp + 68], 0      ;P
    mov    dword [esp + 72], 0      ;Q
    mov    dword [esp + 76], 0      ;R


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   A = (hexadecimal_num / 1000000000)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    [esp +  8], eax          ;A = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   B = 16 * A
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = A
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 12], eax          ;B = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   C = (hexadecimal_num / 100000000) + B
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecmal_num
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 12]          ;ebx = B
    add    eax, ebx
    mov    [esp + 16], eax          ;C = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   D = 16 * C
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = C
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 20], eax          ;D = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   E = (hexadecimal_num / 10000000) + D
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 20]          ;ebx = D
    add    eax, ebx
    mov    [esp + 24], eax          ;E = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   F = 16 * E
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = E
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 28], eax          ;F = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   G = (hexadecimal_num / 1000000) + F
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 28]          ;ebx = F
    add    eax, ebx
    mov    [esp + 32], eax          ;G = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   H = 16 * G
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = G
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 36], eax          ;H = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   I = (hexadecimal_num / 100000) + H
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 100000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 36]          ;ebx = H
    add    eax, ebx
    mov    [esp + 40], eax          ;I = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   J = 16 * I
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = I
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 44], eax          ;J = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   K = (hexadecimal_num / 10000) + J
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 44]          ;ebx = J
    add    eax, ebx
    mov    [esp + 48], eax          ;K = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   L = 16 * K
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = K
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 52], eax          ;L = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   M = (hexadecimal_num / 1000) + L
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 52]          ;ebx = L
    add    eax, ebx
    mov    [esp + 56], eax          ;M = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   N = 16 * M
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = M
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 60], eax          ;N = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   O = (hexadecimal_num / 100) + N
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 100
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 60]          ;ebx = N
    add    eax, ebx
    mov    [esp + 64], eax          ;O = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   P = 16 * O
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 64]          ;eax = O
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 68], eax          ;P = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   Q = (hexadecimal_num / 10) + P
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 68]          ;ebx = P
    add    eax, ebx
    mov    [esp + 72], eax          ;Q = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   R = 6 * Q
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 72]          ;eax = Q
    mov    ebx, 6
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 76], eax          ;R = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   decimal_num = hexadecimal_num + R
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, [esp + 76]          ;ebx = R
    add    eax, ebx
    mov    [esp +  4], eax          ;decimal_num = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   exit( decimal_num )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.return:
    mov    eax, [esp + 4]           ;eax = decimal_num


.clean_stackframe:
    sub    ebp, 8                   ;-8 offsets, to get initial esp
    mov    esp, ebp                 ;restore esp to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_int2string:

;parameter 1 = integer_x:32bit
;parameter 2 = addr_out_string^:32bit
;parameter 3 = addr_out_strlen^:32bit
;parameter 4 = flag:32bit
;returns = ---

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
    sub    esp, 56                  ;reserve 56 bytes
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
    mov    dword [esp + 52], 0      ;is_negative


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the number of digits in integer_x
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   integer_x_len = find_int_digits( integer_x, flag );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + 8     ]      ;get integer_x
    mov    ebx, [esp + 8 + 12]      ;get flag
    mov    [esp    ], eax           ;arg1: integer_x
    mov    [esp + 4], ebx           ;arg2: flag
    call   find_int_digits
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 16], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Checks whether integer_x is signed or unsigned
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   if flag != 1, then
;              goto .flag_notequal_1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = flag
    cmp    eax, 1
    jne    .flag_notequal_1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is signed.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.flag_equal_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003: if (integer_x & 0x80000000) != 0x80000000, then
;            goto .sign_false.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp    ]           ;eax = integer_x
    and    eax, 0x80000000
    cmp    eax, 0x80000000
    jne    .sign_false


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is negative
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.sign_true:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   The integer_x is negative, and need Two's complement.
;
;   004: integer_x = (!integer_x) + 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    not    eax
    add    eax, 1
    mov    [esp], eax               ;integer_x = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Memorize the program that the integer_x is negative.
;
;   005: is_negative = 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 1
    mov    [esp + 52], eax          ;is_negative = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is positive
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.sign_false:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is unsigned.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.flag_notequal_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   if integer_x_len > 8, goto .skip_int_x_len_le_8;
;          .goto_int_x_len_le_8:
;   007:       goto .integer_x_len_lessequal_8;
;          .skip_int_x_len_le_8:
;
;   Means, the number of digits in integer_x_len is
;   less than or equal 8.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = integer_x_len
    cmp    eax, 8
    jg     .skip_int_x_len_le_8
.goto_int_x_len_le_8:
    jmp    .integer_x_len_lessequal_8
.skip_int_x_len_le_8:


.integer_x_len_morethan_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008: integer_x_quo = integer_x / 100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = integer_x
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx                      ;eax /= ebx
    mov    [esp + 20], eax          ;integer_x_quo = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009: integer_x_rem = remainder from the division;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [esp + 24], edx          ;integer_x_rem = edx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010: decimal_x[0] = cvt_hex2dec( integer_x_rem );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 24]      ;get integer_x_rem
    mov    [esp         ], eax      ;arg1: integer_x_rem
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011: decimal_x[1] = cvt_hex2dec( integer_x_quo );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 20]      ;get integer_x_quo
    mov    [esp         ], eax      ;arg1: integer_x_quo
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 32], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012: cvt_dec2string( @decimal_x[0],
;                        2,
;                        @ascii_x[0],
;                        @ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013: goto .skip_integer_x_len_equalmore_8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .skip_integer_x_len_equalmore_8


.integer_x_len_lessequal_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014: decimal_x[0] = cvt_hex2dec(integer_x);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4    ]       ;get integer_x
    mov    [esp        ], eax       ;arg1: integer_x
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015: cvt_dec2string( @decimal_x[0],
;                        1,
;                        @ascii_x[0],
;                        @ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes


.skip_integer_x_len_equalmore_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016: if is_negative != 1, then
;            goto .is_negative_false
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 52]          ;eax = is_negative
    cmp    eax, 1
    jne    .is_negative_false


.is_negative_true:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017: addr_out_string^ = 0x2d;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = addr_ascii_str
    mov    ebx, 0x2d                ;ebx = 0x2d
    mov    [eax], ebx               ;eax^ = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018: ++ addr_out_strlen^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 8]           ;ebx = addr_out_strlen
    mov    eax, [ebx]               ;eax = ebx^
    add    eax, 1                   ;eax += 1
    mov    [ebx], eax               ;ebx^ = eax

.is_negative_false:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019: string_append( addr_out_string,
;                       addr_out_strlen,
;                       @ascii_x[0],   
;                       ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp + (16 + 4)]    ;get addr_out_string
    mov    ebx, [esp + (16 + 8)]    ;get addr_out_strlen
    mov    ecx, esp
    add    ecx, (16 + 36)           ;get @ascii_x[0]
    mov    edx, [esp + (16 + 48)]   ;get ascii_x_len
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: ascii_x_len
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to remove arguments
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_string2dec:

;parameter 1 = addr_string:32bit
;parameter 2 = strlen:32bit
;parameter 3 = addr_decimal:32bit
;parameter 4 = addr_digits:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_parameters:
    add    ebp, 8                   ;+8 offset to get parameters
    mov    eax, [ebp     ]          ;get addr_string
    mov    ebx, [ebp +  4]          ;get strlen
    mov    ecx, [ebp +  8]          ;get addr_decimal
    mov    edx, [ebp + 12]          ;get addr_digits

.set_localvariables:
    sub    esp, 48                  ;reserve 48 bytes
    mov    [esp     ], eax          ;addr_string
    mov    [esp +  4], ebx          ;strlen
    mov    [esp +  8], ecx          ;addr_decimal
    mov    [esp + 12], edx          ;addr_digits
    mov    dword [esp + 16], 0      ;in_ptr
    mov    dword [esp + 20], 0      ;in_buffer
    mov    dword [esp + 24], 0      ;out_ptr
    mov    dword [esp + 28], 0      ;out_buffer
    mov    dword [esp + 32], 0      ;out_bitpos
    mov    dword [esp + 36], 0      ;decimal_number
    mov    dword [esp + 40], 0      ;digits
    mov    dword [esp + 44], 0      ;i


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   in_ptr = addr_string;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_string
    mov    [esp + 16], eax          ;in_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   in_buffer = in_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    mov    ebx, [eax]
    mov    [esp + 20], ebx          ;in_buffer = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   i = strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    mov    [esp + 44], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   if strlen != 0, goto .strlen_not_zero
;          .strlen_zero:
;   005:       goto .return;
;          .strlen_not_zero:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = strlen
    cmp    eax, 0
    jne    .strlen_not_zero
.strlen_zero:
    jmp    .return
.strlen_not_zero:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   if strlen > 8, then
;              goto .decimal_num_2_blocks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    mov    ebx, 8                   ;ebx = 8
    cmp    eax, ebx
    jg     .decimal_num_2_blocks


.decimal_num_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   out_bitpos = (strlen - 1) * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   out_ptr = addr_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_decimal
    mov    [esp + 24], eax          ;out_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   goto .loop_get_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_decimal


.decimal_num_2_blocks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   out_bitpos = (strlen - 9) * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    sub    eax, 9
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   out_ptr = addr_decimal + 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_decimal
    mov    ebx, 4
    add    eax, ebx                 ;eax += ebx
    mov    [esp + 24], eax          ;out_ptr = eax


.loop_get_decimal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if in_buffer is empty
;
;   012:   if in_buffer != 0, then
;              goto .in_buffer_not_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    cmp    eax, 0
    jne    .in_buffer_not_empty


.in_buffer_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   in_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    add    eax, 4
    mov    [esp + 16], eax          ;in_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   in_buffer = in_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    mov    ebx, [eax]
    mov    [esp + 20], ebx          ;in_buffer = ebx


.in_buffer_not_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if out_buffer is full
;
;   015:   if out_bitpos == -4, then
;              goto .out_buffer_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32] ;eax = out_bitpos
    cmp    eax, -4
    jne    .out_buffer_not_full


.out_buffer_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   out_ptr^ = out_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = out_buffer
    mov    ebx, [esp + 24]          ;ebx = out_ptr
    mov    [ebx], eax               ;ebx^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   out_ptr -= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = out_ptr
    sub    eax, 4                   ;eax -= 4
    mov    [esp + 24], eax          ;out_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   out_buffer = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 28], eax          ;out_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   out_bitpos = 28;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 28
    mov    [esp + 32], eax          ;out_bitpos = eax


.out_buffer_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get a decimal number from the in_buffer
;
;   020:   decimal_number = in_buffer & 0x0000000f;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    and    eax, 0x0000000f
    mov    [esp + 36], eax          ;decimal_number = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   in_buffer >>= 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    shr    eax, 8                   ;eax >>= 8
    mov    [esp + 20], eax          ;in_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the decimal number into out_buffer
;
;   022:   out_buffer |= decimal_number << out_bitpos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = decimal_number
    mov    ecx, [esp + 32]          ;ecx = out_bitpos
    shl    eax, cl
    mov    ebx, [esp + 28]          ;ebx = out_buffer
    or     eax, ebx
    mov    [esp + 28], eax          ;out_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   out_bitpos -= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = out_bitpos
    sub    eax, 4                   ;eax -= 4
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   ++digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp+ 40]           ;eax = digits
    add    eax, 1
    mov    [esp + 40], eax          ;digits = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   --i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = i
    sub    eax, 1                   ;eax -= 1
    mov    [esp + 44], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   if i != 0, then
;              goto .loop_get_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = i
    cmp    eax, 0
    jne    .loop_get_decimal


.endloop_get_decimal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the out_buffer is saved to addr_decimal^
;
;   027:   out_ptr^ = out_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = out_buffer
    mov    ebx, [esp + 24]          ;ebx = out_ptr
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   addr_digits^ = digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = digits
    mov    ebx, [esp + 12]          ;ebx = addr_digits
    mov    [ebx], eax               ;ebx^ = eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to parameters
    mov    esp, ebp                 ;restore esp to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_string2double:

;parameter 1 = addr_instring:32bit
;parameter 2 = instrlen:32bit
;returns = double precision value (ST0)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_instring
    mov    ebx, [ebp +  4]          ;get instrlen

.setup_localvariables:
    sub    esp, 56                  ;reserve 56 bytes
    mov    [esp     ], eax          ;addr_instring
    mov    [esp +  4], ebx          ;instrlen
    mov    dword [esp +  8], 0      ;intpt_str[0]
    mov    dword [esp + 12], 0      ;intpt_str[1]
    mov    dword [esp + 16], 0      ;intpt_str[2]
    mov    dword [esp + 20], 0      ;intpt_strlen
    mov    dword [esp + 24], 0      ;intpt_int
    mov    dword [esp + 28], 0      ;decpt_str[0]
    mov    dword [esp + 32], 0      ;decpt_str[1]
    mov    dword [esp + 36], 0      ;decpt_str[2]
    mov    dword [esp + 40], 0      ;decpt_strlen
    mov    dword [esp + 44], 0      ;decpt_int
    mov    dword [esp + 48], 0      ;decs
    mov    dword [esp + 52], 0      ;heading_zeroes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Separate string into ASCII integer part and
;   ASCII decimal part.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   ESI = addr_string;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    esi, [esp]               ;esi = addr_string


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   AL = ESI;
;   003:   if AL != 0x2d, goto .positive;
;          .negative:
;   004:       is_negative = 1;
;   005:       ++ ESI;
;          .positive:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    al, [esi]
    cmp    al, 0x2d
    jne    .positive
.negative:
    mov    eax, 1
    mov    [esp + 56], eax          ;is_negative = eax
    add    esi, 1
.positive:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   EDI = @intpt_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    edi, [esp + 8]           ;edi = @intpt_str


.loop_get_intpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   LODSB;
;   008:   if AL == 0x2e, goto .endloop_get_intpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    cmp    al, 0x2e
    je     .endloop_get_intpt


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   EDI^ = AL;
;   010:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   ++ intpt_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = intpt_strlen
    add    eax, 1
    mov    [esp + 20], eax          ;intpt_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   goto .loop_get_intpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_intpt


.endloop_get_intpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   EDI = @decpt_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    edi, [esp + 28]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          .loop_count_heading_zeroes:
;   014:       LODSB;
;   015:       if AL != 0x30, goto .endloop_count_heading_zeroes;
;   016:       ++ heading_zeroes;
;   017:       goto .loop_count_heading_zeroes;
;          .endloop_count_heading_zeroes:
;   018:   -- ESI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ecx, [esp + 52]          ;ecx = heading_zeroes
.loop_count_heading_zeroes:
    lodsb
    cmp    al, 0x30
    jne    .endloop_count_heading_zeroes
    add    ecx, 1
    jmp    .loop_count_heading_zeroes
.endloop_count_heading_zeroes:
    mov    [esp + 52], ecx          ;heading_zeroes = ecx
    sub    esi, 1


.loop_get_decpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   LODSB;
;   020:   if AL == 0x00, goto .endloop_get_decpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    cmp    al, 0x00
    je     .endloop_get_decpt


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   EDI^ = AL;
;   022:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   ++ decpt_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = decpt_strlen
    add    eax, 1
    mov    [esp + 40], eax          ;decpt_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   goto .loop_get_decpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_decpt


.endloop_get_decpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert intpt_str into intpt_int, and
;   decpt_str into decpt_int.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   intpt_int = cvt_string2int( @intpt_str, intpt_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [esp + (8 +  8)]    ;get @intpt_str
    mov    ebx, [esp + (8 + 20)]    ;get intpt_strlen
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 24], eax          ;intpt_int = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   decpt_int = cvt_string2int( @decpt_str, decpt_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [esp + (8 + 28)]    ;get @decpt_str
    mov    ebx, [esp + (8 + 40)]    ;get decpt_strlen
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 44], eax          ;decpt_int = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:   decs = pow_int( 10,
;                 heading_zeroes + find_int_digits(decpt_int,0) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + (8 + 44)]    ;get decpt_int
    xor    ebx, ebx                 ;flag = 0 (unsigned)
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   find_int_digits
    add    esp, 8                   ;restore 8 bytes
                                    ;eax = find_int_digits()

    mov    ebx, [esp + 52]          ;ebx = heading_zeroes
    add    eax, ebx
    mov    [esp + 48], eax          ;decs = eax

    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;get base = 10
    mov    ebx, [esp + (8 + 48)]    ;get power = decs
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 48], eax          ;decs = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   push decs to FPU;
;   029:   push decpt_int to FPU;
;   030:   FDIV ST1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 48]         ;push decs to fpu
    fild   dword [esp + 44]         ;push decpt_int to fpu
    fdiv   st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Merge intpt_int and decpt_int into
;   IEEE double precision format.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:   push intpt_int;
;   032:   FADD ST1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 24]         ;push intpt_int to fpu
    fadd   st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   033:   if is_negative == 0, goto .is_positive;
;          .is_negative:
;   034:       FCHS
;          .is_positive:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = is_negative
    cmp    eax, 0
    je     .is_positive
.is_negative:
    fchs                            ;fpu change sign
.is_positive:


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


cvt_string2int:

;parameter 1 = addr_instring:32bit
;parameter 2 = instrlen:32bit
;returns = the integer value

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_instring
    mov    ebx, [ebp +  4]          ;get instrlen

.setup_localvariables:
    sub    esp, 28                  ;reserve 28 bytes
    mov    [esp     ], eax          ;addr_instring
    mov    [esp +  4], ebx          ;instrlen
    mov    dword [esp +  8], 0      ;decimal_num[0]
    mov    dword [esp + 12], 0      ;decimal_num[1]
    mov    dword [esp + 16], 0      ;decimal_digits
    mov    dword [esp + 20], 0      ;hexadecimal_num[0]
    mov    dword [esp + 24], 0      ;hexadecimal_num[1]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   cvt_string2dec( addr_instring,
;                          instrlen,
;                          @decimal_num,
;                          @decimal_digits );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp +  16      ]   ;get addr_instring
    mov    ebx, [esp + (16 +  4)]   ;get instrlen
    lea    ecx, [esp + (16 +  8)]   ;get @decimal_num
    lea    edx, [esp + (16 + 16)]   ;get @decimal_digits
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   hexadecimal_num[0] = cvt_dec2hex( decimal_num[0] );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + (4 +  8)]    ;get decimal_num[0]
    mov    [esp    ], eax           ;parameter 1
    call   cvt_dec2hex
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 20], eax          ;hexadecimal_num[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   if decimal_digits <= 8, then goto .digits_le_8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = decimal_digits
    cmp    eax, 8
    jbe    .digits_le_8


.digits_gt_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   hexadecimal_num[1] = cvt_dec2hex( decimal_num[1] );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + (4 + 12)]    ;get decimal_num[1]
    mov    [esp    ], eax           ;parameter 1
    call   cvt_dec2hex
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 24], eax          ;hexadecimal_num[1] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   hexadecimal_num[0] = (hexadecimal_num[1] *
;                               pow_int(10, decimal_digits-2)) + 
;                               hexadecimal_num[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;parameter1 = 10
    mov    ebx, [esp + (8 + 16)]    ;get (decimal_digits - 2)
    sub    ebx, 2
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
                                    ;NOTE: eax = result pow_int()

    mov    ebx, [esp + 24]          ;ebx = hexadecimal_num[1]
    xor    edx, edx
    mul    ebx                      ;eax *= ebx

    mov    ebx, [esp + 20]          ;ebx = hexadecimal_num[0]
    add    eax, ebx                 ;eax += ebx

    mov    [esp + 20], eax          ;hexadecimal_num[0] = eax


.digits_le_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   EAX = hexadecimal_num[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = hexadecimal_num[0]


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


read4096b_stdin:

;parameter 1 = addr_readbuffer:32bit
;parameter 2 = addr_cur_rb_ptr:32bit
;parameter 3 = addr_cur_byte:32bit
;parameter 4 = addr_outdata:32bit
;parameter 5 = addr_outdata_len:32bit
;parameter 6 = flag:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_readbuffer
    mov    ebx, [ebp +  4]          ;get addr_cur_rb_ptr
    mov    ecx, [ebp +  8]          ;get addr_cur_byte
    mov    edx, [ebp + 12]          ;get addr_outdata
    mov    esi, [ebp + 16]          ;get addr_outdata_len
    mov    edi, [ebp + 20]          ;get flag

.setup_localvariables:
    sub    esp, 40                  ;reserve 40 bytes
    mov    [esp     ], eax          ;addr_readbuffer
    mov    [esp +  4], ebx          ;addr_cur_rb_ptr
    mov    [esp +  8], ecx          ;addr_cur_byte
    mov    [esp + 12], edx          ;addr_outdata
    mov    [esp + 16], esi          ;addr_outdata_len
    mov    [esp + 20], edi          ;flag
    mov    dword [esp + 24], 0      ;term1
    mov    dword [esp + 28], 0      ;term2
    mov    dword [esp + 32], 0      ;byte_pos
    mov    dword [esp + 36], 0      ;outdata_len


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     if flag == 1, then goto .flag_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = flag
    cmp    eax, 1
    je     .flag_1


.flag_0:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:         term1 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 24], eax          ;term1 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:         term2 = 0x20;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x20                ;eax = space character
    mov    [esp + 28], eax          ;term2 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:         goto .endflag_checks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .endflag_checks


.flag_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:         term1 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 24], eax          ;term1 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:         term2 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 28], eax          ;term2 = eax


.endflag_checks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:     byte_pos = addr_cur_byte^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  8]          ;ebx = addr_cur_byte
    mov    eax, [ebx]
    mov    [esp + 32], eax          ;byte_pos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:     EDI = addr_outdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    edi, [esp + 12]          ;edi = addr_outdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:     if addr_cur_rb_ptr^ == 0, goto .dont_init_ESI
;            .init_ESI:
;   010:         ESI = addr_cur_rb_ptr^;
;                ...
;            .dont_init_ESI:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_cur_rb_ptr
    mov    eax, [ebx]
    cmp    eax, 0
    je     .dont_init_ESI
.init_ESI:
    mov    esi, eax
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:         LODSB;
;   012:         -- esi;
;   013:         if al == 0, then goto .rb_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    sub    esi, 1
    cmp    al, 0
    je     .rb_empty
.dont_init_ESI:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:     if byte_pos == 0, then goto .rb_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 0
    je     .rb_empty


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:     if byte_pos != 4096, then goto .rb_not_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 4096
    jne    .rb_not_empty


.rb_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:         systemcall read( stdin, addr_readbuffer, 4096 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x03                ;systemcall read
    xor    ebx, ebx                 ;fd  = stdin
    mov    ecx, [esp]               ;dst = addr_readbuffer
    mov    edx, 4096                ;len = 4096
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:         addr_cur_byte^   = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 8]           ;ebx = addr_cur_byte
    xor    eax, eax                 ;eax = 0
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:         addr_cur_rb_ptr^ = addr_readbuffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp    ]           ;eax = addr_readbuffer
    mov    ebx, [esp + 4]           ;ebx = addr_cur_rb_ptr
    mov    [ebx], eax               ;ebx^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:         ESI              = addr_readbuffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    esi, [esp]               ;esi = addr_readbuffer
    cld


.rb_not_empty:

.loop_getdata:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:         LODSB;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:         ++ byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = byte_pos
    add    ebx, 1
    mov    [esp + 32], ebx          ;byte_pos = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:         if AL == term1, then goto .endloop_getdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 24]          ;ebx = term1
    cmp    al, bl
    je     .endloop_getdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:         if AL == term2, then goto .endloop_getdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = term2
    cmp    al, bl
    je     .endloop_getdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:         EDI^ = AL; 
;   025:         ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:         ++ outdata_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = outdata_len
    add    eax, 1
    mov    [esp + 36], eax          ;outdata_len = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:         if byte_pos == 4096, then goto .rb_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 4096
    je     .rb_empty


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:         goto .loop_getdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_getdata

.endloop_getdata:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   029:     addr_cur_rb_ptr^  = ESI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 4]           ;ebx = addr_cur_rb_ptr
    mov    [ebx], esi               ;ebx^ = esi


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:     addr_cur_byte^    = byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    mov    ebx, [esp +  8]          ;ebx = addr_cur_byte
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:     addr_outdata_len^ = outdata_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36] ;eax = outdata_len
    mov    ebx, [esp + 16] ;ebx = addr_outdata_len
    mov    [ebx], eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


find_int_digits:

;parameter 1 = integer_x:32bit
;parameter 2 = flag:32bit
;returns = the number of digits from integer_x (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes of stack
    mov    [esp], ebp               ;save ebp to stack memory
    mov    ebp, esp                 ;save current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offsets ebp, to get arguments
    mov    eax, [ebp    ]           ;get integer_x
    mov    ebx, [ebp + 4]           ;get flag

.set_localvariables:
    sub    esp, 16                  ;reserve 16 bytes
    mov    [esp     ], eax          ;integer_x
    mov    [esp +  4], ebx          ;flag
    mov    dword [esp +  8], 0      ;num_of_digits


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Is integer_x positive or negative?
;
;   If flag = 1, that means the integer_x is signed int.
;   So, we have to check its sign value to determine whether
;   it is a positive or negative number.
;
;   If the integer_x is negative number, we have to find the
;   value from its two's complement form.
;
;   If the integer_x is positive number, no need to find the
;   value from its two's complement form.
;
;   Otherwise if the flag = 0, skip these instructions.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check whether integer_x is signed or unsigned int.
;
;   001:   if flag != 1, then
;              goto .integer_x_is_unsigned;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = flag
    cmp    eax, 1
    jne    .integer_x_is_unsigned


.integer_x_is_signed:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is signed, check its sign value
;
;   002:   if (integer_x & 0x80000000) == 0, then
;              goto .integer_x_is_positive;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    and    eax, 0x80000000
    cmp    eax, 0
    je     .integer_x_is_positive


.integer_x_is_negative:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Looks like integer_x is negative, so invert all bits.
;
;   003:   integer_x = !integer_x;
;   004:   integer_x += 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    not    eax
    mov    [esp], eax               ;integer_x = !integer_x
    mov    eax, [esp]               ;eax = integer_x
    add    eax, 1
    mov    [esp], eax               ;integer_x = integer_x + 1


.integer_x_is_positive:
.integer_x_is_unsigned:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the number of digits of integer_x.
;
;   Note: the conditional jump cannot jump more than 128 bytes.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    mov    eax, [esp]             ;eax = integer_x


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   if integer_x < 10, then
;              goto .jumper_10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10
    jb     .jumper_10


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   if integer_x < 100, then
;              goto .jumper_100;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100
    jb     .jumper_100


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   if integer_x < 1000, then
;              goto .jumper_1000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000
    jb     .jumper_1000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   if integer_x < 10000, then
;              goto .jumper_10000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10000
    jb     .jumper_10000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   if integer_x < 100000, then
;              goto .jumper_100000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100000
    jb     .jumper_100000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   if integer_x < 1000000, then
;              goto .jumper_1000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000000
    jb     .jumper_1000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   if integer_x < 10000000, then
;              goto .jumper_10000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10000000
    jb     .jumper_10000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   if integer_x < 100000000, then
;              goto .jumper_100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100000000
    jb     .jumper_100000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   if integer_x < 1000000000, then
;              goto .jumper_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000000000
    jb     .jumper_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   if integer_x >= 1000000000, then
;              goto .more_equal_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .more_equal_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Jumpers, because cond. jumps can only jump up to 128 bytes.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.jumper_10:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   goto .less_than_10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10


.jumper_100:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   goto .less_than_100;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100


.jumper_1000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   goto .less_than_1000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000


.jumper_10000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   goto .less_than_10000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10000


.jumper_100000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   goto .less_than_100000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100000


.jumper_1000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   goto .less_than_1000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000000


.jumper_10000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   goto .less_than_10000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10000000


.jumper_100000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:   goto .less_than_100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100000000


.jumper_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   goto .less_than_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Assigns num_of_digits to a value based from jumpers
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.less_than_10:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   num_of_digits = 1;
;   025:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 1       ;num_of_digits = 1
    jmp    .endcondition


.less_than_100:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   num_of_digits = 2;
;   027:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 2       ;num_of_digits = 2
    jmp    .endcondition


.less_than_1000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   num_of_digits = 3;
;   029:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 3       ;num_of_digits = 3
    jmp    .endcondition


.less_than_10000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:   num_of_digits = 4;
;   031:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 4       ;num_of_digits = 4
    jmp    .endcondition


.less_than_100000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   032:   num_of_digits = 5
;   033:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 5       ;num_of_digits = 5
    jmp    .endcondition


.less_than_1000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   034:   num_of_digits = 6;
;   035:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 6       ;num_of_digits = 6
    jmp    .endcondition


.less_than_10000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   036:   num_of_digits = 7;
;   037:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 7       ;num_of_digits = 7
    jmp    .endcondition


.less_than_100000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   038:   num_of_digits = 8;
;   039:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 8       ;num_of_digits = 8
    jmp    .endcondition


.less_than_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   040:   num_of_digits = 9;
;   041:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 9       ;num_of_digits = 9
    jmp    .endcondition


.more_equal_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   042:   num_of_digits = 10;
;   043:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 10      ;num_of_digits = 10


.endcondition:


.return:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   044:   return EAX = num_of_digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = num_of_digits


.clean_stackframe:
    sub    ebp, 8                   ;-8 bytes offsets to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes of stack

    ret


;#####################################################################


pow_int:

;parameter 1: x:32bit
;parameter 2: y:32bit
;returns = result (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp    ]           ;get x the base value
    mov    ebx, [ebp + 4]           ;get y the power value

.set_local_variables:
    sub    esp, 16                  ;reserve 16 bytes
    mov    [esp     ], eax          ;x
    mov    [esp +  4], ebx          ;y
    mov    [esp +  8], ebx          ;i = y
    mov    dword [esp + 12], 1      ;result = 1


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   result = result * x;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = result
    mov    ebx, [esp     ]          ;ebx = x
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 12], eax          ;result = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   --i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = i
    sub    eax, 1
    mov    [esp + 8], eax           ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   if i != 0, then
;              goto .loop_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = i
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


.return:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   return result;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = result


.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to arguments
    mov    esp, ebp                 ;restore stack ptr to initial val
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################


string_append:

;parameter 1 = addr_dst_str:32bit
;parameter 2 = addr_dst_strlen:32bit
;parameter 3 = addr_src_str:32bit
;parameter 4 = src_strlen:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack pointer to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get arg1: addr_dst_str
    mov    ebx, [ebp +  4]          ;get arg2: addr_dst_strlen
    mov    ecx, [ebp +  8]          ;get arg3: addr_src_str
    mov    edx, [ebp + 12]          ;get arg4: src_strlen

.set_local_variables:
    sub    esp, 56                  ;reserve 56 bytes
    mov    [esp     ], eax          ;addr_dst_str
    mov    [esp +  4], ebx          ;addr_dst_strlen
    mov    [esp +  8], ecx          ;addr_src_str
    mov    [esp + 12], edx          ;src_strlen
    mov    dword [esp + 16], 0      ;dst_strlen
    mov    dword [esp + 20], 0      ;current_dst_block
    mov    dword [esp + 24], 0      ;block_byte_offset
    mov    dword [esp + 28], 0      ;dst_ptr
    mov    dword [esp + 32], 0      ;src_ptr
    mov    dword [esp + 36], 0      ;src_buffer
    mov    dword [esp + 40], 0      ;dst_buffer
    mov    dword [esp + 44], 0      ;dst_buffer_bitpos
    mov    dword [esp + 48], 0      ;i
    mov    dword [esp + 52], 0      ;ascii_char


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize source pointer and fetch data from source
;   string memory block 0.
;
;   We have to initialize the source pointer, so that later we
;   can retrieve data in the memory block of the source string.
;   Lets say the source string is "! I am good", the source
;   pointer will point to the first character which is '!'.
;   See the diagram below:
;
;      src_ptr points here
;         V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | ! |   | I |   | a | m |   | g | o | o | d |0x0|
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;
;          Diagram 1: Memory view of the source string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point src_ptr to address source string.
;
;   001:   src_ptr = addr_src_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_src_str
    mov    [esp + 32], eax          ;src_ptr = addr_src_str


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch 32 bits of data from source string memory block 0
;
;   002:   src_buffer = src_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = src_ptr
    mov    eax, [ebx]               ;eax = src_ptr^
    mov    [esp + 36], eax          ;src_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the value of destination string length.
;
;   We need to know the current string length of the destination
;   string, because later we have to find the memory address of the
;   end string of the destination string.
;
;   003:   dst_strlen = addr_dst_strlen^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_dst_strlen
    mov    eax, [ebx]               ;eax = addr_dst_strlen^
    mov    [esp + 16], eax          ;dst_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find current destination string block and its offset.
;
;   Because we need to know at which memory block the end
;   string is. For example, given dst_str is "HELLO WORLD",
;   in memory it looks like this:
;
;                                block_byte_offset = 8
;                                         V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | H | E | L | L | O |   | W | O | R | L | D |   |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;                                               ^
;                                       current_dst_block
;           Diagram 2: destination string in memory
;
;   From the diagram above, the current_dst_block will
;   be 2, and the dst_ptr will point to address
;   mem block 2.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find current destination string memory block number.
;
;   004:   current_dst_block = dst_strlen / 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    ebx, 4                   ;ebx = 4, to divide the eax
    xor    edx, edx                 ;prevent errors when division.
    div    ebx                      ;eax = eax / ebx
    mov    [esp + 20], eax          ;current_dst_block = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the byte offset of the current destination string
;   memory block.
;
;   005:   block_byte_offset = current_dst_block * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = current_dst_block
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 24], eax          ;block_byte_offset = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find address of current destination string memory block,
;   so that later we can fetch data from the destination
;   string memory and store into a buffer.
;
;   For example, given current_dst_block = 2,
;   first we have to find the memory offset of the memory block 2,
;   (however, we already calculate the offset from previous
;   instructions):
;
;       offset = current dst block * 4 bytes;
;
;   After we have the memory offset, get the memory address
;   of destination string block 0, and add with offset:
;
;       address dst block 2 = address dst block 0 + offset;
;
;   Then we have the address of the dst block 2.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find address of current destination string memory block.
;
;   006:   dst_ptr = addr_dst_str + block_byte_offset;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_dst_str
    mov    ebx, [esp + 24]          ;ebx = block_byte_offset
    add    eax, ebx
    mov    [esp + 28], eax          ;dst_ptr = eax

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch data from destination string and store to buffer.
;
;   007:   dst_buffer = dst_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    eax, [ebx]               ;eax = dst_ptr^
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find bit position of last character from the destination string
;
;   In order to append the string, we have to know the bit
;   position of the (last character + 1) in memory block of
;   destination string. Lets say the current memory block in
;   the destination string is at memory block 2,
;
;                                            dst_buffer_bitpos = 24
;                                                     V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | H | E | L | L | O |   | W | O | R | L | D |0x0|
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | 0 | 8 |16 |24 | 0 | 8 |16 |24 | 0 | 8 |16 |24 |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;                                               ^
;                                       current_dst_block
;            Diagram 3: destination string in memory
;
;   From the above diagram, the value of dst_buffer_bitpos will
;   be 24. Because, the end character of the string, which is 'D',
;   is located at bit 16 in memory block 2. So, the new
;   string will be append at byte position 24. The calculations
;   will look like this:
;
;   dst_buffer_bitpos = (dst_strlen - block_byte_offset) * 8 bits
;   dst_buffer_bitpos = (11 - 8) * 8
;   dst_buffer_bitpos = 3 * 8
;   dst_buffer_bitpos = 24
;
;   This bit position will be the bit position of the dst buffer.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   dst_buffer_bitpos = (dst_strlen-block_byte_offset)*8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    ebx, [esp + 24]          ;ebx = block_byte_offset
    sub    eax, ebx
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 44], eax          ;dst_buffer_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initializes counter for .loop_1
;
;   Set the counter initial value to the value of source
;   string length. This counter will be decremented until zero.
;   This counter prevents overflow and underflow when appending
;   the source string to the destination string.
;
;   When counter equals zero means that we have completely
;   append all characters from source string.
;
;   009:   i = src_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = src_strlen
    mov    [esp + 48], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP 1: Append the source string to the destination string
;
;   .loop_1 will loop until i = 0. Means that it will loop
;   until all source string has been appended to the destination
;   string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if dst_buffer is full
;
;   True  = The destination string buffer is not yet full.
;           Continue filling the buffer with the string until
;           the destination string buffer is full.
;
;   False = The destination string buffer is full. Save the buffer
;           to the destination string, and then point the
;           destination pointer to the next memory location.
;           Also, reset the buffer and bit position of the
;           destination buffer to zero.
;
;   010:   if dst_buffer_bitpos != 32, then
;              goto .endcond_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = dst_buffer_bitpos
    cmp    eax, 32
    jne    .endcond_1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .COND_1: If the destination string buffer is full
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.cond_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the buffer to the destination string.
;
;   011:   dst_ptr^ = dst_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    [ebx], eax               ;dst_ptr^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point the destination pointer to the next memory location.
;
;   012:   dst_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = dst_ptr
    add    eax, 4                   ;eax = eax + 4
    mov    [esp + 28], eax          ;dst_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Reset the destination string buffer to zero.
;
;   013:   dst_buffer = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax                 ;eax = 0
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;    Reset the destination string buffer bit position to zero.
;
;    014:   dst_buffer_bitpos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax                 ;eax = 0
    mov    [esp + 44], eax          ;dst_buffer_bitpos = eax


.endcond_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if src_buffer is empty
;
;   True  = The source string buffer is not empty. Continue
;           appending the source string into the destination
;           string until the source string buffer is dry/empty.
;
;   False = The source string buffer is empty. Fetch the data
;           from next memory location of the source string, and
;           fill the source string buffer with the new data.
;
;   015:   if src_buffer != 0, then
;              goto .endcond_2;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = src_buffer
    cmp    eax, 0
    jne    .endcond_2


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .COND_2: If the source string buffer is empty
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.cond_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point the source pointer to the next memory location.
;
;   016:   src_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = src_ptr
    add    eax, 4                   ;eax = eax + 4
    mov    [esp + 32], eax          ;src_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch the data from the next memory location.
;
;   017:   src_buffer = src_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = src_ptr
    mov    eax, [ebx]               ;eax = src_ptr^
    mov    [esp + 36], eax          ;src_buffer = eax


.endcond_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append a source character to destination string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get source string character.
;
;   018:   ascii_char = (src_buffer&0xff) << dst_buffer_bitpos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ecx, [esp + 44]          ;ecx = dst_buffer_bitpos
    mov    eax, [esp + 36]          ;eax = src_buffer
    and    eax, 0xff
    shl    eax, cl
    mov    [esp + 52], eax          ;ascii_char = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append the source string character to the destination
;   character.
;
;   019:   dst_buffer |= ascii_char;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    ebx, [esp + 52]          ;ebx = ascii_char
    or     eax, ebx
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Increment bit position of the destination string.
;
;   020:   dst_buffer_bitpos += 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = dst_buffer_bitpos
    add    eax, 8
    mov    [esp + 44], eax          ;dst_buffer_bitpos := eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Increase the length of destination string length by 1 byte.
;
;   021:   ++ dst_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;dst_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Remove the source character that has been read.
;
;   022:   src_buffer >>= 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = src_buffer
    shr    eax, 8
    mov    [esp + 36], eax          ;src_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Decrement length of source string by 1 byte.
;
;   023:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = i
    sub    eax, 1
    mov    [esp + 48], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check loop_1 condition, loop if true
;
;   024:   if i != 0, then
;              goto .loop_1;           
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = i
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save destination string and strlen to the argument out.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the destination string buffer to the destination
;   string memory block.
;
;   025:   dst_ptr^ = dst_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    [ebx], eax               ;dst_ptr^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the destination string length.
;
;   026: addr_dst_strlen^ = dst_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_dst_strlen
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    [ebx], eax               ;addr_dst_strlen^ = eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to arguments
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret


;#####################################################################