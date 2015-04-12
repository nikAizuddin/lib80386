;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: qr_decomposition
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 11-APR-2015
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
;     EXTERNAL FILES: vec_copy.asm
;                     euclidean_norm.asm
;                     vec_divide_elements.asm
;                     vec_dotproduct.asm
;                     vec_multiply_elements.asm
;                     vec_subtract_vv.asm
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

extern vec_copy
extern euclidean_norm
extern vec_divide_elements
extern vec_dotproduct
extern vec_multiply_elements
extern vec_subtract_vv
global qr_decomposition

section .text

qr_decomposition:

;parameter 1) addr_srcMat:EAX
;parameter 2) addr_u:EBX
;parameter 3) addr_e:ECX
;parameter 4) n:EDX
;parameter 5) addr_Q:ESI
;parameter 6) addr_R:EDI
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_local_variables:
    sub    esp, 40
    mov    [esp     ], eax       ;addr_srcMat
    mov    [esp +  4], ebx       ;addr_u
    mov    [esp +  8], ecx       ;addr_e
    mov    [esp + 12], edx       ;n
    mov    [esp + 16], esi       ;addr_Q
    mov    [esp + 20], edi       ;addr_R
    mov    dword [esp + 24], 4   ;i
    mov    dword [esp + 28], 4   ;j
    mov    dword [esp + 32], 0   ;k
    lea    edx, [edx*4]
    mov    dword [esp + 36], edx ;rowsize = n * 4

; ***
; Find Q
; ***

; u[:,0] = A[:,0]
    mov    esi, [esp]      ;ESI = addr_srcMat
    mov    ebx, [esp + 36] ;EBX = rowSize
    mov    edi, [esp +  4] ;EDI = addr_u
    mov    edx, [esp + 36] ;EDX = rowSize
    mov    ecx, [esp + 12] ;ECX = n
    call   vec_copy

; Q[:,0] = u[:,0] / euclidean_norm(u[:,0])

    ; euclidean_norm(u[:,0])
    mov    eax, [esp +  4]    ;EAX = addr_u
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   euclidean_norm

    ; Q[:,0] = u[:,0] / XMM0
    mov    esi, [esp +  4]    ;ESI = addr_u
    mov    edi, [esp + 16]    ;EDI = addr_Q
                              ;XMM0 = previous result
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   vec_divide_elements

.loopQ:

; u[:,i] = A[:,i]
    mov    ecx, [esp + 24]    ;ECX = i
    mov    esi, [esp]         ;ESI = addr_srcMat[:,i]
    add    esi, ecx
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    edi, [esp +  4]    ;EDI = addr_u[:,i]
    add    edi, ecx
    mov    edx, [esp + 36]    ;EDX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   vec_copy

    mov    eax, 0
    mov    [esp + 32], eax    ;k = 0

.subloopQ:

; u[:,i] = u[:,i] - (A(:,i)'*Q(:,k)).*Q(:,k);

    ; XMM0 = A[:,i]'*Q[:,k]
    mov    ecx, [esp + 24]    ;ECX = i
    mov    edx, [esp + 32]    ;EDX = k
    mov    esi, [esp]         ;ESI = addr_srcMat[:,i]
    add    esi, ecx
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    edi, [esp + 16]    ;EDI = addr_Q[:,k]
    add    edi, edx
    mov    edx, [esp + 36]    ;EDX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   vec_dotproduct

    ; e[:,0] = Q[:,k].*XMM0
    mov    ecx, [esp + 32]    ;ECX = k
    mov    esi, [esp + 16]    ;ESI = addr_Q[:,k]
    add    esi, ecx
    mov    edi, [esp +  8]    ;EDI = addr_e[:,0]
                              ;XMM0 = already assigned
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   vec_multiply_elements

    ; u[:,i] -= e[:,0]
    mov    edx, [esp + 24]    ;EDX = i
    mov    esi, [esp +  4]    ;ESI = addr_u[:,i]
    add    esi, edx
    mov    edi, [esp +  8]    ;EDI = addr_e[:,0]
    mov    eax, esi           ;EAX = addr_u[:,i]
    mov    ebx, [esp + 36]    ;EBX = rowSize
    mov    ecx, [esp + 12]    ;ECX = n (numOfRows)
    call   vec_subtract_vv

; k += 4
    mov    ecx, [esp + 32]    ;ECX = k
    add    ecx, 4
    mov    [esp + 32], ecx    ;k = ECX

    mov    eax, [esp + 28]    ;EAX = j
    cmp    ecx, eax           ;subloopQ if ECX < j
    jb     .dont_exit_subloopQ
    .exit_subloopQ:
    jmp    .endsubloopQ
    .dont_exit_subloopQ:
    jmp    .subloopQ

.endsubloopQ:

; Q[:,i] = u[:,i] / norm(u[:,i]);

    ; norm(u[:,i])
    mov    ecx, [esp + 24] ;ECX = i
    mov    eax, [esp +  4] ;EAX = addr_u[:,i]
    add    eax, ecx
    mov    ebx, [esp + 36] ;EBX = rowSize
    mov    ecx, [esp + 12] ;ECX = n (numOfRows)
    call   euclidean_norm

    ; Q[:,i] = u[:,i] / XMM0 ###
    mov    ecx, [esp + 24] ;ECX = i
    mov    esi, [esp +  4] ;ESI = addr_u[:,i]
    add    esi, ecx
    mov    edi, [esp + 16] ;EDI = addr_Q[:,i]
    add    edi, ecx
                           ;XMM0 = already assigned
    mov    ebx, [esp + 36] ;EBX = rowSize
    mov    ecx, [esp + 12] ;ECX = n (numOfRows)
    call   vec_divide_elements

; j += 4
    mov    ecx, [esp + 28]    ;ECX = j
    add    ecx, 4
    mov    [esp + 28], ecx    ;j = ECX

; i += 4
    mov    ecx, [esp + 24]    ;ECX = i
    add    ecx, 4
    mov    [esp + 24], ecx    ;i = ECX

    mov    eax, [esp + 36]    ;EAX = rowSize
    cmp    ecx, eax           ;loopQ if ECX < rowSize
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
    mov    [esp + 24], eax    ;i = EAX
    mov    [esp + 28], eax    ;j = EAX
    mov    [esp + 32], eax

.loopR:

    ; j = k
    mov    eax, [esp + 32]    ;EAX = k
    mov    [esp + 28], eax    ;j = EAX

.subloopR:

    ; R[i, j] = A[:,j]' * Q[:,i];
    mov    ecx, [esp + 24] ;ECX = i
    mov    edx, [esp + 28] ;EDX = j
    mov    esi, [esp     ] ;ESI = addr_srcMat[:,j]
    add    esi, edx
    mov    ebx, [esp + 36] ;EBX = rowSize
    mov    edi, [esp + 16] ;EDI = addr_Q[:,i]
    add    edi, ecx
    mov    edx, [esp + 36] ;EDX = rowSize
    mov    ecx, [esp + 12] ;ECX = n (numOfRows)
    call   vec_dotproduct
    mov    ecx, [esp + 28] ;ECX = j
    mov    eax, [esp + 24] ;EAX = i
    mov    ebx, [esp + 12] ;EBX = n (numOfRows)
    mul    ebx
    mov    esi, [esp + 20] ;ESI = addr_R
    add    esi, eax
    add    esi, ecx
    movss  [esi], xmm0

    ; j += 4
    mov    eax, [esp + 28]    ;EAX = j
    add    eax, 4
    mov    [esp + 28], eax    ;j = EAX

    ; subloopR if j < rowSize
    mov    eax, [esp + 28]    ;EAX = j
    mov    ebx, [esp + 36]    ;EBX = rowSize
    cmp    eax, ebx
    jb     .dont_exit_subloopR
    .exit_subloopR:
    jmp    .endsubloopR
    .dont_exit_subloopR:
    jmp    .subloopR

.endsubloopR:

    ; k += 4
    mov    eax, [esp + 32]    ;EAX = k
    add    eax, 4
    mov    [esp + 32], eax    ;k = EAX

    ; i += 4
    mov    ebx, [esp + 24]    ;EBX = i
    add    ebx, 4
    mov    [esp + 24], ebx    ;i = EBX

    ; loopR if i < rowSize
    mov    eax, [esp + 24]    ;EAX = i
    mov    ebx, [esp + 36]    ;EBX = rowSize
    cmp    eax, ebx
    jbe    .dont_exit_loopR
    .exit_loopR:
    jmp    .endloopR
    .dont_exit_loopR:
    jmp    .loopR

.endloopR:


.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
