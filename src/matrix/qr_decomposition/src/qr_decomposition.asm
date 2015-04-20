;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: qr_decomposition
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 11-APR-2015
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
;         EXTERNAL FILES: vec_copy.asm
;                         euclidean_norm.asm
;                         vec_divide_elements.asm
;                         vec_dotproduct.asm
;                         vec_multiply_elements.asm
;                         vec_subtract_vv.asm
;                         mat_set_element.asm
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

extern vec_copy
extern euclidean_norm
extern vec_divide_elements
extern vec_dotproduct
extern vec_multiply_elements
extern vec_subtract_vv
extern mat_set_element
global qr_decomposition

section .text

qr_decomposition:

;parameter 1) EAX = @srcMatrix  : Matrix (Input Only)
;parameter 2) EBX = @Q          : Matrix (Input and Output)
;parameter 3) ECX = @R          : Matrix (Input and Output)
;parameter 4) EDX = @tempMatrix : Matrix (Input and Output)
;parameter 5) ESI = @tempVector : Matrix (Input and Output)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_local_variables:
    sub    esp, 40
    mov    [esp     ], eax     ;pSrcMatrix
    mov    [esp +  4], ebx     ;pQ
    mov    [esp +  8], ecx     ;pR
    mov    [esp + 12], edx     ;pTempMat
    mov    [esp + 16], esi     ;pTempVec

    ;n = srcMatrix.numOfRows
    mov    ebx, eax
    mov    ebx, [ebx]
    mov    [esp + 20], ebx

    ;rowSize = srcMatrix.rowSize
    mov    ebx, eax
    add    ebx, (4*3)
    mov    ebx, [ebx]
    mov    [esp + 24], ebx

    mov    dword [esp + 28], 1 ;i
    mov    dword [esp + 32], 1 ;j
    mov    dword [esp + 36], 0 ;k

; ***
; Find Q
; ***

    ;pTempMat[:,0] = pSrcMatrix[:,0]
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp + 12]        ;EBX = pTempMat
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, 0                 ;EDX = index for pSrcMatrix
    mov    esi, 0                 ;ESI = index for pTempMat
    call   vec_copy

; Q[:,0] = pTempMat[:,0] / euclidean_norm(pTempMat[:,0])

    ;euclidean_norm(pTempMat[:,0])
    mov    eax, [esp + 12]        ;EAX = pTempMat
    mov    ebx, 0b1               ;EBX = flag
    mov    ecx, 0                 ;ECX = index
    call   euclidean_norm

    ;XMM0 = euclidean_norm

    ;Q[:,0] = pTempMat[:,0] / XMM0
    mov    eax, [esp + 12]        ;EAX = pTempMat
    mov    ebx, [esp +  4]        ;EBX = pQ
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, 0                 ;EDX = index for pTempMat
    mov    esi, 0                 ;ESI = index for pQ
    call   vec_divide_elements

.loopQ:

    ;pTempMat[:,i] = pSrcMatrix[:,i]
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp + 12]        ;EBX = pTempMat
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, [esp + 28]        ;EDX = i (index for pSrcMatrix)
    mov    esi, [esp + 28]        ;ESI = i (index for pTempMat)
    call   vec_copy

    ;k = 0
    mov    eax, 0
    mov    [esp + 36], eax        ;k = 0

.subloopQ:

    ;pTempMat[:,i]=pTempMat[:,i]-(pSrcMatrix(:,i)'*pQ(:,k)).*pQ(:,k);

    ;XMM0 = pSrcMatrix[:,i]'*pQ[:,k]
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp +  4]        ;EBX = pQ
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, [esp + 28]        ;EDX = i (index pSrcMatrix)
    mov    esi, [esp + 36]        ;ESI = k (index pQ)
    call   vec_dotproduct

    ;pTempVec[:,0] = pQ[:,k].*XMM0
    mov    eax, [esp +  4]        ;EAX = pQ
    mov    ebx, [esp + 16]        ;EBX = pTempVec
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, [esp + 36]        ;EDX = k (index pQ)
    mov    esi, 0                 ;ESI = 0 (index pTempVec)
    call   vec_multiply_elements

    ;pTempMat[:,i] -= pTempVec[:,0]
    mov    eax, [esp + 12]        ;EAX = pTempMat
    mov    ebx, [esp + 16]        ;EBX = pTempVec
    mov    ecx, [esp + 12]        ;ECX = pTempMat
    mov    edx, 0b111             ;EDX = flag
    mov    esi, 0                 ;HIGH ESI = 0 (index pTempVec)
    shl    esi, 16
    add    esi, [esp + 28]        ;LOW ESI = i (index pTempMat)
    mov    edi, [esp + 28]        ;EDI = i (index pTempMat)
    call   vec_subtract_vv

    ;++k
    mov    ecx, [esp + 36]    ;ECX = k
    add    ecx, 1
    mov    [esp + 36], ecx    ;k = ECX

    ;subloopQ if k < j
    mov    eax, [esp + 32]    ;EAX = j
    cmp    ecx, eax
    jb     .dont_exit_subloopQ
.exit_subloopQ:
    jmp    .endsubloopQ
.dont_exit_subloopQ:
    jmp    .subloopQ

.endsubloopQ:

    ;pQ[:,i] = pTempMat[:,i] / norm(pTempMat[:,i]);

    ;XMM0 = norm(pTempMat[:,i])
    mov    eax, [esp + 12]        ;EAX = pTempMat
    mov    ebx, 0b1               ;EBX = flag
    mov    ecx, [esp + 28]        ;ECX = i (index pTempMat)
    call   euclidean_norm

    ;pQ[:,i] = pTempMat[:,i] / XMM0
    mov    eax, [esp + 12]        ;EAX = pTempMat
    mov    ebx, [esp +  4]        ;EBX = pQ
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, [esp + 28]        ;EDX = i (index pTempMat)
    mov    esi, [esp + 28]        ;ESI = i (index pQ)
    call   vec_divide_elements

    ;++j
    mov    ecx, [esp + 32]    ;ECX = j
    add    ecx, 1
    mov    [esp + 32], ecx    ;j = ECX

    ;++i
    mov    ecx, [esp + 28]    ;ECX = i
    add    ecx, 1
    mov    [esp + 28], ecx    ;i = ECX

    ;loopQ if i < n
    mov    eax, [esp + 20]    ;EAX = n
    cmp    ecx, eax
    jb     .dont_exit_loopQ
.exit_loopQ:
    jmp    .endloopQ
.dont_exit_loopQ:
    jmp    .loopQ

.endloopQ:


; ***
; Find R
; ***

; i = 0, j = 0, k = 0
    mov    eax, 0
    mov    [esp + 28], eax        ;i = 0
    mov    [esp + 32], eax        ;j = 0
    mov    [esp + 36], eax        ;k = 0

.loopR:

    ;j = k
    mov    eax, [esp + 36]    ;EAX = k
    mov    [esp + 32], eax    ;j = EAX

.subloopR:

    ;pR[i, j] = pSrcMatrix[:,j]' * pQ[:,i];
    mov    eax, [esp     ]        ;EAX = pSrcMatrix
    mov    ebx, [esp +  4]        ;EBX = pQ
    mov    ecx, 0b11              ;ECX = flag
    mov    edx, [esp + 32]        ;EDX = j (index pSrcMatrix)
    mov    esi, [esp + 28]        ;ESI = i (index pQ)
    call   vec_dotproduct
    mov    eax, [esp +  8]        ;EAX = pR
    mov    ebx, [esp + 28]        ;EBX = i
    mov    ecx, [esp + 32]        ;ECX = j
    call   mat_set_element

    ;++j
    mov    eax, [esp + 32]    ;EAX = j
    add    eax, 1
    mov    [esp + 32], eax    ;j = EAX

    ;subloopR if j < n
    mov    eax, [esp + 32]    ;EAX = j
    mov    ebx, [esp + 20]    ;EBX = n
    cmp    eax, ebx
    jb     .dont_exit_subloopR
.exit_subloopR:
    jmp    .endsubloopR
.dont_exit_subloopR:
    jmp    .subloopR

.endsubloopR:

    ;++k
    mov    eax, [esp + 36]    ;EAX = k
    add    eax, 1
    mov    [esp + 36], eax    ;k = EAX

    ;++i
    mov    ebx, [esp + 28]    ;EBX = i
    add    ebx, 1
    mov    [esp + 28], ebx    ;i = EBX

    ;loopR if i < n
    mov    eax, [esp + 28]    ;EAX = i
    mov    ebx, [esp + 20]    ;EBX = n
    cmp    eax, ebx
    jbe    .dont_exit_loopR
.exit_loopR:
    jmp    .endloopR
.dont_exit_loopR:
    jmp    .loopR

.endloopR:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp] ;SIGSEGV
    add    esp, 4

    ret
