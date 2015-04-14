;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_normalize_0_1
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 13-APR-2015
;
;       CONTRIBUTORS: ---
;
;           LANGUAGE: x86 Assembly Language
;             SYNTAX: Intel
;          ASSEMBLER: NASM
;       ARCHITECTURE: i386
;             KERNEL: Linux 32-bit
;             FORMAT: elf32
;
;     EXTERNAL FILES: vec_max_absvalue
;
;            VERSION: 0.1.0
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

extern vec_max_absvalue
global vec_normalize_0_1

section .text

vec_normalize_0_1:

;parameter 1) addr_srcVec:ESI
;parameter 2) addr_dstVec:EDI
;parameter 3) vec_jumpSize:EBX
;parameter 4) numOfElements:ECX
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 16
    mov    [esp     ], esi    ;addr_srcVec
    mov    [esp +  4], edi    ;addr_dstVec
    mov    [esp +  8], ebx    ;vec_jumpSize
    mov    [esp + 12], ecx    ;numOfElements

    ;Find maximum absolute value in the vector.
    ;Note: Parameters for vec_max_absvalue() is already set.
    call   vec_max_absvalue

    ;XMM0 = maximum absolute value of the vector

    mov    esi, [esp     ]    ;ESI = addr_srcVec
    mov    ecx, [esp + 12]    ;ECX = numOfElements

.loop_normalize:

    movss   xmm1, [esi]
    divss   xmm1, xmm0
    movss   [edi], xmm1

    add    esi, ebx
    add    edi, ebx

    sub    ecx, 1
    jnz    .loop_normalize

.endloop_normalize:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
