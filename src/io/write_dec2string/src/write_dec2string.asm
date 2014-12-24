;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: write_dec2string                                  |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 14/OCT/2014                                       |
;|  PROGRAM PURPOSE: <See README file>                                 |
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
;|     0.1.0  | 14/OCT/2014 | First release.                           |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- section instruction codes ---------------------------------------
section .text

global write_dec2string
write_dec2string:

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes to store ebp
    mov    [esp], ebp ;store ebp to stack
    mov    ebp, esp   ;store current stack pointer value to ebp

.get_arguments:
    add    ebp, 8 ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ] ;get address decimal_x_b0
    mov    ebx, [ebp +  4] ;get num_of_blocks
    mov    ecx, [ebp +  8] ;get address ascii_x_b0
    mov    edx, [ebp + 12] ;get address ascii_x_len

.setup_localvariables:
    sub    esp, 52             ;reserve 52 bytes
    mov    [esp     ], eax     ;decimal_x_ptr
    mov    [esp +  4], ebx     ;num_of_blocks
    mov    [esp +  8], ecx     ;ascii_x_ptr
    mov    [esp + 12], edx     ;ascii_x_len_ptr
    mov    dword [esp + 16], 0 ;ascii_x_len
    mov    dword [esp + 20], 0 ;decimal_x_b0
    mov    dword [esp + 24], 0 ;decimal_x_b1
    mov    dword [esp + 28], 0 ;decimal_x_b0_len
    mov    dword [esp + 32], 0 ;decimal_x_b1_len
    mov    dword [esp + 36], 0 ;temp
    mov    dword [esp + 40], 0 ;counter
    mov    dword [esp + 44], 0 ;ascii_char
    mov    dword [esp + 48], 0 ;byte_position

.check_num_of_blocks:
;+---------------------------------------------------------------------+
;|       { If there are 2 blocks of decimal_x }                        |
;|       If num_of_blocks = 2 Then                                     |
;+---------------------------------------------------------------------+

; If num_of_blocks = 2 Then continue to .decimal_x_2_blocks
;-----------------------------------------------------------------------
    mov    eax, [esp + 4]     ;eax := num_of_blocks
    cmp    eax, 2             ;compare eax with 2
    jne    .decimal_x_1_block ;if <>, goto .decimal_x_1_block

.decimal_x_2_blocks:
;+---------------------------------------------------------------------+
;|           decimal_x_b0 := decimal_x_ptr^;                           |
;|           decimal_x_b1 := (decimal_x_ptr+4)^;                       |
;+---------------------------------------------------------------------+

; decimal_x_b0 := decimal_x_ptr^
;-----------------------------------------------------------------------
    mov    eax, [esp]      ;eax := decimal_x_ptr
    mov    eax, [eax]      ;eax := eax^
    mov    [esp + 20], eax ;decimal_x_b0 := eax

; decimal_x_b1 := (decimal_x_ptr+4)^
;-----------------------------------------------------------------------
    mov    eax, [esp]      ;eax := decimal_x_ptr
    add    eax, 4          ;eax := eax + 4
    mov    eax, [eax]      ;eax := eax^
    mov    [esp + 24], eax ;decimal_x_b1 := eax

;+---------------------------------------------------------------------+
;|           decimal_x_b0_len := 8;                                    |
;+---------------------------------------------------------------------+

; decimal_x_b0_len := 8
;-----------------------------------------------------------------------
    mov    eax, 8          ;eax := 8
    mov    [esp + 28], eax ;decimal_x_b0_len := eax

;+---------------------------------------------------------------------+
;|           { Find the number of nipples in decimal_x_b1 }            |
;|           temp := decimal_x_b1;                                     |
;|           While temp <> 0 Do                                        |
;|           Begin                                                     |
;|               temp := temp >> 4;                                    |
;|               ++ decimal_x_b1_len;                                  |
;|           End;                                                      |
;+---------------------------------------------------------------------+

; temp := decimal_x_b1
;-----------------------------------------------------------------------
    mov    eax, [esp + 24] ;eax := decimal_x_b1
    mov    [esp + 36], eax ;temp := eax

.loop_1:

; temp := temp >> 4
;-----------------------------------------------------------------------
    mov    eax, [esp + 36] ;eax := temp
    shr    eax, 4          ;eax := eax >> 4
    mov    [esp + 36], eax ;temp := eax

; ++ decimal_x_b1_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 32] ;eax := decimal_x_b1_len
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 32], eax ;decimal_x_b1_len := eax

; While temp <> 0, goto .loop_1
;-----------------------------------------------------------------------
    mov    eax, [esp + 36] ;eax := temp
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_1         ;if <>, goto .loop_1

;+---------------------------------------------------------------------+
;|           { Fill ascii_x with decimal_x block 1 }                   |
;|           counter := decimal_x_b1_len;                              |
;|           While counter <> 0 Do                                     |
;|           Begin                                                     |
;|               ascii_char :=                                         |
;|                   ((decimal_x_b1 >> ((counter-1)*4)) and 0x0f) or   |
;|                   0x30;                                             |
;|               ascii_x_ptr^ :=                                       |
;|                   ascii_x_ptr^ or (ascii_char << (byte_position*8));|
;|               ++ ascii_x_len;                                       |
;|               ++ byte_position;                                     |
;|               -- counter;                                           |
;|           End;                                                      |
;+---------------------------------------------------------------------+

; counter := decimal_x_b1_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 32] ;eax := decimal_x_b1_len
    mov    [esp + 40], eax ;counter := eax

.loop_2:

; ascii_char := ((decimal_x_b1 >> ((counter-1)*4)) and 0x0f) or 0x30
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    sub    eax, 1          ;eax := eax - 1
    mov    ebx, 4          ;ebx := 4
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    ecx, eax        ;ecx := eax
    mov    eax, [esp + 24] ;eax := decimal_x_b1
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

; -- counter
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    sub    eax, 1          ;eax := eax - 1
    mov    [esp + 40], eax ;counter := eax

; While counter <> 0, goto .loop_2
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_2         ;if <>, goto .loop_2

;+---------------------------------------------------------------------+
;|           { Fill ascii_x with decimal_x block 0 }                   |
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

.loop_3:

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

.check1_is_ascii_x_block_full:
; If byte_position = 4 Then continue to .ascii_x_block_is_full
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := byte_position
    cmp    eax, 4          ;compare eax with 4
    ;if <>, goto .cond1_ascii_x_block_is_not_full
    jne    .cond1_ascii_x_block_is_not_full

.cond1_ascii_x_block_is_full:
; ascii_x_ptr := ascii_x_ptr + 4
;-----------------------------------------------------------------------
    mov    eax, [esp + 8] ;eax := ascii_x_ptr
    add    eax, 4         ;eax := eax + 4
    mov    [esp + 8], eax ;ascii_x_ptr := eax

; byte_position := 0
;-----------------------------------------------------------------------
    xor    eax, eax        ;eax := 0
    mov    [esp + 48], eax ;byte_position := eax

.cond1_ascii_x_block_is_not_full:

; -- counter
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    sub    eax, 1          ;eax := eax - 1
    mov    [esp + 40], eax ;counter := eax

; While counter <> 0, goto .loop_3
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := counter
    cmp    eax, 0          ;compare eax with 0
    jne    .loop_3         ;if <>, goto .loop_3

.endloop_3:

; skip .decimal_x_1_block:
;-----------------------------------------------------------------------
    jmp    .save_ascii_x_len

.decimal_x_1_block:
;+---------------------------------------------------------------------+
;|       { If number of blocks is 1, or other than 2 }                 |
;|       Else                                                          |
;|           decimal_x_b0 := decimal_x_ptr^;                           |
;+---------------------------------------------------------------------+
    mov    eax, [esp     ] ;eax := decimal_x_ptr
    mov    eax, [eax]      ;eax := eax^
    mov    [esp + 20], eax ;decimal_x_b0 := eax

;+---------------------------------------------------------------------+
;|           { Find the number of nipples in decimal_x block 0 }       |
;|           temp := decimal_x_b0;                                     |
;|           While temp <> 0 Do                                        |
;|           Begin                                                     |
;|               temp := temp >> 4;                                    |
;|               ++ decimal_x_b0_len;                                  |
;|           End;                                                      |
;+---------------------------------------------------------------------+

; temp := decimal_x_b0
;-----------------------------------------------------------------------
    mov    eax, [esp + 20] ;eax := decimal_x_b0
    mov    [esp + 36], eax ;temp := eax

.loop_4:

; temp := temp >> 4
;-----------------------------------------------------------------------
    mov    eax, [esp + 36] ;eax := temp
    shr    eax, 4          ;eax := eax >> 4
    mov    [esp + 36], eax ;temp := eax

; ++ decimal_x_b0_len
;-----------------------------------------------------------------------
    mov    eax, [esp + 28] ;eax := decimal_x_b0_len
    add    eax, 1          ;eax := eax + 1
    mov    [esp + 28], eax ;decimal_x_b0_len := eax

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

.save_ascii_x_len:
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

