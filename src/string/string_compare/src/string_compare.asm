;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: string_compare
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

global string_compare

section .text

string_compare:

;parameter 1 = addr_source:32bit
;parameter 2 = addr_destination:32bit
;parameter 3 = bytes_to_compare:32bit
;returns = 1 if equals. Otherwise, 0 if not equal.

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    esi, [ebp     ]          ;get addr_source
    mov    edi, [ebp +  4]          ;get addr_destination
    mov    ecx, [ebp +  8]          ;get bytes_to_compare


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     ESI = addr_source;
;   002:     EDI = addr_destination;
;   003:     ECX = bytes_to_compare;
;
;   (Already filled in .get_arguments)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    cld


.loop_compare:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:         CMPSB;
;   005:         if !=, goto .not_equal;
;   006:         -- ECX;
;   007:         if ECX != 0, goto .loop_compare;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmpsb
    jne    .not_equal
    sub    ecx, 1
    jne    .loop_compare


.endloop_compare:


.equal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:         EAX = 1;
;   009:         return;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 1
    jmp    .return

.not_equal:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:         EAX = 0;
;   011:         return;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
