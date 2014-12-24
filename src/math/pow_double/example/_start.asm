;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|                    Example using pow_double()                       |
;|                                                                     |
;+---------------------------------------------------------------------+
;=======================================================================

extern pow_double
extern print_double2string
extern append_string

section .bss
    pow_result:          resq 1
    ascii_string:        resd 32
    ascii_string_len:    resd 1

section .rdata
    x:                   dq 9.12
    y:                   dq 6.73

section .text
global _start
_start:

;+-----------------+
;| calculate power |====================================================
;+-----------------+
;    +----------------------------+
;----| call function pow_double() |=====================================
;    +----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [x    ]             ;get x (part 1/2)
    mov    ebx, [x + 4]             ;get x (part 2/2)
    mov    ecx, [y    ]             ;get y (part 1/2)
    mov    edx, [y + 4]             ;get y (part 2/2)
    mov    [esp     ], eax          ;arg1: x (part 1/2)
    mov    [esp +  4], ebx          ;arg1: x (part 2/2)
    mov    [esp +  8], ecx          ;arg2: y (part 1/2)
    mov    [esp + 12], edx          ;arg2: y (part 2/2)
    call   pow_double
    fst    qword [pow_result]       ;save power result
    add    esp, 16                  ;restore 16 bytes

;///////////////////////////////////////////////////////////////////////
;
;                             PRINT RESULT
;
;///////////////////////////////////////////////////////////////////////

;+-------------------------------------------+
;| put "The value of " into the ascii string |==========================
;+-------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 20
    mov    dword [esp     ], "The " ;temp_string_b0
    mov    dword [esp +  4], "valu" ;temp_string_b1
    mov    dword [esp +  8], "e of" ;temp_string_b2
    mov    dword [esp + 12], " "    ;temp_string_b3
    mov    dword [esp + 16], 13     ;temp_string_len
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 16]     ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 20)           ;restore 16 + 20 bytes

;+------------------------------------------+
;| append the x value into the ascii string |===========================
;+------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 12
    mov    dword [esp     ], 0      ;temp_string_b0
    mov    dword [esp +  4], 0      ;temp_string_b1
    mov    dword [esp +  8], 0      ;temp_string_len
    ;    +-----------------------------------+
    ;----| call function print_double2string |--------------------------
    ;    +-----------------------------------+
    sub    esp, 20                  ;reserve 20 bytes
    mov    eax, [x    ]             ;get x (part1/2)
    mov    ebx, [x + 4]             ;get x (part2/2)
    mov    ecx, 100                 ;get decimal_places = 2
    mov    [esp     ], eax          ;arg1: x (part1/2)
    mov    [esp +  4], ebx          ;arg2: x (part2/2)
    mov    [esp +  8], ecx          ;arg3: decimal_places = 2
    mov    eax, esp
    mov    ebx, esp
    add    eax, (20 + 0)            ;get @temp_string_b0
    add    ebx, (20 + 8)            ;get @temp_string_len
    mov    [esp + 12], eax          ;arg4: @temp_string_b0
    mov    [esp + 16], ebx          ;arg5: @temp_string_len
    call   print_double2string
    add    esp, 20                  ;restore 20 bytes
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 8]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 12)           ;restore 16 + 12 bytes

;+------------------------------------------------+
;| append the character "^" into the ascii string |=====================
;+------------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 8 ;reserve 8 bytes
    mov    dword [esp    ], "^"     ;temp_string_b0
    mov    dword [esp + 4], 1       ;temp_string_len
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 4]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_strng_len
    call   append_string
    add    esp, (16 + 8)            ;restore 16 + 8 bytes

;+------------------------------------------+
;| append the y value into the ascii string |===========================
;+------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 12                  ;reserve 12 bytes
    mov    dword [esp     ], 0      ;temp_string_b0
    mov    dword [esp +  4], 0      ;temp_string_b1
    mov    dword [esp +  8], 0      ;temp_string_len
    ;    +-----------------------------------+
    ;----| call function print_double2string |--------------------------
    ;    +-----------------------------------+
    sub    esp, 20                  ;reserve 20 bytes
    mov    eax, [y    ]             ;get y (part 1/2)
    mov    ebx, [y + 4]             ;get y (part 2/2)
    mov    ecx, 100                 ;get decimal_places = 2
    mov    [esp     ], eax          ;arg1: y (part 1/2)
    mov    [esp +  4], ebx          ;arg1: y (part 2/2)
    mov    [esp +  8], ecx          ;arg2: decimal_places
    mov    eax, esp
    mov    ebx, esp
    add    eax, (20 + 0)            ;get @temp_string_b0
    add    ebx, (20 + 8)            ;get @temp_string_len
    mov    [esp + 12], eax          ;arg3: @temp_string_b0
    mov    [esp + 16], ebx          ;arg4: @temp_string_len
    call   print_double2string
    add    esp, 20                  ;restore 20 bytes
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 8]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 12)           ;restore 16 + 12 bytes

;+----------------------------------------+
;| append the " = " into the ascii string |=============================
;+----------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 8                   ;reserve 8 bytes
    mov    dword [esp    ], " = "   ;temp_string_b0
    mov    dword [esp + 4], 3       ;temp_string_len
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 4]      ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 8)            ;restore 16 + 8 bytes

;+---------------------------------------------------+
;| append the pow_result value into the ascii string |==================
;+---------------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 28                  ;reserve 28 bytes
    mov    dword [esp     ], 0      ;temp_string_b0
    mov    dword [esp +  4], 0      ;temp_string_b1
    mov    dword [esp +  8], 0      ;temp_string_b2
    mov    dword [esp + 12], 0      ;temp_string_b3
    mov    dword [esp + 16], 0      ;temp_string_b4
    mov    dword [esp + 20], 0      ;temp_string_b5
    mov    dword [esp + 24], 0      ;temp_string_len
    ;    +-----------------------------------+
    ;----| call function print_double2string |--------------------------
    ;    +-----------------------------------+
    sub    esp, 20                  ;reserve 20 bytes
    mov    eax, [pow_result    ]    ;get pow_result (part 1/2)
    mov    ebx, [pow_result + 4]    ;get pow_result (part 2/2)
    mov    ecx, 10000000            ;get decimal_places = 7
    mov    [esp     ], eax          ;arg1: pow_result (part 1/2)
    mov    [esp +  4], ebx          ;arg1: pow_result (part 2/2)
    mov    [esp +  8], ecx          ;arg2: decimal_places = 7
    mov    eax, esp
    mov    ebx, esp
    add    eax, (20 +  0)           ;get @temp_string_b0
    add    ebx, (20 + 24)           ;get @temp_string_len
    mov    [esp + 12], eax          ;arg3: @temp_string_b0
    mov    [esp + 16], ebx          ;arg4: @temp_string_len
    call   print_double2string
    add    esp, 20                  ;restore 20 bytes
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, ascii_string        ;get @ascii_string
    mov    ebx, ascii_string_len    ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)            ;get @temp_string_b0
    mov    edx, [esp + 16 + 24]     ;get temp_string_len
    mov    [esp     ], eax          ;arg1: @ascii_string
    mov    [esp +  4], ebx          ;arg2: @ascii_string_len
    mov    [esp +  8], ecx          ;arg3: @temp_string_b0
    mov    [esp + 12], edx          ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 28)           ;restore 16 + 28 bytes

;+--------------------------------------------------+
;| append the newline character to the ascii string |===================
;+--------------------------------------------------+
    ;    +---------------------------------+
    ;----| setup temporary local variables |----------------------------
    ;    +---------------------------------+
    sub    esp, 8
    mov    dword [esp    ], 0x0a   ;temp_string_b0
    mov    dword [esp + 4], 1      ;temp_string_len
    ;    +-----------------------------+
    ;----| call function append_string |--------------------------------
    ;    +-----------------------------+
    sub    esp, 16                 ;reserve 16 bytes
    mov    eax, ascii_string       ;get @ascii_string
    mov    ebx, ascii_string_len   ;get @ascii_string_len
    mov    ecx, esp
    add    ecx, (16 + 0)           ;get @temp_string_b0
    mov    edx, [esp + 16 + 4]     ;get temp_string_len
    mov    [esp     ], eax         ;arg1: @ascii_string
    mov    [esp +  4], ebx         ;arg2: @ascii_string_len
    mov    [esp +  8], ecx         ;arg3: @temp_string_b0
    mov    [esp + 12], edx         ;arg4: temp_string_len
    call   append_string
    add    esp, (16 + 8)           ;restore 16 bytes + 8 bytes

;+----------------------------------+
;| print the ascii string to stdout |===================================
;+----------------------------------+
    mov    eax, 0x04               ;systemcall write
    mov    ebx, 0x01               ;write to stdout
    mov    ecx, ascii_string       ;src = ascii string
    mov    edx, [ascii_string_len] ;length of ascii string
    int    0x80

.exit:
    mov    eax, 0x01 ;systemcall exit
    xor    ebx, ebx  ;return 0
    int    0x80
