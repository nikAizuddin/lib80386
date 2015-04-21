;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: eigen
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
;         EXTERNAL FILES: qr_decomposition.asm
;                         mat_copy.asm
;                         mat_multiply.asm
;                         mat_diagonal.asm
;                         mat_normalize_0_1.asm
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

extern qr_decomposition
extern mat_copy
extern mat_multiply
extern mat_diagonal
extern mat_normalize_0_1
global eigen

section .text

eigen:

;parameter 1) EAX = srcMatrix    : Matrix   (Input Only)
;parameter 2) EBX = eigenvalue   : Matrix   (Input and Output)
;parameter 3) ECX = eigenvector  : Matrix   (Input and Output)
;parameter 4) EDX = iterations   : Matrix   (Input Only)
;parameter 5) ESI = tempMatrices : Matrices (Input and Output)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_local_variables:
    sub    esp, 44
    mov    [esp     ], eax        ;pSrcMatrix
    mov    [esp +  4], ebx        ;pEigenvalue
    mov    [esp +  8], ecx        ;pEigenvector
    mov    [esp + 12], edx        ;iterations
    mov    [esp + 16], esi        ;pTempMatrices
    mov    [esp + 20], esi        ;pTempMat1
    add    esi, (5*4)
    mov    [esp + 24], esi        ;pQ
    add    esi, (5*4)
    mov    [esp + 28], esi        ;pR
    add    esi, (5*4)
    mov    [esp + 32], esi        ;pU
    add    esi, (5*4)
    mov    [esp + 36], esi        ;pE
    sub    edx, 1
    mov    [esp + 40], edx        ;i = iterations - 1

    ;Done setup local variables

    ;pTempMat1 = pSrcMatrix
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp + 20]        ;EBX = pTempMat1
    call   mat_copy

    ;[pQ, pR] = qr_decomposition(pTempMat1)
    mov    eax, [esp + 20]        ;EAX = pTempMat1
    mov    ebx, [esp + 24]        ;EBX = pQ
    mov    ecx, [esp + 28]        ;ECX = pR
    mov    edx, [esp + 32]        ;EDX = pU
    mov    esi, [esp + 36]        ;ESI = pE
    call   qr_decomposition

    ;pTempMat1 = pQ * pR
    mov    eax, [esp + 24]        ;EAX = pQ
    mov    ebx, [esp + 28]        ;EBX = pR
    mov    ecx, [esp + 20]        ;ECX = pTempMat1
    call   mat_multiply

    ;pEigenvector = pQ
    mov    eax, [esp + 24]        ;EAX = pQ
    mov    ebx, [esp +  8]        ;EBX = pEigenvector
    call   mat_copy

    ;NOTE: i = iterations - 1

.loop:

    ;pTempMat1 = pR * pQ
    mov    eax, [esp + 28]        ;EAX = pR
    mov    ebx, [esp + 24]        ;EBX = pQ
    mov    ecx, [esp + 20]        ;ECX = pTempMat1
    call   mat_multiply

    ;[pQ , pR] = qr_decomposition(pTempMat1)
    mov    eax, [esp + 20]        ;EAX = pTempMat1
    mov    ebx, [esp + 24]        ;EBX = pQ
    mov    ecx, [esp + 28]        ;ECX = pR
    mov    edx, [esp + 32]        ;EDX = pU
    mov    esi, [esp + 36]        ;ESI = pE
    call   qr_decomposition

    ;pTempMat1 = pQ * pR
    mov    eax, [esp + 24]        ;EAX = pQ
    mov    ebx, [esp + 28]        ;EBX = pR
    mov    ecx, [esp + 20]        ;ECX = pTempMat1
    call   mat_multiply

    ;pEigenvector = pEigenvector * pQ
    mov    eax, [esp +  8]        ;EAX = pEigenvector
    mov    ebx, [esp + 24]        ;EBX = pQ
    mov    ecx, [esp +  8]        ;ECX = pEigenvector
    call   mat_multiply

    ;--i
    mov    ecx, [esp + 40]        ;ECX = i
    sub    ecx, 1                 ;--ECX
    mov    [esp + 40], ecx        ;i = ECX

    ;loop if i != 0
    jnz    .loop

.endloop:

    ;pEigenvalue = mat_diagonal(pTempMat1)
    mov    eax, [esp + 20]        ;EAX = pTempMat1
    mov    ebx, [esp +  4]        ;EBX = pEigenvalue
    call   mat_diagonal

    ;pEigenvector = mat_normalize_0_1(pEigenvector)
    mov    eax, [esp +  8]        ;EAX = pEigenvector
    mov    ebx, [esp +  8]        ;EBX = pEigenvector
    mov    ecx, 0b1               ;ECX = flag (norm by column)
    call   mat_normalize_0_1

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
