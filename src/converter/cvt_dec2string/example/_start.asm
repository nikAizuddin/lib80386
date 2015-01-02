;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|        Example on how to use procedure write_dec2string().          |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- section read/write data -----------------------------------------
section .data

decimal_x_b0: dd 0x94967295
decimal_x_b1: dd 0x00000042
ascii_x_b0:   dd 0x00000000
ascii_x_b1:   dd 0x00000000
ascii_x_b2:   dd 0x00000000
ascii_x_len:  dd 0x00000000

; ---- section instruction codes ---------------------------------------
section .text

extern write_dec2string

global _start
_start:

; procedure write_dec2string()
    sub    esp, 16           ;reserve 16 bytes
    mov    eax, decimal_x_b0 ;get @decimal_x_b0
    mov    ebx, 2            ;get number of decimal_x blocks
    mov    ecx, ascii_x_b0   ;get @ascii_x_b0
    mov    edx, ascii_x_len  ;get @ascii_x_len
    mov    [esp     ], eax   ;arg1: @decimal_x_b0
    mov    [esp +  4], ebx   ;arg2: num_of_blocks
    mov    [esp +  8], ecx   ;arg3: @ascii_x_b0
    mov    [esp + 12], edx   ;arg4: @ascii_x_len
    call   write_dec2string
    add    esp, 16           ;restore 16 bytes

.exit:
    mov    eax, 0x01 ;systemcall exit
    mov    ebx, 0x00 ;return 0
    int    0x80

