;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: vec_copy
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 09-APR-2015
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

global vec_copy

section .text

vec_copy:

;parameter 1) EAX = @srcMatrix    : Matrix    (Input Only)
;parameter 2) EBX = @dstMatrix    : Matrix    (Input and Output)
;parameter 3) ECX = srcOffset     : DWORD     (Input Only)
;parameter 4) EDX = dstOffset     : DWORD     (Input Only)
;parameter 5) ESI = srcJumpSize   : LOW WORD  (Input Only)
;parameter 6) ESI = dstJumpSize   : HIGH WORD (Input Only)
;parameter 7) EDI = numOfElements : DWORD     (Input Only)
;returns ---

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 24
    mov    [esp     ], eax    ;pSrcMatrix
    mov    [esp +  4], ebx    ;pDstMatrix
    mov    [esp +  8], ecx    ;srcOffset
    mov    [esp + 12], edx    ;dstOffset
    mov    [esp + 16], esi    ;srcJumpSize (LOW WORD)
                              ;dstJumpSize (HIGH WORD)
    mov    [esp + 20], edi    ;numOfEements

    ;Done setting up local variables

    ;ESI = pSrcMatrix.pData + srcOffset
    mov    esi, [esp]         ;ESI = pSrcMatrix
    add    esi, (4*4)         ;ESI = pSrcMatrix.pData
    mov    esi, [esi]
    mov    ebx, [esp + 8]     ;EBX = srcOffset
    add    esi, ebx

    ;EDI = pDstMatrix.pData + dstOffset
    mov    edi, [esp +  4]    ;EDI = pDstMatrix
    add    edi, (4*4)         ;EDI = pDstMatrix.pData
    mov    edi, [edi]
    mov    ebx, [esp + 12]    ;EBX = dstOffset
    add    edi, ebx

    ;EBX = srcJumpSize
    mov    ebx, [esp + 16]    ;EBX = srcJumpSize
    and    ebx, 0x0000ffff    ;Remove dstJumpSize from EBX

    ;EDX = dstJumpSize
    mov    edx, [esp + 16]    ;EDX = srcJumpSize
    shr    edx, 16            ;EDX = dstJumpSize

    ;ECX = numOfElements
    mov    ecx, [esp + 20]    ;ECX = numOfElements

.loop:

    movss  xmm0, [esi]
    movss  [edi], xmm0

    add    esi, ebx           ;point ESI to next element
    add    edi, edx           ;point EDI to next element

    sub    ecx, 1
    jnz    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
