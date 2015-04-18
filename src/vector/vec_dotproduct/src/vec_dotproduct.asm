;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;          FUNCTION NAME: vec_dotproduct
; FUNCTION DOCUMENTATION: <See doc/description file>
;
;                 AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;                  EMAIL: nickaizuddin93@gmail.com
;           DATE CREATED: 09-APR-2015
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
global vec_dotproduct

section .text

vec_dotproduct:

;parameter 1) addr_vec1:ESI
;parameter 2) vec1_jumpSize:EBX
;parameter 3) addr_vec2:EDI
;parameter 4) vec2_jumpSize:EDX
;parameter 5) numOfElements:ECX
;returns result:XMM0

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 44
    mov    [esp     ], eax        ;pMatrix1
    mov    [esp +  4], ebx        ;pMatrix2
    mov    [esp +  8], ecx        ;flag
    mov    [esp + 12], edx        ;index1
    mov    [esp + 16], esi        ;index2
    mov    dword [esp + 20], 0    ;mat1JumpSize
    mov    dword [esp + 24], 0    ;mat1NumOfElements
    mov    dword [esp + 28], 0    ;pDataMat1
    mov    dword [esp + 32], 0    ;mat2JumpSize
    mov    dword [esp + 36], 0    ;mat2NumOfElements
    mov    dword [esp + 40], 0    ;pDataMat2

    ;Done setup local variables

    ;Get jump size, number of elements, and
    ;address of the offsetted dataMatrix of matrix1
    mov    esi, [esp]             ;ESI = pMatrix1
    mov    ebx, [esp +  8]        ;EBX = flag of matrix1
    and    ebx, 0b01
    mov    ecx, [esp + 12]        ;ECX = index for matrix1
    call   get_vector_info
    mov    [esp + 20], ebx        ;mat1JumpSize = EBX
    mov    [esp + 24], ecx        ;mat1NumOfElements = ECX
    mov    [esp + 28], edi        ;pDataMat1 = EDI

    ;Get jump size, number of elements, and
    ;address of the offsetted dataMatrix of matrix2
    mov    esi, [esp +  4]        ;ESI = pMatrix2
    mov    ebx, [esp +  8]        ;EBX = flag of matrix2
    shr    ebx, 1
    mov    ecx, [esp + 16]        ;ECX = index for matrix2
    call   get_vector_info
    mov    [esp + 32], ebx        ;mat2JumpSize = EBX
    mov    [esp + 36], ecx        ;mat2NumOfElements = ECX
    mov    [esp + 40], edi        ;pDataMat2 = EDI

    mov    esi, [esp + 28]        ;ESI = pDataMat1
    mov    edi, [esp + 40]        ;EDI = pDataMat2
    mov    ebx, [esp + 20]        ;EBX = mat1JumpSize
    mov    edx, [esp + 32]        ;EDX = mat2JumpSize
    mov    ecx, [esp + 24]        ;ECX = mat1NumOfElements

    pxor   xmm0, xmm0

.loop_dotproduct:

    movss  xmm1, [esi]
    movss  xmm2, [edi]

    mulss  xmm1, xmm2
    addss  xmm0, xmm1

    add    esi, ebx
    add    edi, edx

    sub    ecx, 1
    jnz    .loop_dotproduct

.endloop_dotproduct:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

.clean_stackframe:

    ret
