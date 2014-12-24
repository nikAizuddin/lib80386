;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|               Example using print_double2string()                   |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

;---- section uninitialized data ---------------------------------------
section .bss

ascii_string_b0:     resd 1
ascii_string_b1:     resd 1
ascii_string_b2:     resd 1
ascii_string_b3:     resd 1
ascii_string_b4:     resd 1
ascii_string_b5:     resd 1
ascii_string_len:    resd 1

;---- section read only data -------------------------------------------
section .rdata noexec nowrite

double_x:       dq -2147483647.12345678 ;MAX=2147483647.12345678
decimal_places: dd 10000000             ;MAX=100000000


;---- section instruction code -----------------------------------------
section .text exec nowrite

extern print_double2string

global _start
_start:

; call print_double2stdout
    sub    esp, 20               ;reserve 20 bytes
    mov    eax, [double_x]       ;get double_x (part 1/2)
    mov    ebx, [double_x+4]     ;get double_x (part 2/2)
    mov    ecx, [decimal_places] ;get decimal_places
    mov    edx, ascii_string_b0  ;get @ascii_string_b0
    mov    [esp     ], eax       ;arg1: double_x (part 1/2)
    mov    [esp +  4], ebx       ;arg1: double_x (part 2/2)
    mov    [esp +  8], ecx       ;arg2: decimal_places
    mov    [esp + 12], edx       ;arg3: @ascii_string_b0
    mov    eax, ascii_string_len ;get @ascii_string_len
    mov    [esp + 16], eax       ;arg4: @ascii_string_len
    call   print_double2string
    add    esp, 20               ;restore 20 bytes

;print
    mov    eax, 0x04               ;systemcall write
    mov    ebx, 0x01               ;write to stdout
    mov    ecx, ascii_string_b0    ;src to print
    mov    edx, [ascii_string_len] ;strlen
    int    0x80

.exit:
    mov    eax, 0x01 ;systemcall exit
    xor    ebx, ebx  ;return 0
    int    0x80

