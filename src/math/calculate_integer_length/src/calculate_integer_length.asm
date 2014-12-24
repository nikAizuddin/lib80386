;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: calculate_integer_length                          |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 11/OCT/2014                                       |
;|  PROGRAM PURPOSE: <See reference manual>                            |
;+---------------------------------------------------------------------+
;|         LANGUAGE: x86 Assembly Language                             |
;|           SYNTAX: Intel                                             |
;|        ASSEMBLER: NASM                                              |
;|     ARCHITECTURE: i386, i586, i686, x86_64                          |
;|           KERNEL: Linux 32-bit                                      |
;|           FORMAT: elf32                                             |
;|    INCLUDE FILES: None                                              |
;+---------------------------------------------------------------------+
;|          VERSION: 0.1.0                                             |
;|           STATUS: Alpha                                             |
;+---------------------------------------------------------------------+
;| REVISION HISTORY:                                                   |
;|                                                                     |
;|     Rev #  |    Date     | Description                              |
;|   ---------+-------------+---------------------------------------   |
;|     0.1.0  | 12/OCT/2014 | First release.                           |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- section instruction codes ---------------------------------------
section .text

global calculate_integer_length
calculate_integer_length:

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes of stack
    mov    [esp], ebp ;save ebp to stack memory
    mov    ebp, esp   ;save current stack ptr to ebp

.get_arguments:
    add    ebp, 8         ;+8 bytes offsets to ebp, to get arguments
    mov    eax, [ebp    ] ;get integer_x
    mov    ebx, [ebp + 4] ;get flag

.set_localvariables:
    sub    esp, 16             ;reserve 16 bytes of stack
    mov    [esp     ], eax     ;integer_x
    mov    [esp +  4], ebx     ;flag
    mov    dword [esp +  8], 0 ;num_of_digits

.check_signvalue:

;+---------------------------------------------------------------------+
;|       { If flag = 1, that means the integer_x is long signed int.   |
;|         So, we have to check its sign value to determine whether    |
;|         it is a positive or negative number.                        |
;|                                                                     |
;|         If the integer_x is negative number, we have to find the    |
;|         value from its two's complement form.                       |
;|                                                                     |
;|         If the integer_x is positive number, no need to find the    |
;|         value from its two's complement form.                       |
;|                                                                     |
;|         Otherwise if the flag = 0, skip these instructions. }       |
;|                                                                     |
;|       { Check whether integer_x is signed or unsigned int }         |
;|       IF flag = 1 THEN                                              |
;|           { If integer_x is signed, check its sign value }          |
;|           IF (integer_x and 0x80000000) <> 0 THEN                   |
;|               { If integer_x is negative }                          |
;|               { Invert all bits }                                   |
;|               integer_x := not integer_x;                           |
;|               { Add 1 }                                             |
;|               integer_x := integer_x + 1;                           |
;+---------------------------------------------------------------------+

; if flag = 1 then continue to .integer_x_is_signed
;-----------------------------------------------------------------------
    mov    eax, [esp + 4]         ;eax := flag
    cmp    eax, 1                 ;compare eax with 1
    jne    .integer_x_is_unsigned ;if <>, goto .integer_x_is_unsigned
                                  ;otherwise, continue below

.integer_x_is_signed:

; if integer_x & 0x80000000 <> 0 then continue to .integer_x_is_negative
;-----------------------------------------------------------------------
    mov    eax, [esp]             ;eax := integer_x
    and    eax, 0x80000000        ;eax := eax and 0x80000000
    cmp    eax, 0                 ;compare eax with 1
    je     .integer_x_is_positive ;if =, goto .integer_x_is_positive
                                  ;otherwise, continue below

.integer_x_is_negative:

; integer_x := not integer_x
;-----------------------------------------------------------------------
    mov    eax, [esp] ;eax := integer_x
    not    eax        ;eax := not eax
    mov    [esp], eax ;integer_x := eax

; integer_x := integer_x + 1
;-----------------------------------------------------------------------
    mov    eax, [esp] ;eax := integer_x
    add    eax, 1     ;eax := eax + 1
    mov    [esp], eax ;integer_x := eax

.integer_x_is_positive:
.integer_x_is_unsigned:

.find_number_of_digits:

;+---------------------------------------------------------------------+
;|       { The instructions below will find the number of digits       |
;|         from integer_x. }                                           |
;|                                                                     |
;|       IF integer_x < 10 THEN                                        |
;|           num_of_digits := 1;                                       |
;|       ELSE IF integer_x < 100 THEN                                  |
;|           num_of_digits := 2;                                       |
;|       ELSE IF integer_x < 1000 THEN                                 |
;|           num_of_digits := 3;                                       |
;|       ELSE IF integer_x < 10000 THEN                                |
;|           num_of_digits := 4;                                       |
;|       ELSE IF integer_x < 100000 THEN                               |
;|           num_of_digits := 5;                                       |
;|       ELSE IF integer_x < 1000000 THEN                              |
;|           num_of_digits := 6;                                       |
;|       ELSE IF integer_x < 10000000 THEN                             |
;|           num_of_digits := 7;                                       |
;|       ELSE IF integer_x < 100000000 THEN                            |
;|           num_of_digits := 8;                                       |
;|       ELSE IF integer_x < 1000000000 THEN                           |
;|           num_of_digits := 9;                                       |
;|       ELSE                                                          |
;|           num_of_digits := 10;                                      |
;+---------------------------------------------------------------------+

; compares
;-----------------------------------------------------------------------
    mov    eax, [esp]             ;eax := integer_x
    cmp    eax, 10                ;compare eax with 10
    jb     .jumper_10             ;if <, goto .less_than_10
    cmp    eax, 100               ;compare eax with 100
    jb     .jumper_100            ;if <, goto .less_than_100
    cmp    eax, 1000              ;compare eax with 1000
    jb     .jumper_1000           ;if <, goto .less_than_1000
    cmp    eax, 10000             ;compare eax with 10000
    jb     .jumper_10000          ;if <, goto .less_than_10000
    cmp    eax, 100000            ;compare eax with 100000
    jb     .jumper_100000         ;if <, goto .less_than_100000
    cmp    eax, 1000000           ;compare eax with 1000000
    jb     .jumper_1000000        ;if <, goto .less_than_1000000
    cmp    eax, 10000000          ;compare eax with 10000000
    jb     .jumper_10000000       ;if <, goto .less_than_10000000
    cmp    eax, 100000000         ;compare eax with 100000000
    jb     .jumper_100000000      ;if <, goto .less_than_100000000
    cmp    eax, 1000000000        ;compare eax with 1000000000
    jb     .jumper_1000000000     ;if <, goto .less_than_1000000000
    jmp    .less_than_10000000000 ;else, goto .less_than_10000000000

; conditional jump cannot jump more than 128 bytes.
;-----------------------------------------------------------------------
.jumper_10:
    jmp    .less_than_10
.jumper_100:
    jmp    .less_than_100
.jumper_1000:
    jmp    .less_than_1000
.jumper_10000:
    jmp    .less_than_10000
.jumper_100000:
    jmp    .less_than_100000
.jumper_1000000:
    jmp    .less_than_1000000
.jumper_10000000:
    jmp    .less_than_10000000
.jumper_100000000:
    jmp    .less_than_100000000
.jumper_1000000000:
    jmp    .less_than_1000000000

.less_than_10:
; num_of_digits := 1
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 1  ;num_of_digits := 1
    jmp    .endcondition       ;goto .endcondition

.less_than_100:
;     num_of_digits := 2
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 2  ;num_of_digits := 2
    jmp    .endcondition       ;goto .endcondition

.less_than_1000:
;     num_of_digits := 3
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 3  ;num_of_digits := 3
    jmp    .endcondition       ;goto .endcondition

.less_than_10000:
;     num_of_digits := 4
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 4  ;num_of_digits := 4
    jmp    .endcondition       ;goto .endcondition

.less_than_100000:
;     num_of_digits := 5
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 5  ;num_of_digits := 5
    jmp    .endcondition       ;goto .endcondition

.less_than_1000000:
;     num_of_digits := 6
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 6  ;num_of_digits := 6
    jmp    .endcondition       ;goto .endcondition

.less_than_10000000:
;     num_of_digits := 7
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 7  ;num_of_digits := 7
    jmp    .endcondition       ;goto .endcondition

.less_than_100000000:
;     num_of_digits := 8
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 8  ;num_of_digits := 8
    jmp    .endcondition       ;goto .endcondition

.less_than_1000000000:
;     num_of_digits := 9
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 9  ;num_of_digits := 9
    jmp    .endcondition       ;goto .endcondition

.less_than_10000000000:
;     num_of_digits := 10
;-----------------------------------------------------------------------
    mov    dword [esp + 8], 10  ;num_of_digits := 10

.endcondition:

.return:
    mov    eax, [esp + 8] ;eax := num_of_digits

.clean_stackframe:
    sub    ebp, 8     ;-8 bytes offsets to ebp
    mov    esp, ebp   ;restore stack ptr to its initial value
    mov    ebp, [esp] ;restore ebp to its initial value
    add    esp, 4     ;restore 4 bytes of stack

    ret

