;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: vec_max_value
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 12-APR-2015
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
;     REQ EXTERNAL FILES: get_vector_info.asm
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

extern get_vector_info
global vec_max_value

section .text

vec_max_value:

;parameter 1) EAX = @srcMatrix : Matrix (Input Only)
;parameter 2) EBX = flag       : DWORD  (Input Only)
;parameter 3) ECX = index      : DWORD  (Input Only)
;returns 1) XMM0 = maxValue : SCALAR SINGLE-PRECISION

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 24
    mov    [esp     ], eax        ;pSrcMatrix
    mov    [esp +  4], ebx        ;flag
    mov    [esp +  8], ecx        ;index
    mov    dword [esp + 12], 0    ;jumpSize
    mov    dword [esp + 16], 0    ;numOfElements
    mov    dword [esp + 20], 0    ;pDataMat

    ;Done setup local variables

    ;Get jump size, number of elements, and
    ;address of the offsetted data matrix of source matrix
    mov    esi, [esp]             ;ESI = pSrcMatrix
    mov    ebx, [esp +  4]        ;EBX = flag
    mov    ecx, [esp +  8]        ;ECX = index
    call   get_vector_info
    mov    [esp + 12], ebx        ;jumpSize = EBX
    mov    [esp + 16], ecx        ;numOfElements = ECX
    mov    [esp + 20], edi        ;pDataMat = EDI

    mov    esi, [esp + 20]        ;ESI = pDataMat
    mov    ebx, [esp + 12]        ;EBX = jumpSize
    mov    ecx, [esp + 16]        ;ECX = numOfElements

    movss  xmm0, [esi]

.loop:

    movss   xmm1, [esi]
    ucomiss xmm1, xmm0
    jb      .xmm1_lessthan_xmm0

.xmm1_morethan_xmm0:

    movdqa  xmm0, xmm1

.xmm1_lessthan_xmm0:

    add    esi, ebx

    sub    ecx, 1
    jnz    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
