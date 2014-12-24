;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|                 Example to use print_int2string()                   |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

;---- section uninitialized data ---------------------------------------
section .bss noexec write

ascii_string_b0:    resd 1
ascii_string_b1:    resd 1
ascii_string_b2:    resd 1
ascii_string_b3:    resd 1
ascii_string_len:   resd 1

;---- section read only data -------------------------------------------
section .rdata noexec nowrite

integer_x:    dd 2147483646

;---- section instruction code -----------------------------------------
section .text exec nowrite

extern print_int2string

global _start
_start:

; call print_int2string
    sub    esp, 16               ;reserve 16 bytes
    mov    eax, [integer_x]      ;get integer_x
    mov    ebx, ascii_string_b0  ;get addr_ascii_str
    mov    ecx, ascii_string_len ;get addr_ascii_len
    mov    edx, 1                ;get flag
    mov    [esp     ], eax       ;arg1: integer_x
    mov    [esp +  4], ebx       ;arg2: addr_ascii_str
    mov    [esp +  8], ecx       ;arg3: addr_ascii_len
    mov    [esp + 12], edx       ;arg4: flag
    call   print_int2string
    add    esp, 16               ;restore 16 bytes

; test
    mov    eax, 0x04               ;system call write
    mov    ebx, 0x01               ;write to stdout
    mov    ecx, ascii_string_b0    ;src string
    mov    edx, [ascii_string_len] ;strlen
    int    0x80

.exit:
    mov    eax, 0x01 ;systemcall exit
    xor    ebx, ebx  ;return 0
    int    0x80

