;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: mat_multiply
;     DOCUMENTATIONS: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 14-APR-2015
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
; REQ EXTERNAL FILES: vec_dotproduct.asm
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

extern vec_dotproduct
global mat_multiply

section .text

mat_multiply:

;parameter 1) EAX = @matrix1   : Matrix (Input Only)
;parameter 2) EBX = @matrix2   : Matrix (Input Only)
;parameter 3) ECX = @dstMatrix : Matrix (Input and Output)

.setup_stackframe:
    sub    esp, 4
    mov    [esp], ebp
    mov    ebp, esp

.set_localvariables:
    sub    esp, 60
    mov    [esp     ], eax       ;pMatrix1
    mov    [esp +  4], ebx       ;pMatrix2
    mov    [esp +  8], ecx       ;pDstMatrix
    mov    dword [esp + 12], 0   ;row
    mov    dword [esp + 16], 0   ;column

    mov    edx, [eax]            ;EAX = pMatrix1.numOfRows
    mov    dword [esp + 20], edx ;maxRows

    mov    edx, ebx
    add    edx, (4*1)            ;EBX = pMatrix.numOfColumns
    mov    edx, [edx]
    mov    dword [esp + 24], edx ;maxColumns

    mov    edx, eax
    add    edx, (4*4)
    mov    edx, [edx]
    mov    dword [esp + 28], edx ;pDataMat1

    mov    edx, ebx
    add    edx, (4*4)
    mov    edx, [edx]
    mov    dword [esp + 32], edx ;pDataMat2

    mov    edx, eax
    add    edx, (4*2)
    mov    edx, [edx]
    mov    dword [esp + 36], edx ;colSizeMat1

    mov    edx, eax
    add    edx, (4*3)
    mov    edx, [edx]
    mov    dword [esp + 40], edx ;rowSizeMat1

    mov    edx, ebx
    add    edx, (4*2)
    mov    edx, [edx]
    mov    dword [esp + 44], edx ;colSizeMat2

    mov    edx, ebx
    add    edx, (4*3)
    mov    edx, [edx]
    mov    dword [esp + 48], edx ;rowSizeMat2

    mov    edx, ecx
    add    edx, (4*4)
    mov    edx, [edx]
    mov    dword [esp + 52], edx ;pDataDstMat

    mov    edx, ebx
    mov    edx, [edx]
    mov    dword [esp + 56], edx ;rowsMat2

.loop:

    ;column = 0
    mov    ecx, 0                ;ECX = 0
    mov    [esp + 16], ecx       ;column = ECX

.subloop:

    ;C[row,column] = A[row,:]*B[:,column]
    mov    eax, [esp     ]        ;EAX = pMatrix1
    mov    ebx, [esp +  4]        ;EBX = pMatrix2
    mov    ecx, 0b10              ;ECX = flag
    mov    edx, [esp + 12]        ;EDX = row
    mov    esi, [esp + 16]        ;ESI = column
    call   vec_dotproduct

    ;pDataDstMat += colSizeDstMat
    mov    edi, [esp + 52]       ;EDI = pDataDstMat
    movss  [edi], xmm0
    add    edi, 4                ;colSizeDstMat
    mov    [esp + 52], edi       ;pDataDstMat = EDI

    ;++column
    mov    ecx, [esp + 16]       ;ECX = column
    add    ecx, 1
    mov    [esp + 16], ecx       ;column = ECX

    ;subloop if column < maxColumn
    mov    eax, [esp + 16]       ;EAX = column
    mov    ebx, [esp + 24]       ;EBX = maxColumn
    cmp    eax, ebx
    jge    .endsubloop
    jmp    .subloop

.endsubloop:

    ;++row
    mov    ecx, [esp + 12]       ;ECX = row
    add    ecx, 1
    mov    [esp + 12], ecx       ;row = ECX

    ;loop if row < maxRows
    mov    eax, [esp + 12]       ;EAX = row
    mov    ebx, [esp + 20]       ;EBX = maxRows
    cmp    eax, ebx
    jge    .endloop
    jmp    .loop

.endloop:

.clean_stackframe:
    mov    esp, ebp
    mov    ebp, [esp]
    add    esp, 4

    ret
