;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: cvt_string2double
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 22-JAN-2015
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
;      EXTERNAL FILES: pow_int.asm,
;                      find_int_digits.asm,
;                      cvt_string2int.asm,
;                      cvt_string2dec.asm,
;                      cvt_dec2hex.asm
;
;             VERSION: 0.1.10
;              STATUS: Alpha
;                BUGS: --- <See doc/bugs/index file>
;
;    REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

extern pow_int
extern find_int_digits
extern cvt_string2int
extern cvt_string2dec
extern cvt_dec2hex
global cvt_string2double

section .text

cvt_string2double:

;parameter 1 = addr_instring:32bit
;parameter 2 = instrlen:32bit
;returns = double precision value (ST0)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_instring
    mov    ebx, [ebp +  4]          ;get instrlen

.setup_localvariables:
    sub    esp, 56                  ;reserve 56 bytes
    mov    [esp     ], eax          ;addr_instring
    mov    [esp +  4], ebx          ;instrlen
    mov    dword [esp +  8], 0      ;intpt_str[0]
    mov    dword [esp + 12], 0      ;intpt_str[1]
    mov    dword [esp + 16], 0      ;intpt_str[2]
    mov    dword [esp + 20], 0      ;intpt_strlen
    mov    dword [esp + 24], 0      ;intpt_int
    mov    dword [esp + 28], 0      ;decpt_str[0]
    mov    dword [esp + 32], 0      ;decpt_str[1]
    mov    dword [esp + 36], 0      ;decpt_str[2]
    mov    dword [esp + 40], 0      ;decpt_strlen
    mov    dword [esp + 44], 0      ;decpt_int
    mov    dword [esp + 48], 0      ;decs
    mov    dword [esp + 52], 0      ;heading_zeroes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Separate string into ASCII integer part and
;   ASCII decimal part.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   ESI = addr_string;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    esi, [esp]               ;esi = addr_string


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   AL = ESI;
;   003:   if AL != 0x2d, goto .positive;
;          .negative:
;   004:       is_negative = 1;
;   005:       ++ ESI;
;          .positive:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    al, [esi]
    cmp    al, 0x2d
    jne    .positive
.negative:
    mov    eax, 1
    mov    [esp + 56], eax          ;is_negative = eax
    add    esi, 1
.positive:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   EDI = @intpt_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    edi, [esp + 8]           ;edi = @intpt_str


.loop_get_intpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   LODSB;
;   008:   if AL == 0x2e, goto .endloop_get_intpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    cmp    al, 0x2e
    je     .endloop_get_intpt


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   EDI^ = AL;
;   010:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   ++ intpt_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = intpt_strlen
    add    eax, 1
    mov    [esp + 20], eax          ;intpt_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   goto .loop_get_intpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_intpt


.endloop_get_intpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   EDI = @decpt_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    edi, [esp + 28]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          .loop_count_heading_zeroes:
;   014:       LODSB;
;   015:       if AL != 0x30, goto .endloop_count_heading_zeroes;
;   016:       ++ heading_zeroes;
;   017:       goto .loop_count_heading_zeroes;
;          .endloop_count_heading_zeroes:
;   018:   -- ESI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ecx, [esp + 52]          ;ecx = heading_zeroes
.loop_count_heading_zeroes:
    lodsb
    cmp    al, 0x30
    jne    .endloop_count_heading_zeroes
    add    ecx, 1
    jmp    .loop_count_heading_zeroes
.endloop_count_heading_zeroes:
    mov    [esp + 52], ecx          ;heading_zeroes = ecx
    sub    esi, 1


.loop_get_decpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   LODSB;
;   020:   if AL == 0x00, goto .endloop_get_decpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    cmp    al, 0x00
    je     .endloop_get_decpt


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   EDI^ = AL;
;   022:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   ++ decpt_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = decpt_strlen
    add    eax, 1
    mov    [esp + 40], eax          ;decpt_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   goto .loop_get_decpt;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_decpt


.endloop_get_decpt:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert intpt_str into intpt_int, and
;   decpt_str into decpt_int.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   intpt_int = cvt_string2int( @intpt_str, intpt_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [esp + (8 +  8)]    ;get @intpt_str
    mov    ebx, [esp + (8 + 20)]    ;get intpt_strlen
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 24], eax          ;intpt_int = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   decpt_int = cvt_string2int( @decpt_str, decpt_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    lea    eax, [esp + (8 + 28)]    ;get @decpt_str
    mov    ebx, [esp + (8 + 40)]    ;get decpt_strlen
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   cvt_string2int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 44], eax          ;decpt_int = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:   decs = pow_int( 10,
;                 heading_zeroes + find_int_digits(decpt_int,0) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + (8 + 44)]    ;get decpt_int
    xor    ebx, ebx                 ;flag = 0 (unsigned)
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   find_int_digits
    add    esp, 8                   ;restore 8 bytes
                                    ;eax = find_int_digits()

    mov    ebx, [esp + 52]          ;ebx = heading_zeroes
    add    eax, ebx
    mov    [esp + 48], eax          ;decs = eax

    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;get base = 10
    mov    ebx, [esp + (8 + 48)]    ;get power = decs
    mov    [esp    ], eax           ;parameter 1
    mov    [esp + 4], ebx           ;parameter 2
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 48], eax          ;decs = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   push decs to FPU;
;   029:   push decpt_int to FPU;
;   030:   FDIV ST1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 48]         ;push decs to fpu
    fild   dword [esp + 44]         ;push decpt_int to fpu
    fdiv   st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Merge intpt_int and decpt_int into
;   IEEE double precision format.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:   push intpt_int;
;   032:   FADD ST1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 24]         ;push intpt_int to fpu
    fadd   st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   033:   if is_negative == 0, goto .is_positive;
;          .is_negative:
;   034:       FCHS
;          .is_positive:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = is_negative
    cmp    eax, 0
    je     .is_positive
.is_negative:
    fchs                            ;fpu change sign
.is_positive:


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
