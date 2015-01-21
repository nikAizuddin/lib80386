;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: cvt_double2string
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 01-NOV-2014
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
;     EXTERNAL FILES: string_append.asm
;                     cvt_int2string.asm
;                     pow_int.asm
;
;            VERSION: 0.1.23
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                MIT Licensed. See /LICENSE file.
;
;=====================================================================

extern string_append
extern cvt_int2string
extern pow_int
global cvt_double2string

section .text

cvt_double2string:

;parameter 1 = double_x:64bit
;parameter 2 = decimal_places:32bit
;parameter 3 = addr_out_string^:32bit
;parameter 4 = addr_out_strlen^:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack pointer to ebp

.get_arg_set_local_variables:
    sub    esp, 92                  ;reserve 92 bytes
    add    ebp, 8                   ;+8 offset to get the arguments

    mov    eax, [ebp    ]           ;get double_x[0]
    mov    ebx, [ebp + 4]           ;get double_x[1]
    mov    ecx, [ebp + 8]           ;get decimal_places
    mov    [esp     ], eax          ;double_x[0]
    mov    [esp +  4], ebx          ;double_x[1]
    mov    [esp +  8], ecx          ;decimal_places

    mov    eax, [ebp + 12]          ;get addr_out_string^
    mov    ebx, [ebp + 16]          ;get addr_out_strlen^
    mov    [esp + 12], eax          ;addr_out_string^
    mov    [esp + 16], ebx          ;addr_out_strlen^

    mov    dword [esp + 20], 0      ;integer_part
    mov    dword [esp + 24], 0      ;decimal_part[0]
    mov    dword [esp + 28], 0      ;decimal_part[1]
    mov    dword [esp + 32], 0      ;decimal_part_str[0]
    mov    dword [esp + 36], 0      ;decimal_part_str[1]
    mov    dword [esp + 40], 0      ;decimal_part_strlen
    mov    dword [esp + 44], 0      ;fpu_controlword
    mov    dword [esp + 48], 0      ;temp
    mov    dword [esp + 52], 0x2e   ;dot_character
    mov    dword [esp + 56], 0      ;cur_dec_places
    mov    dword [esp + 60], 0x30303030 ;zeroes_str[0]
    mov    dword [esp + 64], 0x30303030 ;zeroes_str[1]
    mov    dword [esp + 68], 0      ;zeroes_strlen


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the integer part from the double_x
;
;   For example:
;   Given double_x = 2147483647.12345678
;   The integer_part will be 2147483647
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   initialize FPU stacks;
;
;   Initializes the FPU to its default state. Flags all
;   FPU registers as empty, clears the top stack pointer.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set the RC Bit = 11 (Bit 10 and Bit 11). See diagram
;   below:
;
;          +-----+
;   BIT  0 | IM  | --> Invalid operation Mask
;          +-----+
;   BIT  1 | DM  | --> Denormalized operand Mask
;          +-----+
;   BIT  2 | ZM  | --> Zero divide Mask
;          +-----+
;   BIT  3 | OM  | --> Overflow Mask
;          +-----+
;   BIT  4 | UM  | --> Underflow Mask
;          +-----+
;   BIT  5 | PM  | --> Precision Mask
;          +-----+
;   BIT  6 |     |
;          +-----+
;   BIT  7 | IEM | --> Interrupt Enable Mask
;          +-----+
;   BIT  8 | PC  | --> Precision Control
;   BIT  9 |     |
;          +-----+
;   BIT 10 | RC  | --> Rounding Control, 11B = truncate
;   BIT 11 |     |
;          +-----+
;   BIT 12 | IC  | --> Infinity control
;          +-----+
;   BIT 13 |     |
;          +-----+
;   BIT 14 |     |
;          +-----+
;   BIT 15 |     |
;          +-----+
;
;             Diagram 1: FPU Control word register.
;
;   reference: http://www.website.masmforum.com/tutorials/fptute/
;              fpuchap1.htm
;
;   002:   set FPU rounding mode to truncate;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fstcw  word [esp + 44]          ;save fpu controlword to memory
    mov    ax, [esp + 44]           ;ax = fpu controlword
    or     eax, 110000000000B       ;rounding control = truncate
    mov    [esp + 44], ax           ;save ax value to memory
    fldcw  word [esp + 44]          ;use our fpu control word value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Copy double_x into FPU, so that later we can convert
;   to integer value, without rounding (truncate).
;
;   003:   push double_x into FPU;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fld    qword [esp]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This will convert the double_x into integer value.
;   Lets say the double_x = 3.8992, when convert to int
;   it will becomes 3 and store into integer_part variable.
;
;   004:   convert double_x to int and save to integer_part;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fist   dword [esp + 20]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the decimal part from the double_x
;
;   For example:
;   Given double_x = 2147483647.12345678
;
;   The decimal_part will be 12345678, but however this depends
;   on the value of decimal_places. If the decimal_places is 100,
;   the decimal_part will becomes 12.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   reinitialize FPU stacks;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    finit


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   push double_x into FPU;
;
;   FPU stacks before this instruction:
;       st0 = <empty>
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = double_x
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fld    qword [esp]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   push integer_part into FPU;
;
;   FPU stacks before this instruction:
;       st0 = double_x
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = integer_part
;       st1 = double_x
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp + 20]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   st0 = st1 - st0;
;
;   Purpose of this subtraction (double_x - integer_part),
;   is to get the decimal part of the double_x.
;
;   How? Lets say,
;       double_x = 2147483647.12345678,
;       integer_part = 2147483647.00000000
;
;   After subtraction we will get 0.12345678, this is the
;   decimal part of the double_x.
;       
;   FPU stacks before this instruction:
;       st0 = integer_part
;       st1 = double_x
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_part = double_x - integer_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fsub                            ;st0 = st1 - st0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   push decimal_places into FPU;
;
;   This will set how many decimal places that we want to
;   print to stdout.
;
;   FPU stacks before this instruction:
;       st0 = decimal_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_places
;       st1 = decimal_part
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fild   dword [esp +  8]         ;push decimal_places into fpu


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   st0 = st1 * st0;
;
;   This multiplication will set how many decimal places
;   of double_x that we want. Lets say the decimal_part is
;   0.1234567, when multiply with 100, it becomes 12.34567.
;   So, only 12 will be taken as decimal part value.
;
;   FPU stacks before this instruction:
;       st0 = decimal_places
;       st1 = decimal_part
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   FPU stacks after this instruction:
;       st0 = decimal_part = decimal_places * decimal_part
;       st1 = <empty>
;       st2 = <empty>
;       st3 = <empty>
;       st4 = <empty>
;       st5 = <empty>
;       st6 = <empty>
;       st7 = <empty>
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fmul                            ;st0 = st1 * st0;


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   save and pop st0 to decimal_part;
;
;   Now we have done obtaining the decimal part of the
;   double_x. Store the result into decimal_part variable,
;   and pop the FPU register.
;
;   However, there are 2 problems arise:
;      1) When the decimal_part >= 0.5, for example
;         0.675, 0.999999, 0.9, 0.543, and so on...
;
;      2) When there is zeroes in front of decimal_part,
;         for example when decimal_part = 0.031, 0.00213,
;         0.0005412, and so on....
;
;   Fortunately, these problems already solved :)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    fistp  qword [esp + 24]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Solve problem if the decimal_part >= 0.5
;
;   The solution is, we have to round the integer_part by 1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   if decimal_part[0] & 0x80000000 != 0x80000000, then
;              goto .decimal_part_is_pos.
;
;   This check positive/negative sign of the decimal_part.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    and    eax, 0x80000000
    cmp    eax, 0x80000000
    jne    .decimal_part_is_pos


.decimal_part_is_neg:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If we found that decimal_part is negative, we first
;   have to reverse two's complement value.
;
;   013:   decimal_part[0] = (!decimal_part[0]) + 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    not    eax
    add    eax, 1
    mov    [esp + 24], eax          ;decimal_part[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set the temp value as -1.
;
;   014:   temp = -1;
;
;   Because later, lets say the decimal_part is -0.999,
;   we have to -1 so that the decimal_part becomes -1.000.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, -1
    mov    [esp + 48], eax          ;temp = eax
    jmp    .end_decimal_part_check_sign


.decimal_part_is_pos:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If we found that the decimal_part is positive, we just
;   set the temp value as 1. Because later, if we found that
;   decimal_part needs to be rounded, we just add temp to
;   the decimal_part.
;
;   015:   temp = 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 1                   ;eax = 1
    mov    [esp + 48], eax          ;temp = eax


.end_decimal_part_check_sign:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert the decimal part to ascii string
;
;   016:   cvt_int2string( decimal_part[0],
;                          @decimal_part_str[0],
;                          @decimal_part_strlen,
;                          0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ebx, esp
    mov    ecx, esp
    mov    eax, [esp + 16 + 24]     ;get decimal_part[0]
    add    ebx, (16 + 32)           ;get @decimal_part_str[0]
    add    ecx, (16 + 40)           ;get @decimal_part_strlen
    xor    edx, edx                 ;get flag=0
    mov    [esp     ], eax          ;arg1: decimal_part[0]
    mov    [esp +  4], ebx          ;arg2: @decimal_part_str[0]
    mov    [esp +  8], ecx          ;arg3: @decimal_part_strlen
    mov    [esp + 12], edx          ;arg4: flag=0
    call   cvt_int2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
;   017:   if decimal_part[0] != decimal_places, then
;              goto .dont_round_integer_part.
;
;   This checks whether we need to add integer_part
;   by 1 or not. If we must add integer_part by 1,
;   we also need to zero the decimal_part.
;
;   Consider this decimal_part problem, assume we want
;   to print only 2 decimal places:
;
;       0.9250 * 100 = 99.25
;       when convert to integer, round to nearest = 99
;       NO PROBLEM. Because 99 is still 2 decimal places.
;       Just jump to .dont_round_integer_part.
;
;       0.9750 * 100 = 99.75
;       when convert to integer, round to nearest = 100
;       PROBLEM!!! 100 is more than 2 decimal places.
;       Need to execute .round_integer_part to solve this.
;
;   SOLUTION TO THE PROBLEM:
;   If we found that decimal_part = 100 = decimal_places,
;   then:
;
;       integer_part += 1
;
;       decimal_part_str[0] &= 0xfffffff0
;       means that if decimal_part_str[0] = 0x00303031,
;       then we mask it with 0xfffffff0 so that it becomes
;       0x00303030.
;
;       decimal_part_strlen -= 1, so, we only use 0x00003030
;       in the decimal_part_str.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_part[0]
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jne    .dont_round_integer_part ;if !=, .dont_round_integer_part


.round_integer_part:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   integer_part = integer_part + temp;
;
;   This will add the integer_part by temp value. Note that
;   the temp value can be +1 or -1, depends on the
;   decimal_part sign. If decimal_part is negative, then
;   the value of temp will be -1. Otherwise, if decimal_part
;   is positive, then the value of temp will be +1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = integer_part
    mov    ebx, [esp + 48]          ;ebx = temp
    add    eax, ebx
    mov    [esp + 20], eax          ;integer_part = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   decimal_part_str[0] &= 0xfffffff0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_part_str[0]
    and    eax, 0xfffffff0
    mov    [esp + 32], eax          ;decimal_part_str[0] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   -- decimal_part_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 40]          ;ebx = decimal_part_strlen
    sub    ebx, 1
    mov    [esp + 40], ebx          ;decimal_part_strlen = ebx


.dont_round_integer_part:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert the integer part to out string
;
;   For example:
;
;   Given integer_part = 2147483647
;   The out_string[0] will be 0x37343132,
;   the out_string[1] will be 0x36333834,
;   the out_string[2] will be 0x3734,
;   and the out_strlen will be 10
;
;   If given integer_part = -2147483647
;   The out_string[0] will be 0x3431322d,
;   the out_string[1] will be 0x33383437,
;   the out_string[2] will be 0x373436,
;   and the out_strlen will be 11
;
;   021:   cvt_int2string( integer_part,
;                         addr_out_string,
;                         addr_out_strlen,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp + (16 + 20)]   ;get integer_part
    mov    ebx, [esp + (16 + 12)]   ;get addr_out_string
    mov    ecx, [esp + (16 + 16)]   ;get addr_out_strlen
    mov    edx, 1                   ;get flag=1
    mov    [esp     ], eax          ;arg1: integer_part
    mov    [esp +  4], ebx          ;arg2: addr_out_string
    mov    [esp +  8], ecx          ;arg3: addr_out_strlen
    mov    [esp + 12], edx          ;arg4: flag=1
    call   cvt_int2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append a dot character into ascii string
;
;   For example:
;   Given ascii_string 0x37343132363338343734
;
;   After inserting the dot character at the end,
;   the ascii_string will be 0x2e37343132363338343734
;
;   022:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @dot_character,
;                         1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 52)           ;get @dot_character
    mov    edx, 1                   ;get src_strlen = 1 character
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @dot_character
    mov    [esp + 12], edx          ;arg4: src_strlen = 1 character
    call   string_append
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Solve problem for heading zeroes in decimal_part
;
;   If decimal_part = 0.00214 or any number that has heading
;   zeroes, the problem occurs after we multiply it with
;   decimal_places. Example problem:
;
;       decimal_places = 1000
;       decimal_part = decimal_part * decimal_places
;       decimal_part = 0.00214 * 1000
;       decimal_part = 2.14
;
;   See that? The program supposed to print 0.002, but the
;   program prints only 0.2.
;
;   To solve this, before we append the decimal_part_str to the
;   out_string, first we append the required heading zeroes string
;   to the out_string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the current decimal places of the decimal_part_str.
;
;   023:   cur_dec_places = pow_int( 10, decimal_part_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, 10                  ;get base_value = 10
    mov    ebx, [esp + (8 + 40)]    ;get pow_val = decimal_part_strlen
    mov    [esp    ], eax           ;arg1: base_val = 10
    mov    [esp + 4], ebx           ;arg2: pow_val=decimal_part_strlen
    call   pow_int
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 56], eax          ;cur_dec_places = eax (ret value)


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   if cur_dec_places >= decimal_places, then
;              goto .dont_insert_heading_zeroes
;
;   But if we found that current decimal places of
;   decimal part string is less, execute this condition.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jge    .dont_insert_heading_zeroes


.insert_heading_zeroes:


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This loop will find out how many heading zeroes characters
;   that are required to append to the out_string.
;
;   025:   cur_dec_places *= 10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, 10
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 56], eax          ;cur_dec_places = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   ++ zeroes_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 68]          ;eax = zeroes_strlen
    add    eax, 1
    mov    [esp + 68], eax          ;zeroes_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   027:   if cur_dec_places != decimal_places, .loop_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = cur_dec_places
    mov    ebx, [esp +  8]          ;ebx = decimal_places
    cmp    eax, ebx
    jne    .loop_1


.endloop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Now, we have found out how many required heading zeroes.
;   Append the heading zeroes string to the out_string.
;
;   028:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @zeroes_str[0],
;                         zeroes_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 60)           ;get @zeroes_str[0]
    mov    edx, [esp + (16 + 68)]   ;get zeroes_strlen
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @zeroes_str[0]
    mov    [esp + 12], edx          ;arg4: zeroes_strlen
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.dont_insert_heading_zeroes:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Finally, append the decimal_part to the out_string.
;
;   029:   string_append( addr_out_string,
;                         addr_out_strlen,
;                         @decimal_part_str[0],
;                         decimal_part_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    ecx, esp
    mov    eax, [esp + (16 + 12)]   ;get addr_out_string
    mov    ebx, [esp + (16 + 16)]   ;get addr_out_strlen
    add    ecx, (16 + 32)           ;get @decimal_part_str[0]
    mov    edx, [esp + (16 + 40)]   ;get decimal_part_strlen
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @decimal_part_str[0]
    mov    [esp + 12], edx          ;arg4: decimal_part_strlen
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp value to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
