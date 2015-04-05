;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: euclidean_norm
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 04-APR-2015
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
;      INCLUDE FILES: ---
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

global euclidean_norm

section .text

euclidean_norm:

;parameter 1) addr_srcVector:EAX
;parameter 3) elementSize:EBX
;parameter 2) numOfElements:ECX 
;returns result:XMM0

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 16
    mov    [esp     ], eax          ;addr_srcVector
    mov    [esp +  4], ebx          ;elementSize
    mov    [esp +  8], ecx          ;numOfElements
    mov    dword [esp + 12], 0b01111111111111111111111111111111

    mov    esi, eax
    pxor   xmm2, xmm2
    movss  xmm1, [esp + 12]         ;XMM1 = sign remover

.loop:

    movss  xmm0, [esi]              ;XMM0 = X[ecx]
    andps  xmm0, xmm1               ;XMM0 = |XMM0|
    mulss  xmm0, xmm0               ;pow(XMM0,2)
    addss  xmm2, xmm0               ;XMM2 += XMM0

    add    esi, ebx                 ;ESI += elementSize

    sub    ecx, 1
    jnz    .loop

.endloop:

    sqrtss xmm0, xmm2               ;XMM0 = sqrt(XMM2)

.return:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
