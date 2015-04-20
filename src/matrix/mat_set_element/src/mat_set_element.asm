;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: mat_set_element
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 21-APR-2015
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

global mat_set_element

section .text

mat_set_element:

;parameter 1) EAX = @srcMatrix  : Matrix (Input Only)
;parameter 2) EBX = rowIndex    : DWORD  (Input Only)
;parameter 3) ECX = columnIndex : DWORD  (Input Only)
;parameter 4) XMM0 = setElement : SCALA SINGLE-PRECISION (Input Only)

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 12
    mov    [esp     ], eax        ;pSrcMatrix
    mov    [esp +  4], ebx        ;rowIndex
    mov    [esp +  8], ecx        ;columnIndex

    ;Done setting up local variables

    mov    esi, [esp]             ;ESI = pSrcMatrix
    add    esi, (4*4)             ;ESI = .pData
    mov    esi, [esi]

    ;EBX = rowIndex * pSrcMatrix.rowSize
    mov    eax, [esp]             ;EAX = pSrcMatrix
    add    eax, (3*4)             ;EAX = .rowSize
    mov    eax, [eax]
    mul    ebx
    mov    ebx, eax

    ;ECX = columnIndex * pSrcMatrix.columnSize
    mov    eax, [esp]             ;EAX = pSrcMatrix
    add    eax, (2*4)             ;EAX = .columnSize
    mov    eax, [eax]
    mul    ecx
    mov    ecx, eax

    ;ESI += EBX + ECX
    add    esi, ebx
    add    esi, ecx

    ;[ESI] = XMM0
    movss  [esi], xmm0

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
