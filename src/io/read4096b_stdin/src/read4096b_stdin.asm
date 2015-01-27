;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: read4096b_stdin
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 21-JAN-2015
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
;             VERSION: 0.1.10
;              STATUS: Alpha
;                BUGS: --- <See doc/bugs/index file>
;
;    REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global read4096b_stdin

section .text

read4096b_stdin:

;parameter 1 = addr_readbuffer:32bit
;parameter 2 = addr_cur_rb_ptr:32bit
;parameter 3 = addr_cur_byte:32bit
;parameter 4 = addr_outdata:32bit
;parameter 5 = addr_outdata_len:32bit
;parameter 6 = flag:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_readbuffer
    mov    ebx, [ebp +  4]          ;get addr_cur_rb_ptr
    mov    ecx, [ebp +  8]          ;get addr_cur_byte
    mov    edx, [ebp + 12]          ;get addr_outdata
    mov    esi, [ebp + 16]          ;get addr_outdata_len
    mov    edi, [ebp + 20]          ;get flag

.setup_localvariables:
    sub    esp, 40                  ;reserve 40 bytes
    mov    [esp     ], eax          ;addr_readbuffer
    mov    [esp +  4], ebx          ;addr_cur_rb_ptr
    mov    [esp +  8], ecx          ;addr_cur_byte
    mov    [esp + 12], edx          ;addr_outdata
    mov    [esp + 16], esi          ;addr_outdata_len
    mov    [esp + 20], edi          ;flag
    mov    dword [esp + 24], 0      ;term1
    mov    dword [esp + 28], 0      ;term2
    mov    dword [esp + 32], 0      ;byte_pos
    mov    dword [esp + 36], 0      ;outdata_len


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   if flag == 1, then goto .flag_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = flag
    cmp    eax, 1
    je     .flag_1


.flag_0:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   term1 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 24], eax          ;term1 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   term2 = 0x20;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x20                ;eax = space character
    mov    [esp + 28], eax          ;term2 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   goto .endflag_checks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .endflag_checks


.flag_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   term1 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 24], eax          ;term1 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   term2 = 0x0a;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x0a                ;eax = newline character
    mov    [esp + 28], eax          ;term2 = eax


.endflag_checks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   byte_pos = addr_cur_byte^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  8]          ;ebx = addr_cur_byte
    mov    eax, [ebx]
    mov    [esp + 32], eax          ;byte_pos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   EDI = addr_outdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    edi, [esp + 12]          ;edi = addr_outdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   if addr_cur_rb_ptr^ == 0, goto .dont_init_ESI
;          .init_ESI:
;   010:       ESI = addr_cur_rb_ptr^;
;              ...
;          .dont_init_ESI:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_cur_rb_ptr
    mov    eax, [ebx]
    cmp    eax, 0
    je     .dont_init_ESI
.init_ESI:
    mov    esi, eax
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   LODSB;
;   012:   -- esi;
;   013:   if al == 0, then goto .rb_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb
    sub    esi, 1
    cmp    al, 0
    je     .rb_empty
.dont_init_ESI:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   if byte_pos == 0, goto .rb_empty;
;   015:   if byte_pos == 128, goto .rb_empty;
;   ???:   goto .rb_not_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 0
    je     .rb_empty

    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 128
    je     .rb_empty

    jmp    .rb_not_empty


.rb_empty:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ???:   reinitialized readbuffer to zero;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    ebx, [esp]               ;ebx = addr_readbuffer
    mov    [ebx       ], eax
    mov    [ebx +    4], eax
    mov    [ebx +    8], eax
    mov    [ebx +   12], eax
    mov    [ebx +   16], eax
    mov    [ebx +   20], eax
    mov    [ebx +   24], eax
    mov    [ebx +   28], eax
    mov    [ebx +   32], eax
    mov    [ebx +   36], eax
    mov    [ebx +   40], eax
    mov    [ebx +   44], eax
    mov    [ebx +   48], eax
    mov    [ebx +   52], eax
    mov    [ebx +   56], eax
    mov    [ebx +   60], eax
    mov    [ebx +   64], eax
    mov    [ebx +   68], eax
    mov    [ebx +   72], eax
    mov    [ebx +   76], eax
    mov    [ebx +   80], eax
    mov    [ebx +   84], eax
    mov    [ebx +   88], eax
    mov    [ebx +   92], eax
    mov    [ebx +   96], eax
    mov    [ebx +  100], eax
    mov    [ebx +  104], eax
    mov    [ebx +  108], eax
    mov    [ebx +  112], eax
    mov    [ebx +  116], eax
    mov    [ebx +  120], eax
    mov    [ebx +  124], eax
    mov    [ebx +  128], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   systemcall read( stdin, addr_readbuffer, 128 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x03                ;systemcall read
    xor    ebx, ebx                 ;fd  = stdin
    mov    ecx, [esp]               ;dst = addr_readbuffer
    mov    edx, 128                 ;len = 128
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   addr_cur_byte^ = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 8]           ;ebx = addr_cur_byte
    xor    eax, eax                 ;eax = 0
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   addr_cur_rb_ptr^ = addr_readbuffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp    ]           ;eax = addr_readbuffer
    mov    ebx, [esp + 4]           ;ebx = addr_cur_rb_ptr
    mov    [ebx], eax               ;ebx^ = eax

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   byte_pos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 32], eax          ;byte_pos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   ESI = addr_readbuffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    esi, [esp]               ;esi = addr_readbuffer
    cld


.rb_not_empty:

.loop_getdata:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   LODSB;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lodsb


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:   ++ byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = byte_pos
    add    ebx, 1
    mov    [esp + 32], ebx          ;byte_pos = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   if AL == term1, then goto .endloop_getdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 24]          ;ebx = term1
    cmp    al, bl
    je     .endloop_getdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   if AL == term2, then goto .endloop_getdata;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = term2
    cmp    al, bl
    je     .endloop_getdata


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   EDI^ = AL; 
;   026:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [edi], al
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:   ++ outdata_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = outdata_len
    add    eax, 1
    mov    [esp + 36], eax          ;outdata_len = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   if byte_pos == 128, goto .fill_rb;
;   029:   goto .loop_getdata;
;          .fill_rb:
;   ???:       goto .rb_empty;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    cmp    eax, 128
    je     .rb_empty

    jmp    .loop_getdata
.fill_rb:
    jmp    .rb_empty


.endloop_getdata:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:   addr_cur_rb_ptr^ = ESI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 4]           ;ebx = addr_cur_rb_ptr
    mov    [ebx], esi               ;ebx^ = esi


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:   addr_cur_byte^ = byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = byte_pos
    mov    ebx, [esp +  8]          ;ebx = addr_cur_byte
    mov    [ebx], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   032:   addr_outdata_len^ = outdata_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36] ;eax = outdata_len
    mov    ebx, [esp + 16] ;ebx = addr_outdata_len
    mov    [ebx], eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
