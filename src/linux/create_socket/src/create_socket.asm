;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: create_socket
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 19-MARCH-2015
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

global create_socket

section .text

create_socket:

;parameter 1 = protocol_family:EAX
;parameter 2 = socket_type:EBX
;parameter 3 = protocol_used:ECX
;returns = socket_descriptor:EAX

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.setup_localvariables:
    sub    esp, 12                  ;reserve 12 bytes
    mov    [esp     ], eax          ;socket_args[0] = protocol_family
    mov    [esp +  4], ebx          ;socket_args[1] = socket_type
    mov    [esp +  8], ecx          ;socket_args[2] = protocol_used

;SOCKETCALL( CALL_SOCKET, @socket_args )
    mov    eax, 102                 ;SOCKETCALL
    mov    ebx, 1                   ;CALL_SOCKET
    lea    ecx, [esp]
    int    0x80

;EXIT(-1), if the SOCKETCALL() returns negative
;Otherwise, continue the program
    test    eax, eax
    js      .fail
    jmp     .success

.fail:

;EXIT(-1)
    mov    eax, 1                   ;EXIT()
    mov    ebx, -1
    int    0x80

.success:

.return:

.clean_stackframe:
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
