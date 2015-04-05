;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: loadpgm
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 21-MARCH-2015
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
;             VERSION: 0.1.1
;              STATUS: Alpha
;                BUGS: --- <See doc/bugs/index file>
;
;    REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

; --- CONSTANTS ---
OPEN     equ 5
CLOSE    equ 6
READ     equ 3
O_RDONLY equ 0q0000
; -----------------

global loadpgm

section .text

loadpgm:

;parameter 1 = addr_filename:EAX
;parameter 2 = width:EBX
;parameter 3 = height:ECX
;parameter 4 = addr_data:EDX
;returns = 0 if success. Otherwise, -1 (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.setup_localvariables:
    sub    esp, 24                  ;reserve 24 bytes
    mov    [esp     ], eax          ;addr_filename
    mov    [esp +  4], ebx          ;width
    mov    [esp +  8], ecx          ;height
    mov    [esp + 12], edx          ;addr_data
    mov    dword [esp + 16], 0      ;fd
    mov    dword [esp + 20], 0      ;c


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Open the file
;   fd = OPEN(addr_filename, O_RDONLY);
;   If(fd == -1) Return -1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, OPEN
    mov    ebx, [esp]
    mov    ecx, O_RDONLY
    int    0x80

    test   eax, eax
    js     .open_fail
    jmp    .open_success

.open_fail:

    mov    eax, -1
    jmp    .return

.open_success:

    mov    [esp + 16], eax          ;fd = OPEN()


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Skip 0x0A 3 times, to get the pixel data
;   While(c != 0x0A) READ(fd, @c, 1);
;   While(c != 0x0A) READ(fd, @c, 1);
;   While(c != 0x0A) READ(fd, @c, 1);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    esi, 3

.skip_0x0a:

    mov    eax, READ
    mov    ebx, [esp + 16]          ;ebx = fd
    lea    ecx, [esp + 20]          ;ecx = @c
    mov    edx, 1
    int    0x80

    mov    eax, [esp + 20]          ;eax = c
    cmp    eax, 0x0a
    jne    .skip_0x0a

    sub    esi, 1
    jnz    .skip_0x0a


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Read the pixel data
;   READ(fd, addr_data, width*height);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [esp +  4]          ;eax = width
    mov    ebx, [esp +  8]          ;ebx = height
    xor    edx, edx
    mul    ebx
    mov    edx, eax                 ;edx = width * height

    mov    eax, READ
    mov    ebx, [esp + 16]          ;ebx = fd
    mov    ecx, [esp + 12]          ;ecx = addr_data
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Close the file
;   CLOSE(fd);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, CLOSE
    mov    ebx, [esp + 16]          ;ebx = fd
    int    0x80


    mov    eax, 0
.return:

.clean_stackframe:
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
