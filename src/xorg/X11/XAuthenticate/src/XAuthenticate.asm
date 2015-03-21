;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: XAuthenticate
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

; --- CONSTANTS ---
READ    equ 3
WRITE   equ 4
POLL    equ 168
POLLIN  equ 0x001
POLLOUT equ 0x004
; -----------------

global XAuthenticate

section .text

XAuthenticate:

;parameter 1 = socket_descriptor:EAX
;parameter 2 = addr_additionalData:EBX
;returns = status:EAX

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.setup_localvariables:
    sub    esp, 40                  ;reserve 40 bytes
    mov    [esp     ], eax          ;socket_descriptor
    mov    [esp +  4], ebx          ;addr_additionalData
    mov    [esp +  8], eax          ;poll.fd = socket_descriptor
    mov    word [esp + 12], 0       ;poll.events
    mov    word [esp + 14], 0       ;poll.revents
    mov    word [esp + 16], 0x6c    ;authenticateRequest.byteOrder
    mov    word [esp + 18], 11      ;authenticateRequest.majorVersion
    mov    word [esp + 20], 0       ;authenticateRequest.minorVersion
    mov    word [esp + 22], 0       ;authenticateRequest.nbytesAuthP.
    mov    word [esp + 24], 0       ;authenticateRequest.nbytesAuthS.
    mov    word [esp + 26], 0       ;unused
    mov    dword [esp + 28], 0      ;authenticateStatus
    mov    word [esp + 32], 0       ;header.majorVersion
    mov    word [esp + 34], 0       ;header.minorVersion
    mov    dword [esp + 36], 0      ;header.lengthAddData


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Make sure X Server is ready to receive requests
;   POLL( {socket_descriptor, POLLOUT}, 1, INFINITE_TIMEOUT );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    word [esp + 12], POLLOUT

    mov    eax, POLL
    lea    ebx, [esp + 8]           ;ebx = @poll
    mov    ecx, 1
    mov    edx, -1
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Request connection authentication with X Server; 
;   WRITE( socket_descriptor, @authenticateRequest, requestLength );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, WRITE
    mov    ebx, [esp +  8]          ;ebx = socket_descriptor
    lea    ecx, [esp + 16]          ;ecx = @authenticateRequest
    mov    edx, 12
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Wait for X Server to process the requests;
;   POLL( {socket_descriptor, POLLIN}, 1, INFINITE_TIMEOUT );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    word [esp + 12], POLLIN  ;poll.events = POLLIN

    mov    eax, POLL                ;POLL()
    lea    ebx, [esp +  8]          ;ebx = @poll
    mov    ecx, 1
    mov    edx, -1
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the first 2 bytes of data, to check success/fail;
;   READ( socket_descriptor, @authenticateStatus, 2 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, READ
    mov    ebx, [esp     ]          ;ebx = socket_descriptor
    lea    ecx, [esp + 28]          ;ecx = authenticateStatus
    mov    edx, 2
    int    0x80

    
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## If authentication fail, return -1
;   ## Else, receive another 6 bytes of header for additional data
;   if authenticateStatus != 1, return -1;
;   else, READ( socket_descriptor, @header, 6 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [esp + 28]          ;eax = authenticateStatus
    cmp    eax, 1
    jne    .authenticationFail
    jmp    .authenticationSuccess

.authenticationFail:

    mov    eax, -1
    jmp    .return

.authenticationSuccess:

    mov    eax, READ
    mov    ebx, [esp     ]          ;ebx = socket_descriptor
    lea    ecx, [esp + 32]          ;ecx = @header
    mov    edx, 6
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ## Receive the additional data
;   READ( socket_descriptor,
;         addr_additionalData,
;         header.lengthAddData * 4 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, READ
    mov    ebx, [esp     ]          ;ebx = socket_descriptor
    mov    ecx, [esp +  4]          ;ecx = addr_additionalData
    mov    edx, [esp + 36]          ;edx = header.lengthAddData
    lea    edx, [edx * 4]           ;edx = header.lengthAddData * 4
    int    0x80


    mov    eax, 0

.return:

.clean_stackframe:
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
