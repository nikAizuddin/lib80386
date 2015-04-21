;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: mat_normalize_0_1
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
;     REQ EXTERNAL FILES: vec_normalize_0_1.asm
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

extern vec_normalize_0_1
global mat_normalize_0_1

section .text

mat_normalize_0_1:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = @dstMatrix : Matrix (Input and Output)
;parameter 3) ECX = flag       : DWORD  (Input Only)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 16
    mov    [esp     ], eax        ;pSrcMatrix
    mov    [esp +  4], ebx        ;pDstMatrix
    mov    [esp +  8], ecx        ;flag
    mov    dword [esp + 12], 0    ;i

    ;Done setup local variables

    ;Check flag, normalize by row or column?
    test   ecx, ecx
    jnz    .norm_by_column

.norm_by_row:
    ;EDI = pSrcMatrix.numOfRows
    mov    edi, [esp]             ;EDI = pSrcMatrix.numOfRows
    mov    edi, [edi]
    mov    [esp + 12], edi        ;i = EDI
.loop_norm_by_row:
    mov    edi, [esp + 12]        ;EDI = i
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp +  4]        ;EBX = pDstMatrix
    mov    ecx, 0b00
    sub    edi, 1
    mov    [esp + 12], edi        ;i = EDI
    mov    edx, edi
    mov    esi, edi
    call   vec_normalize_0_1
    mov    edi, [esp + 12]        ;EDI = i
    test   edi, edi
    jnz    .loop_norm_by_row
.endloop_norm_by_row:
    jmp    .clean_stackframe


.norm_by_column:
    ;EDI = pSrcMatrix.numOfColumns
    mov    edi, [esp]             ;EDI = pSrcMatrix
    add    edi, (1*4)             ;EDI = .numOfColumns
    mov    edi, [edi]
    mov    [esp + 12], edi        ;i = EDI
.loop_norm_by_column:
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp +  4]        ;EBX = pDstMatrix
    mov    ecx, 0b11
    sub    edi, 1
    mov    [esp + 12], edi        ;i = EDI
    mov    edx, edi
    mov    esi, edi
    call   vec_normalize_0_1
    mov    edi, [esp + 12]        ;EDI = i
    test   edi, edi
    jnz    .loop_norm_by_column
.endloop_norm_by_column:


.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
