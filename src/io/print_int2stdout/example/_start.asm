;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|        Example on how to use procedure print_int2stdout().          |
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
        at integer.value,  dd 00bd0c32H ;+12389426
        at integer.length, dd 0
        at integer.flag,   dd 0          ;unsigned integer
    iend
int_y:
    istruc integer
        at integer.value,  dd 0ffffffd6H ;-42
        at integer.length, dd 0
        at integer.flag,   dd 1          ;signed integer
    iend
uint_z:
    istruc integer
        at integer.value,  dd 0ffffffd6H ;+4294967254
        at integer.length, dd 0
        at integer.flag,   dd 0          ;unsigned integer
    iend

; ---- section read only data ------------------------------------------
section .rdata
newline_character:    dd 0000000aH

; ---- section instruction codes ---------------------------------------
section .text

extern print_int2stdout

global _start
_start:

; print the value of uint_x to stdout
    sub    esp, 8                      ;reserve 8 bytes
    mov    eax, [uint_x+integer.value] ;get uint_x.value
    mov    ebx, [uint_x+integer.flag]  ;get uint_x.flag
    mov    [esp    ], eax              ;arg1: uint_x.value
    mov    [esp + 4], ebx              ;arg2: uint_x.flag
    call   print_int2stdout
    add    esp, 8                      ;restore 8 bytes

; print newline
    mov    eax, 04H               ;systemcall read
    mov    ebx, 01H               ;print to stdout
    mov    ecx, newline_character ;address newline_character
    mov    edx, 1                 ;len := 1 character
    int    80H

; print the value of int_y to stdout
    sub    esp, 8                      ;reserve 8 bytes
    mov    eax, [int_y+integer.value]  ;get int_y.value
    mov    ebx, [int_y+integer.flag]   ;get int_y.flag
    mov    [esp    ], eax              ;arg1: uint_x.value
    mov    [esp + 4], ebx              ;arg2: uint_x.flag
    call   print_int2stdout
    add    esp, 8                      ;restore 8 bytes

; print newline
    mov    eax, 04H               ;systemcall read
    mov    ebx, 01H               ;print to stdout
    mov    ecx, newline_character ;address newline_character
    mov    edx, 1                 ;len := 1 character
    int    80H

; print the value of uint_z to stdout
    sub    esp, 8                      ;reserve 8 bytes
    mov    eax, [uint_z+integer.value] ;get uint_z.value
    mov    ebx, [uint_z+integer.flag]  ;get uint_z.flag
    mov    [esp    ], eax              ;arg1: uint_x.value
    mov    [esp + 4], ebx              ;arg2: uint_x.flag
    call   print_int2stdout
    add    esp, 8                     ;restore 8 bytes

; print newline
    mov    eax, 04H               ;systemcall read
    mov    ebx, 01H               ;print to stdout
    mov    ecx, newline_character ;address newline_character
    mov    edx, 1                 ;len := 1 character
    int    80H

.exit:
    mov   eax, 0x01 ;systemcall exit
    mov   ebx, 0x00 ;return 0
    int   0x80

