;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|      Example on how to use function calculate_integer_length()      |
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

int_x:
    istruc integer
        at integer.value,  dd 0xffffffd6 ;-42
        at integer.length, dd 0
        at integer.flag,   dd 1          ;signed integer
    iend

uint_x:
    istruc integer
        at integer.value,  dd 0xffffffd6 ;+4294967254
        at integer.length, dd 0
        at integer.flag,   dd 0          ;unsigned integer
    iend

; ---- section instruction code ----------------------------------------
section .text

extern calculate_integer_length

global _start
_start:

;+---------------------------------------------------------------------+
;| Find the length (number of digits) of a signed integer              |
;| by calling function calculate_integer_length():                     |
;|                                                                     |
;| int_x.length := calculate_integer_length(int_x.value,               |
;|                                          int_x.flag);               |
;+---------------------------------------------------------------------+
    sub    esp, 8                      ;reserve 8 bytes
    mov    eax, [int_x+integer.value]  ;get int_x.value
    mov    ebx, [int_x+integer.flag]   ;get flag
    mov    [esp    ], eax              ;arg1: int_x.value
    mov    [esp + 4], ebx              ;arg2: int_x.flag
    call   calculate_integer_length
    add    esp, 8                      ;restore 8 bytes
    mov    [int_x+integer.length], eax

;+---------------------------------------------------------------------+
;| Find the length (number of digits) of an unsigned integer           |
;| by calling function calculate_integer_length():                     |
;|                                                                     |
;| uint_x.length := calculate_integer_length(uint_x.value,             |
;|                                           uint_x.flag);             |
;+---------------------------------------------------------------------+
    sub    esp, 8                       ;reserve 8 bytes
    mov    eax, [uint_x+integer.value]  ;get uint_x.value
    mov    ebx, [uint_x+integer.flag]   ;get flag
    mov    [esp    ], eax               ;arg1: uint_x.value
    mov    [esp + 4], ebx               ;arg2: uint_x.flag
    call   calculate_integer_length
    add    esp, 8                       ;restore 8 bytes
    mov    [uint_x+integer.length], eax

.exit:
    mov    eax, 0x01 ;systemcall exit
    mov    ebx, 0x00 ;return 0
    int    0x80

