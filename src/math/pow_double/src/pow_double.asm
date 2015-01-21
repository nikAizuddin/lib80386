;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: pow_double
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 13-DEC-2014
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
;            VERSION: 0.1.11
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global pow_double

section .text

pow_double:

;parameter 1 = x:64bit
;parameter 2 = y:64bit
;returns = result (ST0)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get x[0]
    mov    ebx, [ebp +  4]          ;get x[1]
    mov    ecx, [ebp +  8]          ;get y[0]
    mov    edx, [ebp + 12]          ;get y[1]

.set_local_variables:
    sub    esp, 48                  ;reserve 24 bytes
    mov    [esp     ], eax          ;x[0]
    mov    [esp +  4], ebx          ;x[1]
    mov    [esp +  8], ecx          ;y[0]
    mov    [esp + 12], edx          ;y[1]

    mov    dword [esp + 16], 0x00000000 ;constant: 1.0 (double)
    mov    dword [esp + 20], 0x3ff00000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   Initialize FPU stack
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   st0 = log2(x) * y;
;
;   FYL2X multiplies ST1 by the base-2 logarithm of ST0,
;   stores the result in ST1, and pops the register stack
;   (so that the result ends up in ST0). ST0 must be non-zero
;   and positive.
;
;   Source: http://www.csee.umbc.edu/courses/undergraduate/
;                  CMSC313/fall04/burt_katz/lectures/Lect12/
;                  floatingpoint.html
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fld    qword [esp + 16]         ;push 1.0 to fpu stack
    fld    qword [esp     ]         ;push x to fpu stack
    fyl2x                           ;log2( st0 )
    fld    qword [esp +  8]         ;st0 = y
    fmul   st0, st1                 ;st0 = st0 * st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   st1 = st0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fst    st1                      ;st1 = st0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   Round st0 to the nearest
;
;   FRNDINT rounds the contents of ST0 to an integer,
;   according to the current rounding mode set in the
;   FPU control word, and stores the result back in ST0. 
;
;   Source: http://www.csee.umbc.edu/courses/undergraduate/
;                  CMSC313/fall04/burt_katz/lectures/Lect12/
;                  floatingpoint.html
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    frndint


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   st1 = st1 - st0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fsub   st1, st0                 ;st1 = st1 - st0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   st0 = st1, st1 = st0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fxch   st1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   st0 = (2^st0) - 1.0
;
;   F2XM1 raises 2 to the power of ST0, subtracts one, and
;   stores the result back into ST0. The initial contents of ST0
;   must be a number in the range -1.0 to +1.0.
;
;   Source: http://www.csee.umbc.edu/courses/undergraduate/
;                  CMSC313/fall04/burt_katz/lectures/Lect12/
;                  floatingpoint.html
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    f2xm1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   st0 += 1.0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fadd   qword [esp + 16]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   st0 = st0 * ( 2 ^ round_to_nearest(st1) );
;
;   FSCALE scales a number by a power of two: it rounds ST1
;   towards zero to obtain an integer, then multiplies ST0
;   by two to the power of that integer, and stores
;   the result in ST0.
;
;   Source: http://www.csee.umbc.edu/courses/undergraduate/
;                  CMSC313/fall04/burt_katz/lectures/Lect12/
;                  floatingpoint.html
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fscale


.return:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   Return st0;
;
;   The result is already stored in ST0.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to arguments
    mov    esp, ebp                 ;restore stack ptr to initial val
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
