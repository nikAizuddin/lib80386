;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: cvt_string2dec
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 12-NOV-2014
;
;       CONTRIBUTORS: ---
;
;           LANGUAGE: x86 Assembly Language
;             SYNTAX: Intel
;          ASSEMBLER: NASM
;       ARCHITECTURE: i386
;             KERNEL: Linux 32-bit
;             FORMAT: elf32
;
;     EXTERNAL FILES: ---
;
;            VERSION: 0.1.0
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global cvt_string2dec

section .text

cvt_string2dec:

;parameter 1 = addr_string:32bit
;parameter 2 = strlen:32bit
;parameter 3 = addr_decimal:32bit
;parameter 4 = addr_digits:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_parameters:
    add    ebp, 8                   ;+8 offset to get parameters
    mov    eax, [ebp     ]          ;get addr_string
    mov    ebx, [ebp +  4]          ;get strlen
    mov    ecx, [ebp +  8]          ;get addr_decimal
    mov    edx, [ebp + 12]          ;get addr_digits

.set_localvariables:
    sub    esp, 48                  ;reserve 48 bytes
    mov    [esp     ], eax          ;addr_string
    mov    [esp +  4], ebx          ;strlen
    mov    [esp +  8], ecx          ;addr_decimal
    mov    [esp + 12], edx          ;addr_digits
    mov    dword [esp + 16], 0      ;in_ptr
    mov    dword [esp + 20], 0      ;in_buffer
    mov    dword [esp + 24], 0      ;out_ptr
    mov    dword [esp + 28], 0      ;out_buffer
    mov    dword [esp + 32], 0      ;out_bitpos
    mov    dword [esp + 36], 0      ;decimal_number
    mov    dword [esp + 40], 0      ;digits
    mov    dword [esp + 44], 0      ;i


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   in_ptr = addr_string;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_string
    mov    [esp + 16], eax          ;in_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   in_buffer = in_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    mov    ebx, [eax]
    mov    [esp + 20], ebx          ;in_buffer = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   i = strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    mov    [esp + 44], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   if strlen > 8, then
;              goto .decimal_num_2_blocks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    mov    ebx, 8                   ;ebx = 8
    cmp    eax, ebx
    jg     .decimal_num_2_blocks


.decimal_num_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   out_bitpos = (strlen - 1) * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   out_ptr = addr_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_decimal
    mov    [esp + 24], eax          ;out_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   goto .loop_get_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .loop_get_decimal


.decimal_num_2_blocks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   out_bitpos = (strlen - 9) * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  4]          ;eax = strlen
    sub    eax, 9
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   out_ptr = addr_decimal + 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_decimal
    mov    ebx, 4
    add    eax, ebx                 ;eax += ebx
    mov    [esp + 24], eax          ;out_ptr = eax


.loop_get_decimal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if in_buffer is empty
;
;   010:   if in_buffer != 0, then
;              goto .in_buffer_not_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    cmp    eax, 0
    jne    .in_buffer_not_empty


.in_buffer_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   in_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    add    eax, 4
    mov    [esp + 16], eax          ;in_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   in_buffer = in_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = in_ptr
    mov    ebx, [eax]
    mov    [esp + 20], ebx          ;in_buffer = ebx


.in_buffer_not_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if out_buffer is full
;
;   013:   if out_bitpos == -4, then
;              goto .out_buffer_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32] ;eax = out_bitpos
    cmp    eax, -4
    jne    .out_buffer_not_full


.out_buffer_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   out_ptr^ = out_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = out_buffer
    mov    ebx, [esp + 24]          ;ebx = out_ptr
    mov    [ebx], eax               ;ebx^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   out_ptr -= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = out_ptr
    sub    eax, 4                   ;eax -= 4
    mov    [esp + 24], eax          ;out_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   out_buffer = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 28], eax          ;out_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   out_bitpos = 28;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 28
    mov    [esp + 32], eax          ;out_bitpos = eax


.out_buffer_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get a decimal number from the in_buffer
;
;   018:   decimal_number = in_buffer & 0x0000000f;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    and    eax, 0x0000000f
    mov    [esp + 36], eax          ;decimal_number = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   in_buffer >>= 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = in_buffer
    shr    eax, 8                   ;eax >>= 8
    mov    [esp + 20], eax          ;in_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the decimal number into out_buffer
;
;   020:   out_buffer |= decimal_number << out_bitpos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = decimal_number
    mov    ecx, [esp + 32]          ;ecx = out_bitpos
    shl    eax, cl
    mov    ebx, [esp + 28]          ;ebx = out_buffer
    or     eax, ebx
    mov    [esp + 28], eax          ;out_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   out_bitpos -= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = out_bitpos
    sub    eax, 4                   ;eax -= 4
    mov    [esp + 32], eax          ;out_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:   ++digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp+ 40]           ;eax = digits
    add    eax, 1
    mov    [esp + 40], eax          ;digits = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   --i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = i
    sub    eax, 1                   ;eax -= 1
    mov    [esp + 44], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   if i != 0, then
;              goto .loop_get_decimal;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = i
    cmp    eax, 0
    jne    .loop_get_decimal


.endloop_get_decimal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the out_buffer is saved to addr_decimal^
;
;   025:   out_ptr^ = out_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = out_buffer
    mov    ebx, [esp + 24]          ;ebx = out_ptr
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   addr_digits^ = digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = digits
    mov    ebx, [esp + 12]          ;ebx = addr_digits
    mov    [ebx], eax               ;ebx^ = eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to parameters
    mov    esp, ebp                 ;restore esp to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
