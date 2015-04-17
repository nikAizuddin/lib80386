;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: get_vector_info
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 17-APR-2015
;
;           CONTRIBUTORS: ---
;
;               LANGUAGE: x86 Assembly Language
;                 SYNTAX: Intel
;              ASSEMBLER: NASM
;           ARCHITECTURE: i386
;                 KERNEL: Linux 32-bit
;                 FORMAT: elf32
;
;     REQ EXTERNAL FILES: ---
;
;                VERSION: 0.1.0
;                 STATUS: Alpha
;                   BUGS: --- <See doc/bugs/index file>
;
;       REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global get_vector_info

section .text

get_vector_info:

;parameter 1) ESI = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = flag       : DWORD  (Input Only)
;parameter 3) ECX = index      : DWORD  (Input Only)

;returns 1) EBX = jumpSize      : DWORD
;returns 2) ECX = numOfElements : DWORD
;returns 3) EDI = offset        : DWORD

    ;Check whether to use row vector or column vector
    ;operation.
    test   ebx, ebx
    jz     .is_row_vector

.is_column_vector:
    mov    ebx, esi           ;EBX = pSrcMatrix
    add    ebx, (3*4)         ;EBX = .rowSize
    mov    ebx, [ebx]
    mov    eax, esi           ;EAX = pSrcMatrix
    add    eax, (2*4)         ;EAX = .columnSize
    mov    eax, [eax]
    mul    ecx                ;EAX = index * columnSize
    mov    edx, eax           ;EDX = EAX
    mov    ecx, esi           ;ECX = pSrcMatrix.numOfRows
    mov    ecx, [ecx]
    mov    edi, esi           ;EDI = pSrcMatrix
    add    edi, (4*4)         ;EDI = .pData
    mov    edi, [edi]
    add    edi, edx           ;EDI += index
    ret

.is_row_vector:
    mov    ebx, esi           ;EBX = pSrcMatrix
    add    ebx, (2*4)         ;EBX = .columnSize
    mov    ebx, [ebx]
    mov    eax, esi           ;EAX = pSrcMatrix
    add    eax, (3*4)         ;EAX = .rowSize
    mov    eax, [eax]
    mul    ecx                ;EAX = index * rowSize
    mov    edx, eax           ;EDX = EAX
    mov    ecx, esi           ;ECX = pSrcMatrix
    add    ecx, (1*4)         ;ECX = .numOfColumns
    mov    ecx, [ecx]
    mov    edi, esi           ;EDI = pSrcMatrix
    add    edi, (4*4)         ;EDI = .pData
    mov    edi, [edi]
    add    edi, edx           ;EDI += index
    ret
