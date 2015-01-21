;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: cvt_dec2hex
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 19/JAN/2015
;
;        CONTRIBUTORS: ---
;
;            LANGUAGE: x86 Assembly Language
;              SYNTAX: Intel
;           ASSEMBLER: NASM
;        ARCHITECTURE: i386
;              KERNEL: Linux 32-bit
;              FORMAT: elf32
;
;      EXTERNAL FILES: ---
;
;             VERSION: 0.1.0
;              STATUS: Alpha
;                BUGS: --- <See doc/bugs/index file>
;
;    REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global cvt_dec2hex

section .text

cvt_dec2hex:

;parameter 1 = decimal_number:32bit
;returns = the hexadecimal number (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get decimal_number

.setup_localvariables:
    sub    esp, 36                  ;reserve 36 bytes
    mov    [esp     ], eax          ;decimal_number
    mov    dword [esp +  4], 0      ;A
    mov    dword [esp +  8], 0      ;B
    mov    dword [esp + 12], 0      ;C
    mov    dword [esp + 16], 0      ;D
    mov    dword [esp + 20], 0      ;E
    mov    dword [esp + 24], 0      ;F
    mov    dword [esp + 28], 0      ;G
    mov    dword [esp + 32], 0      ;H


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     A =  decimal_number >>  4;  
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 4
    mov    [esp +  4], eax          ;A = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:     B = (decimal_number >>  8) * 0xa;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 8
    mov    ebx, 0xa
    xor    edx, edx
    mul    ebx
    mov    [esp +  8], eax          ;B = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:     C = (decimal_number >> 12) * 0x64;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 12
    mov    ebx, 0x64
    xor    edx, edx
    mul    ebx
    mov    [esp + 12], eax          ;C = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:     D = (decimal_number >> 16) * 0x3e8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 16
    mov    ebx, 0x3e8
    xor    edx, edx
    mul    ebx
    mov    [esp + 16], eax          ;D = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:     E = (decimal_number >> 20) * 0x2710;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 20
    mov    ebx, 0x2710
    xor    edx, edx
    mul    ebx
    mov    [esp + 20], eax          ;E = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:     F = (decimal_number >> 24) * 0x186a0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 24
    mov    ebx,  0x186a0
    xor    edx, edx
    mul    ebx
    mov    [esp + 24], eax          ;F = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:     G = (decimal_number >> 28) * 0xf4240;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    shr    eax, 28
    mov    ebx, 0xf4240
    xor    edx, edx
    mul    ebx
    mov    [esp + 28], eax          ;G = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:     H = 0x6 * (A + B + C + D + E + F + G); 
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = A
    mov    ebx, [esp +  8]          ;ebx = B
    mov    ecx, [esp + 12]          ;ecx = C
    mov    edx, [esp + 16]          ;edx = D
    mov    esi, [esp + 20]          ;esi = E
    mov    edi, [esp + 24]          ;edi = F
    add    eax, ebx
    add    eax, ecx
    add    eax, edx
    add    eax, esi
    add    eax, edi
    mov    ebx, 0x6
    mov    ecx, [esp + 28]          ;ecx = G
    xor    edx, edx
    add    eax, ecx
    mul    ebx
    mov    [esp + 32], eax          ;H = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:     EAX = decimal_number - H;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = decimal_number
    mov    ebx, [esp + 32]          ;ebx = H
    sub    eax, ebx


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
