;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: pow_int                                           |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 08/NOV/2014                                       |
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
;|          VERSION: 0.2.0                                             |
;|           STATUS: Alpha                                             |
;+---------------------------------------------------------------------+
;| REVISION HISTORY:                                                   |
;|                                                                     |
;|     Rev #  |    Date     | Description                              |
;|   ---------+-------------+---------------------------------------   |
;|     0.1.0  | 08/NOV/2014 | First release.                           |
;|     0.2.0  | 12/DEC/2014 | Result is now pass as return             |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

;---- section instruction codes ----------------------------------------
section .text

global pow_int
pow_int:

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes
    mov    [esp], ebp ;store ebp to stack
    mov    ebp, esp   ;store current stack pointer to ebp

.get_arguments:
    add    ebp, 8         ;+8 offset to get arguments
    mov    eax, [ebp    ] ;get x the base value
    mov    ebx, [ebp + 4] ;get y the power value

.set_local_variables:
    sub    esp, 16             ;reserve 16 bytes
    mov    [esp     ], eax     ;x
    mov    [esp +  4], ebx     ;y
    mov    [esp +  8], ebx     ;i
    mov    dword [esp + 12], 1 ;result

;+---------------------------------------------------------------------+
;|       while ctr != 0 do                                             |
;|       begin                                                         |
;|           result := result * x;                                     |
;|           -- i;                                                     |
;|       end;                                                          |
;+---------------------------------------------------------------------+

.loop_1:

; result := result * x;
;-----------------------------------------------------------------------
    mov    eax, [esp + 12] ;eax := result
    mov    ebx, [esp     ] ;ebx := x
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 12], eax ;result := eax

; -- i;
;-----------------------------------------------------------------------
    mov    eax, [esp + 8] ;eax := i
    sub    eax, 1         ;eax := eax - 1
    mov    [esp + 8], eax ;i := eax

; while i != 0, goto .loop_1
;-----------------------------------------------------------------------
    mov    eax, [esp + 8] ;eax := i
    cmp    eax, 0         ;compare eax with 0
    jne    .loop_1        ;if <>, goto .loop_1

.endloop_1:

;+---------------------------------------------------------------------+
;|       return result;                                                |
;+---------------------------------------------------------------------+
    mov    eax, [esp + 12] ;eax := result

.return:

.clean_stackframe:
    sub    ebp, 8     ;-8 offset due to arguments
    mov    esp, ebp   ;restore the stack pointer to initial value
    mov    ebp, [esp] ;restore ebp to initial value
    add    esp, 4     ;restore 4 bytes

    ret

