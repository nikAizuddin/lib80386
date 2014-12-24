;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|                     Example using pow_int()                         |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

;---- section uninitialized data ---------------------------------------
section .bss

pow_result:         resd 1
ascii_string_b0:    resd 1
ascii_string_b1:    resd 1
ascii_string_b2:    resd 1
ascii_string_b3:    resd 1
ascii_string_b4:    resd 1
ascii_string_b5:    resd 1
ascii_string_b6:    resd 1
ascii_string_b7:    resd 1
ascii_string_len:   resd 1

;---- section read only data -------------------------------------------
section .rdata

integer_x:    dd 3
power_x:      dd 13

;---- section instruction code -----------------------------------------
section .text exec nowrite

extern pow_int
extern print_int2string
extern append_string

global _start
_start:

; calculate the power using the procedure:
; pow_int(integer_x, power_x)
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [integer_x]         ;get integer_x
    mov    ebx, [power_x]           ;get power_x
    mov    [esp    ], eax           ;arg1: integer_x
    mov    [esp + 4], ebx           ;arg2: power_x
    call   pow_int
    mov    [pow_result], eax        ;save result
    add    esp, 8                   ;restore 8 bytes

;
; PRINT THE RESULT
;

; put "The value of " into the ascii string
    sub    esp, 20
    mov    dword [esp     ], "The " ;temp_string_b0
    mov    dword [esp +  4], "valu" ;temp_string_b1
    mov    dword [esp +  8], "e of" ;temp_string_b2
    mov    dword [esp + 12], " "    ;temp_string_b3
    mov    dword [esp + 16], 13     ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get address string
    mov    edx, [esp + 16 + 16]     ;get string length
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: address string
    mov    [esp + 12], edx          ;arg4: string length
    call   append_string
    add    esp, (16+20)             ;restore 16+20 bytes

; append integer_x value into the ascii string
    sub    esp, 16
    mov    dword [esp     ], 0      ;temp_string_b0
    mov    dword [esp +  4], 0      ;temp_string_b1
    mov    dword [esp +  8], 0      ;temp_string_b2
    mov    dword [esp + 12], 0      ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [integer_x]         ;get integer_x
    mov    ebx, esp
    mov    ecx, esp
    add    ebx, (16+0)              ;get @temp_string_b0
    add    ecx, (16+12)             ;get @temp_string_len
    xor    edx, edx                 ;get flag=0
    mov    [esp     ], eax          ;arg1: integer_x
    mov    [esp +  4], ebx          ;arg2: @temp_string_b0
    mov    [esp +  8], ecx          ;arg3: @temp_string_len
    mov    [esp + 12], edx          ;arg4: flag=0
    call   print_int2string
    add    esp, 16                  ;restore 16 bytes

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get @temp_string_b0
    mov    edx, [esp + 16+12]       ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16+16)             ;restore 16+16 bytes

; append "^" into the ascii string
    sub    esp, 8
    mov    dword [esp    ], "^"     ;temp_string_b0
    mov    dword [esp + 4], 1       ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get @temp_string_b0
    mov    edx, [esp + 16 + 4]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16+8)              ;restore 16+8 bytes

; append power_x value into the ascii string
    sub    esp, 16
    mov    dword [esp     ], 0      ;temp_string_b0
    mov    dword [esp +  4], 0      ;temp_string_b1
    mov    dword [esp +  8], 0      ;temp_string_b2
    mov    dword [esp + 12], 0      ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [power_x]           ;get power_x
    mov    ebx, esp
    mov    ecx, esp
    add    ebx, (16+0)              ;get @temp_string_b0
    add    ecx, (16+12)             ;get @temp_string_len
    xor    edx, edx                 ;get flag=0
    mov    [esp     ], eax          ;arg1: power_x
    mov    [esp +  4], ebx          ;arg2: @temp_string_b0
    mov    [esp +  8], ecx          ;arg3: @temp_string_len
    mov    [esp + 12], edx          ;arg4: flag=0
    call   print_int2string
    add    esp, 16                  ;restore 16 bytes

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get @temp_string_b0
    mov    edx, [esp + 16 + 12]     ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16+16)             ;restore 16+16 bytes

; append " = " into the ascii string
    sub    esp, 8
    mov    dword [esp    ], " = "   ;temp_string_b0
    mov    dword [esp + 4], 3       ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get @temp_string_b0
    mov    edx, [esp + 16 + 4]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16+8)              ;restore 16+8 bytes

; append pow_result value into the ascii string
    sub    esp, 16
    mov    dword [esp     ], 0       ;temp_string_b0
    mov    dword [esp +  4], 0       ;temp_string_b1
    mov    dword [esp +  8], 0       ;temp_string_b2
    mov    dword [esp + 12], 0       ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [pow_result]        ;get pow_result
    mov    ebx, esp
    mov    ecx, esp
    add    ebx, (16+0)              ;get @temp_string_b0
    add    ecx, (16+12)             ;get @temp_string_len
    xor    edx, edx                 ;get flag=0 (unsigned int)
    mov    [esp     ], eax          ;arg1: pow_result
    mov    [esp +  4], ebx          ;arg2: @temp_string_b0
    mov    [esp +  8], ecx          ;arg3: @temp_string_len
    mov    [esp + 12], edx          ;arg4: flag=0 (unsigned int)
    call   print_int2string
    add    esp, 16                  ;restore 16 bytes

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16+0)              ;get address temp_string_b0
    mov    edx, [esp + 16 + 12]     ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: address temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16+16)             ;restore 16+16 bytes

; append newline character to the ascii string
    sub    esp, 8
    mov    dword [esp    ], 0x0a    ;temp_string_b0
    mov    dword [esp + 4], 1       ;temp_string_len

    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string_b0     ;get @ascii_string_b0
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    add    edx, [esp + 16 + 4]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string_b0
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 8)            ;restore 16 bytes and 8 bytes

; print the ascii string to stdout
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;write to stdout
    mov    ecx, ascii_string_b0     ;src = ascii string
    mov    edx, [ascii_string_len]  ;length of ascii string
    int    0x80

.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

