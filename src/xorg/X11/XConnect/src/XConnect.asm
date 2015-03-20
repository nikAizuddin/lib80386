;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: XConnect
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 20-MARCH-2015
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

global XConnect

section .text

XConnect:

;parameter 1 = socket_descriptor:EAX
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.setup_localvariables:
    sub    esp, 36                  ;reserve 36 bytes
    mov    word  [esp     ], 1      ;address_family = AF_LOCAL
    mov    dword [esp +  2], "/tmp" ;contact file
    mov    dword [esp +  6], "/.X1"
    mov    dword [esp + 10], "1-un"
    mov    dword [esp + 14], "ix/X"
    mov    byte  [esp + 18], "0"
    mov    byte  [esp + 19], 0
    mov    [esp + 24], eax          ;socket_args[0] = socket_descrip.
    mov    [esp + 28], esp          ;socket_args[1] = @contact
    mov    dword [esp + 32], 20     ;socket_args[2] = contact size


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   SOCKETCALL( CALL_CONNECT, @socket_args )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, 102                 ;SOCKETCALL
    mov    ebx, 3                   ;CALL_CONNECT
    lea    ecx, [esp + 24]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   EXIT(-1), if the SOCKETCALL() returns negative
;   Otherwise, continue the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    test    eax, eax
    js      .fail
    jmp     .success
.fail:
    mov    eax, 1
    mov    ebx, -1
    int    0x80
.success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set TCP socketX to non-blocking mode.
;   By default, TCP sockets are in blocking mode. It is important
;   to use a non-blocking socket.
;
;   If TCP socket in blocking mode, when system call read is used to
;   read data from the socket, the program waits for resources, if
;   the resources are unavailable.
;
;   If TCP socket in non-blocking mode, the program does not wait
;   for resources if they are unavailable.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   FCNTL64( socket_descriptor, F_SETFL, O_RDWR | O_NONBLOCK )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, 221                ;FCNTL64
    mov    ebx, [esp + 24]         ;socket_descriptor
    mov    ecx, 4                  ;F_SETFL
    lea    edx, [0q0002+0q4000]    ;O_RDWR | O_NONBLOCK
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check to make sure the socket is properly set to non-blocking mode
;   EXIT(-1) if the FCNTL64() returns negative
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    test   eax, eax
    js     set_nonBlocking_fail
    jmp    set_nonBlocking_success
set_nonBlocking_fail:
    mov    eax, 1
    mov    ebx, -1
    int    0x80
set_nonBlocking_success:


.return:

.clean_stackframe:
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
