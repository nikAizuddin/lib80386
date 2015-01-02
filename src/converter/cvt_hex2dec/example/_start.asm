;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|          Example on how to use function cvt_hex2dec()               |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- structure definitions -------------------------------------------
struc integer
    .value:  resd 1
    .length: resd 1
    .flag:   resd 1
    .size:
endstruc

; ---- section read/write data -----------------------------------------
section .data
uint_x:
    istruc integer
        at integer.value,  dd 0x00bd0c32 ;+12389426
        at integer.length, dd 0
        at integer.flag,   dd 0          ;unsigned integer
    iend
int_y:
    istruc integer
        at integer.value,  dd 0xffffffd6 ;-42
        at integer.length, dd 0
        at integer.flag,   dd 0          ;signed integer
    iend
uint_z:
    istruc integer
        at integer.value,  dd 0xffffffd6 ;+4294967254
        at integer.length, dd 0
        at integer.flag,   dd 0          ;unsigned integer
    iend
decimal_x:    dd 0x00000000
decimal_y:    dd 0x00000000
decimal_z_b0: dd 0x00000000
decimal_z_b1: dd 0x00000000
quotient:     dd 0x00000000
remainder:    dd 0x00000000

; ---- section instruction codes ---------------------------------------
section .text

extern formula_hex2dec

global _start
_start:

.example_1:
;+---------------------------------------------------------------------+
;| Example 1: Convert uint_x to decimal_x                              |
;|                                                                     |
;| Converting unsigned hexadecimal number to decimal number is very    |
;| straightforward and doesn't need extra instructions.                |
;|                                                                     |
;| decimal_num := formula_hex2dec(hexadecimal_num);                    |
;+---------------------------------------------------------------------+

; decimal_x := formula_hex2dec(uint_x.value)
;-----------------------------------------------------------------------
    sub    esp, 4                      ;reserve 4 bytes
    mov    eax, [uint_x+integer.value] ;get uint_x.value
    mov    [esp], eax                  ;arg1: uint_x.value
    call   formula_hex2dec
    add    esp, 4                      ;restore 4 bytes
    mov    [decimal_x], eax

.example_2:
;+---------------------------------------------------------------------+
;| Example 2: Convert int_y to decimal_y                               |
;|                                                                     |
;| To convert the signed hexadecimal number to decimal number, first   |
;| we have to check its sign value. If the integer is negative, we     |
;| have to reverse its two's complement form.                          |
;|                                                                     |
;| After we have successfully reverse the two's complement, now we     |
;| can perform the hex2dec conversion by using function:               |
;| formula_hex2dec().                                                  |
;|                                                                     |
;| decimal_num := formula_hex2dec(hexadecimal_num);                    |
;+---------------------------------------------------------------------+

.check_sign_value:
; if (int_y.value & 0x80000000) <> 0 then continue to .int_y_is_negative
;-----------------------------------------------------------------------
    mov    eax, [int_y+integer.value] ;eax := int_y.value
    and    eax, 0x80000000            ;eax := eax & 0x80000000
    cmp    eax, 0                     ;compare eax with 0
    je     .int_y_is_positive         ;if =, goto .int_y_is_positive
                                      ;otherwise, continue below

.int_y_is_negative:
; int_y.value := (not int_y.value) + 1
;-----------------------------------------------------------------------
    mov    eax, [int_y+integer.value] ;eax := int_y.value
    not    eax                        ;eax := not eax
    add    eax, 1                     ;eax := eax + 1
    mov    [int_y+integer.value], eax ;int_y.value := eax

.int_y_is_positive:

; decimal_y := formula_hex2dec(int_y.value)
;-----------------------------------------------------------------------
    sub    esp, 4                     ;reserve 4 bytes
    mov    eax, [int_y+integer.value] ;get int_y.value
    mov    [esp], eax                 ;arg1: int_y.value
    call   formula_hex2dec
    add    esp, 4                     ;restore 4 bytes
    mov    [decimal_y], eax

.example_3:
;+---------------------------------------------------------------------+
;| Example 3: convert large value of uint_z to decimal_z               |
;|                                                                     |
;| The limitations of formula_hex2int() is it cannot convert value     |
;| larger than or equal 100000000 (0x05f5e100). Howaver, there is a    |
;| workaround to solve this. Here the example:                         |
;|                                                                     |
;| quotient := hexadecimal_num / 100000000;                            |
;| decimal_num_block0 := formula_hex2dec(remainder);                   |
;| decimal_num_block1 := formula_hex2dec(quotient);                    |
;+---------------------------------------------------------------------+

; quotient := uint_z.value / 100000000
;-----------------------------------------------------------------------
    mov    eax, [uint_z+integer.value] ;eax := uint_z.value
    mov    ebx, 100000000              ;ebx := 100000000
    xor    edx, edx                    ;edx := 0
    div    ebx                         ;eax := eax / ebx
    mov    [quotient], eax             ;quotient := eax
    mov    [remainder], edx            ;remainder := edx

; decimal_z_b0 := formula_hex2dec(remainder);
; decimal_z_b1 := formula_hex2dec(quotient);
;-----------------------------------------------------------------------
    sub    esp, 4              ;reserve 4 bytes
    mov    eax, [remainder]    ;get remainder
    mov    [esp], eax          ;arg1: remainder
    call   formula_hex2dec
    mov    [decimal_z_b0], eax
    mov    eax, [quotient]     ;get quotient
    mov    [esp], eax          ;arg1: quotient
    call   formula_hex2dec
    mov    [decimal_z_b1], eax
    add    esp, 4              ;restore 4 bytes

.exit:
    mov    eax, 0x01 ;systemcall exit
    mov    ebx, 0x00 ;return 0
    int    0x80