;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|            TITLE: formula_hex2dec                                   |
;+---------------------------------------------------------------------+
;|           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                 |
;|            EMAIL: nickaizuddin93@gmail.com                          |
;|     DATE CREATED: 13/OCT/2014                                       |
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
;|     0.1.0  | 13/OCT/2014 | First release.                           |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Copyright(C) 2014 Nik Mohamad Aizuddin bin Nik Azmi.                |
;+---------------------------------------------------------------------+
;=======================================================================

; ---- section instruction codes ---------------------------------------
section .text

global formula_hex2dec  
formula_hex2dec:  

.setup_stackframe:
    sub    esp, 4     ;reserve 4 bytes to store ebp value
    mov    [esp], ebp ;store ebp to stack
    mov    ebp, esp   ;store current stack pointer to ebp

.get_arguments:
    add    ebp, 8     ;+8 offsets to ebp, to get arguments
    mov    eax, [ebp] ;hexadecimal_num

.setup_localvariables:
    sub    esp, 80             ;reserve 80 bytes of stack
    mov    [esp     ], eax     ;hexadecimal_num
    mov    dword [esp +  4], 0 ;decimal_num
    mov    dword [esp +  8], 0 ;A
    mov    dword [esp + 12], 0 ;B
    mov    dword [esp + 16], 0 ;C
    mov    dword [esp + 20], 0 ;D
    mov    dword [esp + 24], 0 ;E
    mov    dword [esp + 28], 0 ;F
    mov    dword [esp + 32], 0 ;G
    mov    dword [esp + 36], 0 ;H
    mov    dword [esp + 40], 0 ;I
    mov    dword [esp + 44], 0 ;J
    mov    dword [esp + 48], 0 ;K
    mov    dword [esp + 52], 0 ;L
    mov    dword [esp + 56], 0 ;M
    mov    dword [esp + 60], 0 ;N
    mov    dword [esp + 64], 0 ;O
    mov    dword [esp + 68], 0 ;P
    mov    dword [esp + 72], 0 ;Q
    mov    dword [esp + 76], 0 ;R

.begin_formula_hex2dec:  

;+---------------------------------------------------------------------+
;|       A := (hexadecimal_num / 1000000000);                          |
;|       B := 16 * A;                                                  |
;|       C := (hexadecimal_num / 100000000) + B;                       |
;|       D := 16 * C;                                                  |
;|       E := (hexadecimal_num / 10000000) + D;                        |
;|       F := 16 * E;                                                  |
;|       G := (hexadecimal_num / 1000000) + F;                         |
;|       H := 16 * G;                                                  |
;|       I := (hexadecimal_num / 100000) + H;                          |
;|       J := 16 * I;                                                  |
;|       K := (hexadecimal_num / 10000) + J;                           |
;|       L := 16 * K;                                                  |
;|       M := (hexadecimal_num / 1000) + L;                            |
;|       N := 16 * M;                                                  |
;|       O := (hexadecimal_num / 100) + N;                             |
;|       P := 16 * O;                                                  |
;|       Q := (hexadecimal_num / 10) + P;                              |
;|       R := 6 * Q;                                                   |
;|       decimal_num := hexadecimal_num + R;                           |
;+---------------------------------------------------------------------+

; A := (hexadecimal_num / 1000000000)
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 1000000000 ;ebx := 1000000000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    [esp +  8], eax ;A := eax

; B := 16 * A
;-----------------------------------------------------------------------
    mov    eax, [esp +  8] ;eax := A
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 12], eax ;B := eax

; C := (hexadecimal_num / 100000000) + B
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecmal_num
    mov    ebx, 100000000  ;ebx := 100000000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 12] ;ebx := B
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 16], eax ;C := eax

; D := 16 * C
;-----------------------------------------------------------------------
    mov    eax, [esp + 16] ;eax := C
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 20], eax ;D := eax

; E := (hexadecimal_num / 10000000) + D
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 10000000   ;ebx := 10000000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 20] ;ebx := D
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 24], eax ;E := eax

; F := 16 * E
;-----------------------------------------------------------------------
    mov    eax, [esp + 24] ;eax := E
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 28], eax ;F := eax

; G := (hexadecimal_num / 1000000) + F
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 1000000    ;ebx := 1000000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 28] ;ebx := F
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 32], eax ;G := eax

; H := 16 * G
;-----------------------------------------------------------------------
    mov    eax, [esp + 32] ;eax := G
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 36], eax ;H := eax

; I := (hexadecimal_num / 100000) + H
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 100000     ;ebx := 100000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 36] ;ebx := H
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 40], eax ;I := eax

; J := 16 * I
;-----------------------------------------------------------------------
    mov    eax, [esp + 40] ;eax := I
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 44], eax ;J := eax

; K := (hexadecimal_num / 10000) + J
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 10000      ;ebx := 10000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 44] ;ebx := J
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 48], eax ;K := eax

; L := 16 * K
;-----------------------------------------------------------------------
    mov    eax, [esp + 48] ;eax := K
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 52], eax ;L := eax

; M := (hexadecimal_num / 1000) + L
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 1000       ;ebx := 1000
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 52] ;ebx := L
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 56], eax ;M := eax

; N := 16 * M
;-----------------------------------------------------------------------
    mov    eax, [esp + 56] ;eax := M
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 60], eax ;N := eax

; O := (hexadecimal_num / 100) + N
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 100        ;ebx := 100
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 60] ;ebx := N
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 64], eax ;O := eax

; P := 16 * O
;-----------------------------------------------------------------------
    mov    eax, [esp + 64] ;eax := O
    mov    ebx, 16         ;ebx := 16
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 68], eax ;P := eax

; Q := (hexadecimal_num / 10) + P
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, 10         ;ebx := 10
    xor    edx, edx        ;edx := 0
    div    ebx             ;eax := eax / ebx
    mov    ebx, [esp + 68] ;ebx := P
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp + 72], eax ;Q := eax

; R := 6 * Q
;-----------------------------------------------------------------------
    mov    eax, [esp + 72] ;eax := Q
    mov    ebx, 6          ;ebx := 6
    xor    edx, edx        ;edx := 0
    mul    ebx             ;eax := eax * ebx
    mov    [esp + 76], eax ;R := eax

; decimal_num := hexadecimal_num + R
;-----------------------------------------------------------------------
    mov    eax, [esp     ] ;eax := hexadecimal_num
    mov    ebx, [esp + 76] ;ebx := R
    add    eax, ebx        ;eax := eax + ebx
    mov    [esp +  4], eax ;decimal_num := eax

.return:
    mov    eax, [esp + 4] ;eax := decimal_num

.clean_stackframe:
    sub    ebp, 8     ;-8 offsets to ebp, to get initial esp value
    mov    esp, ebp   ;restore stack pointer to its initial value
    mov    ebp, [esp] ;restore ebp to its initial value
    add    esp, 4     ;restore 4 bytes of stack memory

    ret

