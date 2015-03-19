;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                          *** TEST ***
;
;---------------------------------------------------------------------
;
;           AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;     DATE CREATED: 19-MARCH-2015
;
;     TEST PURPOSE: Make sure create_socket have no errors.
;
;         LANGUAGE: x86 Assembly Language
;           SYNTAX: Intel
;        ASSEMBLER: NASM
;     ARCHITECTURE: i386
;           KERNEL: Linux 32-bit
;           FORMAT: elf32
;
;   EXTERNAL FILES: create_socket.asm
;
;=====================================================================

extern create_socket
global _start

section .bss

    socket_descriptor:    resd 1

section .text

_start:

;EAX = create_socket( PF_LOCAL, SOCK_STREAM, IPPROTO_IP )
    mov    eax, 1  ;protocol_family = PF_LOCAL
    mov    ebx, 1  ;socket_type = SOCK_STREAM
    mov    ecx, 0  ;protocol_used = IPPROTO_IP
    call   create_socket
    mov    [socket_descriptor], eax

exit:

;EXIT(0)
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
