;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: cvt_string2int
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 20/JAN/2015
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
;      EXTERNAL FILES: pow_int.asm
;                      cvt_string2dec.asm
;                      cvt_dec2hex.asm
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

extern pow_int
extern cvt_string2dec
extern cvt_dec2hex
global cvt_string2int

section .text

cvt_string2int:

;parameter 1 = addr_instring:32bit
;parameter 2 = instrlen:32bit
;parameter 3 = addr_integer_num:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_instring
    mov    ebx, [ebp +  4]          ;get instrlen
    mov    ecx, [ebp +  8]          ;get addr_integer_num

.setup_localvariables:
    sub    esp, 32                  ;reserve 32 bytes
    mov    [esp     ], eax          ;addr_instring
    mov    [esp +  4], ebx          ;instrlen
    mov    [esp +  8], ecx          ;addr_integer_num
    mov    dword [esp + 12], 0      ;decimal_num[0]
    mov    dword [esp + 16], 0      ;decimal_num[1]
    mov    dword [esp + 20], 0      ;decimal_digits
    mov    dword [esp + 24], 0      ;hexadecimal_num[0]
    mov    dword [esp + 28], 0      ;hexadecimal_num[1]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     cvt_string2dec( addr_instring,
;                            instrlen,
;                            @decimal_num,
;                            @decimal_digits );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp +  16      ]   ;get addr_instring
    mov    ebx, [esp + (16 +  4)]   ;get instrlen
    lea    ecx, [esp + (16 + 12)]   ;get @decimal_num
    lea    edx, [esp + (16 + 20)]   ;get @decimal_digits
    mov    [esp     ], eax          ;parameter 1
    mov    [esp +  4], ebx          ;parameter 2
    mov    [esp +  8], ecx          ;parameter 3
    mov    [esp + 12], edx          ;parameter 4
    call   cvt_string2dec
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:     hexadecimal_num[0] = cvt_dec2hex( decimal_num[0] );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + (4 + 12)]    ;get decimal_num[0]
    mov    [esp    ], eax           ;parameter 1
    call   cvt_dec2hex
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 24], eax          ;hexadecimal_num[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:     if decimal_digits <= 8, then goto .digits_le_8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = decimal_digits
    cmp    eax, 8
    jbe    .digits_le_8


.digits_gt_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:         hexadecimal_num[1] = cvt_dec2hex( decimal_num[1] );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + (4 + 16)]    ;get decimal_num[1]
    mov    [esp    ], eax           ;parameter 1
    call   cvt_dec2hex
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;hexadecimal_num[1] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:         hexadecimal_num[0] = (hexadecimal_num[1] *
;                                     pow_int(10, decimal_digits-2)) + 
;                                     hexadecimal_num[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;parameter1 = 10
    mov    ebx, [esp + (8 + 20)]    ;get (decimal_digits - 2)
    sub    ebx, 2
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
                                    ;NOTE: eax = result pow_int()

    mov    ebx, [esp + 28]          ;ebx = hexadecimal_num[1]
    xor    edx, edx
    mul    ebx                      ;eax *= ebx

    mov    ebx, [esp + 24]          ;ebx = hexadecimal_num[0]
    add    eax, ebx                 ;eax += ebx

    mov    [esp + 24], eax          ;hexadecimal_num[0] = eax


.digits_le_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:     addr_integer_num^ = hexadecimal_num[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = hexadecimal_num[0]
    mov    ebx, [esp +  8]          ;ebx = addr_integer_num
    mov    [ebx], eax               ;ebx^ = eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
