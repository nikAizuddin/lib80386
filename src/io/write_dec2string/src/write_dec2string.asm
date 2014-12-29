;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|         FUNCTION: write_dec2string                                  |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 14/OCT/2014                                       |
;| FUNCTION PURPOSE: <See doc/description file>                        |
;+---------------------------------------------------------------------+
;|         LANGUAGE: x86 Assembly Language                             |
;|           SYNTAX: Intel                                             |
;|        ASSEMBLER: NASM                                              |
;|     ARCHITECTURE: i386, i586, i686, x86_64                          |
;|           KERNEL: Linux 32-bit                                      |
;|           FORMAT: elf32                                             |
;|    INCLUDE FILES: ---                                               |
;+---------------------------------------------------------------------+
;|          VERSION: 0.1.1                                             |
;|           STATUS: Alpha                                             |
;|             BUGS: --- <See doc/bugs/index file>                     |
;+---------------------------------------------------------------------+
;| REVISION HISTORY: <See doc/revision_history/index file>             |
;+---------------------------------------------------------------------+
;|                 MIT Licensed. See /LICENSE file.                    |
;+---------------------------------------------------------------------+
;=======================================================================

global write_dec2string

section .text

write_dec2string:

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
    mov    dword [esp + 20], 0      ;decimal_x[0]
    mov    dword [esp + 24], 0      ;decimal_x[1]
    mov    dword [esp + 28], 0      ;decimal_x[0]_len
    mov    dword [esp + 32], 0      ;decimal_x[1]_len
    mov    dword [esp + 36], 0      ;temp
    mov    dword [esp + 40], 0      ;i
    mov    dword [esp + 44], 0      ;ascii_char
    mov    dword [esp + 48], 0      ;byte_pos


;///////////////////////////////////////////////////////////////////////
;//                        ALGORITHM BEGIN                            //
;///////////////////////////////////////////////////////////////////////


;+----------------------------------+
;| Check number of decimal_x blocks |===================================
;+----------------------------------+
;=======================================================================

    ;    +----------------------------------+
    ;----| 001: if num_of_blocks != 2, then |---------------------------
    ;    +----------------------------------+
    ;       goto .decimal_x_1_block
    ;-------------------------------------------------------------------
    mov    eax, [esp + 4]           ;eax = num_of_blocks
    cmp    eax, 2
    jne    .decimal_x_1_block

.decimal_x_2_blocks:

    ;    +-------------------------------------+
    ;----| 002: decimal_x[0] = addr_decimal_x^ |------------------------
    ;    +-------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp]               ;eax = addr_decimal_x
    mov    eax, [eax]               ;eax = addr_decimal_x^
    mov    [esp + 20], eax          ;decimal_x[0] = addr_decimal_x^

    ;    +-----------------------------------------+
    ;----| 003: decimal_x[1] = (addr_decimal_x+4)^ |--------------------
    ;    +-----------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp]               ;eax = addr_decimal_x
    add    eax, 4
    mov    eax, [eax]               ;eax = (addr_decimal_x+4)^
    mov    [esp + 24], eax          ;decimal_x[1] = eax

    ;    +---------------------------+
    ;----| 004: decimal_x[0]_len = 8 |----------------------------------
    ;    +---------------------------+
    ;-------------------------------------------------------------------
    mov    eax, 8
    mov    [esp + 28], eax          ;decimal_x[0]_len = 8


;+--------------------------------------------+
;| Find the number of nipples in decimal_x[1] |=========================
;+--------------------------------------------+
;=======================================================================

    ;    +--------------------------+
    ;----| 005: temp = decimal_x[1] |-----------------------------------
    ;    +--------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 24]          ;eax = decimal_x[1]
    mov    [esp + 36], eax          ;temp = eax

.loop_1:

    ;    +-----------------+
    ;----| 006: temp >>= 4 |--------------------------------------------
    ;    +-----------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = eax

    ;    +--------------------------+
    ;----| 007: ++ decimal_x[1]_len |-----------------------------------
    ;    +--------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 32]          ;eax = decimal_x[1]_len
    add    eax, 1
    mov    [esp + 32], eax          ;decimal_x[1]_len = eax

    ;    +-------------------------+
    ;----| 008: if temp != 0, then |------------------------------------
    ;    +-------------------------+
    ;       goto .loop_1
    ;-------------------------------------------------------------------
    mov    eax, [esp + 36]          ;eax = temp
    cmp    eax, 0
    jne    .loop_1

.endloop_1:


;+--------------------------------+
;| Fill ascii_x with decimal_x[1] |=====================================
;+--------------------------------+
;=======================================================================

    ;    +---------------------------+
    ;----| 009: i = decimal_x[1]_len |----------------------------------
    ;    +---------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 32]          ;eax = decimal_x[1]_len
    mov    [esp + 40], eax          ;i = decimal_x[1]_len

.loop_2:

    ;    +-------------------+
    ;----| 010: ascii_char = |------------------------------------------
    ;    +-------------------+
    ;       ( (decimal_x[1] >> ( (i-1)*4 )) & 0x0f ) | 0x30;
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    ecx, eax
    mov    eax, [esp + 24]          ;eax = decimal_x[1]
    shr    eax, cl                  ;decimal_x[1] >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result

    ;    +--------------------------+
    ;----| 011: addr_out_string^ |= |-----------------------------------
    ;    +--------------------------+
    ;       ( ascii_char << (byte_pos*8) );
    ;-------------------------------------------------------------------
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

    ;    +--------------------+
    ;----| 012: ++ out_strlen |-----------------------------------------
    ;    +--------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 16]          ;eax = out_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1

    ;    +------------------+
    ;----| 013: ++ byte_pos |-------------------------------------------
    ;    +------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pox + 1

    ;    +-----------+
    ;----| 014: -- i |--------------------------------------------------
    ;    +-----------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i - 1

    ;    +----------------------+
    ;----| 015: if i != 0, then |---------------------------------------
    ;    +----------------------+
    ;       goto .loop_2;
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]         ;eax = i
    cmp    eax, 0
    jne    .loop_2

.endloop_2:


;+--------------------------------+
;| Fill ascii_x with decimal_x[0] |=====================================
;+--------------------------------+
;=======================================================================

    ;    +---------------------------+
    ;----| 016: i = decimal_x[0]_len |----------------------------------
    ;    +---------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 28]          ;eax = decimal_x[0]_len
    mov    [esp + 40], eax          ;i = decimal_x[0]_len

.loop_3:

    ;    +--------------------+
    ;----| 017:  ascii_char = |-----------------------------------------
    ;    +--------------------+
    ;       ( (decimal_x[0] >> ( (i-1)*4) ) & 0x0f ) | 0x30;
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= 4
    mov    ecx, eax                 ;ecx = ((i-1)*4)
    mov    eax, [esp + 20]          ;eax = decimal_x[0]
    shr    eax, cl                  ;eax >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result

    ;    +--------------------------+
    ;----| 018: addr_out_string^ |= |-----------------------------------
    ;    +--------------------------+
    ;       ( ascii_char << (byte_pos*8) );
    ;-------------------------------------------------------------------
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

    ;    +---------------------+
    ;----| 019: ++ out_strlen; |----------------------------------------
    ;    +---------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 16]          ;eax = out_strlen 
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1

    ;    +------------------+
    ;----| 020: ++ byte_pos |-------------------------------------------
    ;    +------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pos + 1

    ;    +-----------------------------+
    ;----| 021: if byte_pos != 4, then |--------------------------------
    ;    +-----------------------------+
    ;       goto .cond1_out_string_not_full;
    ;-------------------------------------------------------------------
    mov    eax, [esp + 48]          ;eax = byte_pos
    cmp    eax, 4
    jne    .cond1_out_string_not_full      

.cond1_out_string_full:

    ;    +----------------------------+
    ;----| 022: addr_out_string += 4; |---------------------------------
    ;    +----------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 8]           ;eax = addr_out_string
    add    eax, 4
    mov    [esp + 8], eax           ;addr_out_string = (eax + 4)

    ;    +-------------------+
    ;----| 023: byte_pos = 0 |------------------------------------------
    ;    +-------------------+
    ;-------------------------------------------------------------------
    xor    eax, eax
    mov    [esp + 48], eax          ;byte_pos = eax

.cond1_out_string_not_full:

    ;    +------------+
    ;----| 024: -- i; |-------------------------------------------------
    ;    +------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i + 1

    ;    +----------------------+
    ;----| 025: if i != 0, then |---------------------------------------
    ;    +----------------------+
    ;       goto .loop_3;
    ;-------------------------------------------------------------------
    mov    eax, [esp + 40]          ;eax = i
    cmp    eax, 0
    jne    .loop_3

.endloop_3:

    ;    +-----------------------------+
    ;----| 026: goto .save_out_strlen; |--------------------------------
    ;    +-----------------------------+
    ;       skip .decimal_x_1_block.
    ;-------------------------------------------------------------------
    jmp    .save_out_strlen


.decimal_x_1_block:

;+--------------------------+
;| If number of blocks is 1 |===========================================
;+--------------------------+
;=======================================================================

    ;    +---------------------------------------+
    ;----| 027: decimal_x[0] = addr_out_string^; |----------------------
    ;    +---------------------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp     ]          ;eax = addr_out_string
    mov    eax, [eax]               ;eax = addr_out_string^
    mov    [esp + 20], eax          ;decimal_x_b0 = eax


;+--------------------------------------------+
;| Find the number of nipples in decimal_x[0] |=========================
;+--------------------------------------------+
;=======================================================================

    ;    +---------------------------+
    ;----| 028: temp = decimal_x[0]; |----------------------------------
    ;    +---------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 20]          ;eax = decimal_x[0]
    mov    [esp + 36], eax          ;temp = eax

.loop_4:

    ;    +------------------+
    ;----| 029: temp >>= 4; |-------------------------------------------
    ;    +------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = temp >> 4

    ;    +---------------------------+
    ;----| 030: ++ decimal_x[0]_len; |----------------------------------
    ;    +---------------------------+
    ;-------------------------------------------------------------------
    mov    eax, [esp + 28]          ;eax = decimal_x[0]_len
    add    eax, 1
    mov    [esp + 28], eax          ;decimal_x[0]_len = eax + 1

; While temp <> 0, goto .loop_4
;-----------------------------------------------------------------------
    mov    eax, [esp + 36] ;eax := temp
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_4         ;if <>, goto .loop_4

.endloop_4:

;+---------------------------------------------------------------------+
;|           { Fill the ascii_x with decimal_x block 0 }               |
;|           counter := decimal_x_b0_len;                              |
;|           While counter <> 0 Do                                     |
;|           Begin                                                     |
;|               ascii_char :=                                         |
;|                   ((decimal_x_b0 >> ((counter-1)*4)) and 0x0f) or   |
;|                   0x30;                                             |
;|               ascii_x_ptr^ :=                                       |
;|                   ascii_x_ptr^ or (ascii_char << (byte_position*8));|
;|               ++ ascii_x_len;                                       |
;|               ++ byte_position;                                     |
;|               If byte_position = 4 Then                             |
;|                   ascii_x_ptr := ascii_x_ptr + 4;                   |
;|                   byte_position := 0;                               |
;|               -- counter;                                           |
;|           End;                                                      |
;+---------------------------------------------------------------------+

; counter := decimal_x_b0_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 28] ;eax := decimal_x_b0_len
    mov    [esp + 40], eax ;counter := eax

.loop_5:

; ascii_char := ((decimal_x_b0 >> ((counter-1)*4)) and 0x0f) or 0x30
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    sub    eax, 1          ;eax := eax - 1
    mov    ebx, 4          ;ebx := 4
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    ecx, eax        ;ecx := eax
    mov    eax, [esp + 20] ;eax := decimal_x_b0
    shr    eax, cl         ;eax := eax >> cl
    and    eax, 0x0f       ;eax := eax and 0x0f
    or     eax, 0x30       ;eax := eax or 0x30
    mov    [esp + 44], eax ;ascii_char := eax

; ascii_x_ptr^ := ascii_x_ptr^ or (ascii_char << (byte_position*8))
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := byte_position
    mov    ebx, 8          ;ebx := 8
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    ecx, eax        ;ecx := eax
    mov    eax, [esp + 44] ;eax := ascii_char
    shl    eax, cl         ;eax := eax << cl
    mov    ecx, [esp +  8] ;ecx := ascii_x_ptr
    mov    ebx, [ecx]      ;ebx := ecx^
    or     eax, ebx        ;eax := eax or ebx
    mov    [ecx], eax      ;ecx^ := eax

; ++ ascii_x_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 16] ;eax := ascii_x_len
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 16], eax ;ascii_x_len := eax

; ++ byte_position
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := byte_position
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 48], eax ;byte_position := eax

.check2_is_ascii_x_block_full:
; If byte_position = 4 Then continue to .ascii_x_block_is_full
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := byte_position
    cmp    eax, 4          ;compare eax with 4
    ;if <>, goto .cond2_ascii_x_block_is_not_full
    jne    .cond2_ascii_x_block_is_not_full

.cond2_ascii_x_block_is_full:
; ascii_x_ptr := ascii_x_ptr + 4
;-----------------------------------------------------------------------
    mov    eax, [esp + 8] ;eax := ascii_x_ptr
    add    eax, 4         ;eax := eax + 4
    mov    [esp + 8], eax ;ascii_x_ptr := eax

; byte_position := 0
;-----------------------------------------------------------------------
    xor    eax, eax        ;eax := 0
    mov    [esp + 48], eax ;byte_position := eax

.cond2_ascii_x_block_is_not_full:

; -- counter
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    sub    eax, 1          ;eax := eax - 1
    mov    [esp + 40], eax ;counter := eax

; While counter <> 0, goto .loop_5
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_5 ;if <>, goto .loop_5

.endloop_5:

.save_out_strlen:
;+---------------------------------------------------------------------+
;|       { Save the length of ascii_x }                                |
;|       ascii_x_len_ptr^ := ascii_x_len;                              |
;+---------------------------------------------------------------------+

; ascii_x_len_ptr^ := ascii_x_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 16] ;eax := ascii_x_len
    mov    ebx, [esp + 12] ;ebx := ascii_x_len_ptr
    mov    [ebx], eax      ;ebx^ := eax

.return:

.clean_stackframe:
    sub    ebp, 8     ;-8 offset to ebp
    mov    esp, ebp   ;restore stack pointer to its initial value
    mov    ebp, [esp] ;restore ebp to its initial value
    add    esp, 4     ;restore 4 bytes

    ret

