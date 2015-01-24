%line 1+1 submit.asm

;Assembled with "$ nasm -E submit.asm -o submit_minimized.asm"

;Documentations are removed to reduce source code size.
;View the full version of this code here:
;https://github.com/nikAizuddin/lib80386/tree/master/example/codechef/practice/easy//home/nlck/Documents/_dataProject/_dataASM/IBM_PC/lib80386/example/codechef/practice/easy/HS08TEST/submit/submit.asm
































[global _start]

[section .bss]

 rb: resd 1025
 rb_ptr: resd 1
 rb_byte_pos: resd 1

 withdraw_str: resd 2
 withdraw_strlen: resd 1
 withdraw_int: resd 1

 balance_str: resd 2
 balance_strlen: resd 1
 balance_double: resq 1

[section .data]

 newline: dd 0x0000000a
 charge: dq 0.50

[section .text]

_start:













 xor eax, eax
 mov [withdraw_str], eax












 sub esp, 24
 lea eax, [rb]
 lea ebx, [rb_ptr]
 lea ecx, [rb_byte_pos]
 lea edx, [withdraw_str]
 lea esi, [withdraw_strlen]
 xor edi, edi
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov [esp + 16], esi
 mov [esp + 20], edi
 call read4096b_stdin
 add esp, 24








 sub esp, 8
 lea eax, [withdraw_str]
 mov ebx, [withdraw_strlen]
 mov [esp ], eax
 mov [esp + 4], ebx
 call cvt_string2int
 add esp, 8
 mov [withdraw_int], eax














 xor eax, eax
 mov [balance_str], eax












 sub esp, 24
 lea eax, [rb]
 lea ebx, [rb_ptr]
 lea ecx, [rb_byte_pos]
 lea edx, [balance_str]
 lea esi, [balance_strlen]
 xor edi, edi
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov [esp + 16], esi
 mov [esp + 20], edi
 call read4096b_stdin
 add esp, 24








 sub esp, 8
 lea eax, [balance_str]
 mov ebx, [balance_strlen]
 mov [esp ], eax
 mov [esp + 4], ebx
 call cvt_string2double
 add esp, 8
 fst qword [balance_double]















 mov eax, [withdraw_int]
 mov ebx, 5
 xor edx, edx
 div ebx
 cmp edx, 0
 je .withdraw_is_mult_5


.withdraw_is_not_mult_5:







 jmp .exit


.withdraw_is_mult_5:



















 finit
 fld qword [balance_double]
 fsub qword [charge]
 fild dword [withdraw_int]
 fcomi st0, st1
 jbe .bal_sufficient


.bal_not_sufficient:







 jmp .exit


.bal_sufficient:
















 fxch st0, st1
 fsub st1
 fst qword [balance_double]















 xor eax, eax
 mov [balance_str ], eax
 mov [balance_str+4], eax
 mov [balance_strlen], eax










 sub esp, 20
 mov eax, [balance_double ]
 mov ebx, [balance_double+4]
 mov ecx, 100
 lea edx, [balance_str]
 lea esi, [balance_strlen]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov [esp + 16], esi
 call cvt_double2string
 add esp, 20


.exit:


















 sub esp, 16
 lea eax, [balance_str]
 lea ebx, [balance_strlen]
 lea ecx, [newline]
 mov edx, 1
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call string_append
 add esp, 16







 mov eax, 0x04
 mov ebx, 0x01
 lea ecx, [balance_str]
 mov edx, [balance_strlen]
 int 0x80

 mov eax, 0x01
 xor ebx, ebx
 int 0x80





cvt_dec2hex:




.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]

.setup_localvariables:
 sub esp, 36
 mov [esp ], eax
 mov dword [esp + 4], 0
 mov dword [esp + 8], 0
 mov dword [esp + 12], 0
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0







 mov eax, [esp ]
 shr eax, 4
 mov [esp + 4], eax







 mov eax, [esp ]
 shr eax, 8
 mov ebx, 0xa
 xor edx, edx
 mul ebx
 mov [esp + 8], eax







 mov eax, [esp ]
 shr eax, 12
 mov ebx, 0x64
 xor edx, edx
 mul ebx
 mov [esp + 12], eax







 mov eax, [esp ]
 shr eax, 16
 mov ebx, 0x3e8
 xor edx, edx
 mul ebx
 mov [esp + 16], eax







 mov eax, [esp ]
 shr eax, 20
 mov ebx, 0x2710
 xor edx, edx
 mul ebx
 mov [esp + 20], eax







 mov eax, [esp ]
 shr eax, 24
 mov ebx, 0x186a0
 xor edx, edx
 mul ebx
 mov [esp + 24], eax







 mov eax, [esp ]
 shr eax, 28
 mov ebx, 0xf4240
 xor edx, edx
 mul ebx
 mov [esp + 28], eax







 mov eax, [esp + 4]
 mov ebx, [esp + 8]
 mov ecx, [esp + 12]
 mov edx, [esp + 16]
 mov esi, [esp + 20]
 mov edi, [esp + 24]
 add eax, ebx
 add eax, ecx
 add eax, edx
 add eax, esi
 add eax, edi
 mov ebx, 0x6
 mov ecx, [esp + 28]
 xor edx, edx
 add eax, ecx
 mul ebx
 mov [esp + 32], eax







 mov eax, [esp ]
 mov ebx, [esp + 32]
 sub eax, ebx


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_dec2string:







.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov edx, [ebp + 12]

.setup_localvariables:
 sub esp, 52
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
















 mov eax, [esp + 4]
 cmp eax, 2
 je .skip_decimal_x_1_block
.goto_decimal_x_1_block:
 jmp .decimal_x_1_block
.skip_decimal_x_1_block:







.decimal_x_2_blocks:







 mov eax, [esp]
 mov eax, [eax]
 mov [esp + 20], eax







 mov eax, [esp]
 add eax, 4
 mov eax, [eax]
 mov [esp + 24], eax







 mov eax, 8
 mov [esp + 28], eax


















 mov eax, [esp + 24]
 mov [esp + 36], eax


.loop_1:







 mov eax, [esp + 36]
 shr eax, 4
 mov [esp + 36], eax







 mov eax, [esp + 32]
 add eax, 1
 mov [esp + 32], eax








 mov eax, [esp + 36]
 cmp eax, 0
 jne .loop_1


.endloop_1:

















 mov eax, [esp + 32]
 mov [esp + 40], eax


.loop_2:







 mov eax, [esp + 40]
 sub eax, 1
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 24]
 shr eax, cl
 and eax, 0x0f
 or eax, 0x30
 mov [esp + 44], eax







 mov eax, [esp + 48]
 mov ebx, 8
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 44]
 shl eax, cl
 mov ecx, [esp + 8]
 mov ebx, [ecx]
 or eax, ebx
 mov [ecx], eax







 mov eax, [esp + 16]
 add eax, 1
 mov [esp + 16], eax







 mov eax, [esp + 48]
 add eax, 1
 mov [esp + 48], eax







 mov eax, [esp + 40]
 sub eax, 1
 mov [esp + 40], eax








 mov eax, [esp + 40]
 cmp eax, 0
 jne .loop_2


.endloop_2:

















 mov eax, [esp + 28]
 mov [esp + 40], eax


.loop_3:







 mov eax, [esp + 40]
 sub eax, 1
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 20]
 shr eax, cl
 and eax, 0x0f
 or eax, 0x30
 mov [esp + 44], eax







 mov eax, [esp + 48]
 mov ebx, 8
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 44]
 shl eax, cl
 mov ecx, [esp + 8]
 mov ebx, [ecx]
 or eax, ebx
 mov [ecx], eax







 mov eax, [esp + 16]
 add eax, 1
 mov [esp + 16], eax







 mov eax, [esp + 48]
 add eax, 1
 mov [esp + 48], eax

















 mov eax, [esp + 48]
 cmp eax, 4
 jne .cond1_out_string_not_full


.cond1_out_string_full:







 mov eax, [esp + 8]
 add eax, 4
 mov [esp + 8], eax







 xor eax, eax
 mov [esp + 48], eax


.cond1_out_string_not_full:







 mov eax, [esp + 40]
 sub eax, 1
 mov [esp + 40], eax








 mov eax, [esp + 40]
 cmp eax, 0
 jne .loop_3


.endloop_3:









 jmp .save_out_strlen








.decimal_x_1_block:







 mov eax, [esp ]
 mov eax, [eax]
 mov [esp + 20], eax


















 mov eax, [esp + 20]
 mov [esp + 36], eax


.loop_4:







 mov eax, [esp + 36]
 shr eax, 4
 mov [esp + 36], eax







 mov eax, [esp + 28]
 add eax, 1
 mov [esp + 28], eax








 mov eax, [esp + 36]
 cmp eax, 0
 jne .loop_4


.endloop_4:

















 mov eax, [esp + 28]
 mov [esp + 40], eax


.loop_5:







 mov eax, [esp + 40]
 sub eax, 1
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 20]
 shr eax, cl
 and eax, 0x0f
 or eax, 0x30
 mov [esp + 44], eax







 mov eax, [esp + 48]
 mov ebx, 8
 xor edx, edx
 mul ebx
 mov ecx, eax
 mov eax, [esp + 44]
 shl eax, cl
 mov ecx, [esp + 8]
 mov ebx, [ecx]
 or eax, ebx
 mov [ecx], eax







 mov eax, [esp + 16]
 add eax, 1
 mov [esp + 16], eax







 mov eax, [esp + 48]
 add eax, 1
 mov [esp + 48], eax

















 mov eax, [esp + 48]
 cmp eax, 4
 jne .cond2_out_string_not_full


.cond2_out_string_full:







 mov eax, [esp + 8]
 add eax, 4
 mov [esp + 8], eax







 xor eax, eax
 mov [esp + 48], eax


.cond2_out_string_not_full:







 mov eax, [esp + 40]
 sub eax, 1
 mov [esp + 40], eax








 mov eax, [esp + 40]
 cmp eax, 0
 jne .loop_5


.endloop_5:







.save_out_strlen:







 mov eax, [esp + 16]
 mov ebx, [esp + 12]
 mov [ebx], eax


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_double2string:







.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arg_set_local_variables:
 sub esp, 92
 add ebp, 8

 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx

 mov eax, [ebp + 12]
 mov ebx, [ebp + 16]
 mov [esp + 12], eax
 mov [esp + 16], ebx

 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
 mov dword [esp + 52], 0x2e
 mov dword [esp + 56], 0
 mov dword [esp + 60], 0x30303030
 mov dword [esp + 64], 0x30303030
 mov dword [esp + 68], 0





















 finit















































 fstcw word [esp + 44]
 mov ax, [esp + 44]
 or eax, 110000000000B
 mov [esp + 44], ax
 fldcw word [esp + 44]










 fld qword [esp]











 fist dword [esp + 20]





















 finit



























 fld qword [esp]



























 fild dword [esp + 20]





































 fsub






























 fild dword [esp + 8]
































 fmul





















 fistp qword [esp + 24]



















 mov eax, [esp + 24]
 and eax, 0x80000000
 cmp eax, 0x80000000
 jne .decimal_part_is_pos


.decimal_part_is_neg:










 mov eax, [esp + 24]
 not eax
 add eax, 1
 mov [esp + 24], eax












 mov eax, -1
 mov [esp + 48], eax
 jmp .end_decimal_part_check_sign


.decimal_part_is_pos:












 mov eax, 1
 mov [esp + 48], eax


.end_decimal_part_check_sign:












 sub esp, 16
 mov ebx, esp
 mov ecx, esp
 mov eax, [esp + 16 + 24]
 add ebx, (16 + 32)
 add ecx, (16 + 40)
 xor edx, edx
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call cvt_int2string
 add esp, 16








































 mov eax, [esp + 24]
 mov ebx, [esp + 8]
 cmp eax, ebx
 jne .dont_round_integer_part


.round_integer_part:













 mov eax, [esp + 20]
 mov ebx, [esp + 48]
 add eax, ebx
 mov [esp + 20], eax







 mov eax, [esp + 32]
 and eax, 0xfffffff0
 mov [esp + 32], eax







 mov ebx, [esp + 40]
 sub ebx, 1
 mov [esp + 40], ebx


.dont_round_integer_part:


























 sub esp, 16
 mov eax, [esp + (16 + 20)]
 mov ebx, [esp + (16 + 12)]
 mov ecx, [esp + (16 + 16)]
 mov edx, 1
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call cvt_int2string
 add esp, 16


















 sub esp, 16
 mov ecx, esp
 mov eax, [esp + (16 + 12)]
 mov ebx, [esp + (16 + 16)]
 add ecx, (16 + 52)
 mov edx, 1
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call string_append
 add esp, 16
































 sub esp, 8
 mov eax, 10
 mov ebx, [esp + (8 + 40)]
 mov [esp ], eax
 mov [esp + 4], ebx
 call pow_int
 add esp, 8
 mov [esp + 56], eax











 mov eax, [esp + 56]
 mov ebx, [esp + 8]
 cmp eax, ebx
 jge .dont_insert_heading_zeroes


.insert_heading_zeroes:


.loop_1:










 mov eax, [esp + 56]
 mov ebx, 10
 xor edx, edx
 mul ebx
 mov [esp + 56], eax







 mov eax, [esp + 68]
 add eax, 1
 mov [esp + 68], eax







 mov eax, [esp + 56]
 mov ebx, [esp + 8]
 cmp eax, ebx
 jne .loop_1


.endloop:













 sub esp, 16
 mov ecx, esp
 mov eax, [esp + (16 + 12)]
 mov ebx, [esp + (16 + 16)]
 add ecx, (16 + 60)
 mov edx, [esp + (16 + 68)]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call string_append
 add esp, 16


.dont_insert_heading_zeroes:












 sub esp, 16
 mov ecx, esp
 mov eax, [esp + (16 + 12)]
 mov ebx, [esp + (16 + 16)]
 add ecx, (16 + 32)
 mov edx, [esp + (16 + 40)]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call string_append
 add esp, 16


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_hex2dec:




.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp]

.setup_localvariables:
 sub esp, 80
 mov [esp ], eax
 mov dword [esp + 4], 0
 mov dword [esp + 8], 0
 mov dword [esp + 12], 0
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
 mov dword [esp + 52], 0
 mov dword [esp + 56], 0
 mov dword [esp + 60], 0
 mov dword [esp + 64], 0
 mov dword [esp + 68], 0
 mov dword [esp + 72], 0
 mov dword [esp + 76], 0







 mov eax, [esp ]
 mov ebx, 1000000000
 xor edx, edx
 div ebx
 mov [esp + 8], eax







 mov eax, [esp + 8]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 12], eax







 mov eax, [esp ]
 mov ebx, 100000000
 xor edx, edx
 div ebx
 mov ebx, [esp + 12]
 add eax, ebx
 mov [esp + 16], eax







 mov eax, [esp + 16]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 20], eax







 mov eax, [esp ]
 mov ebx, 10000000
 xor edx, edx
 div ebx
 mov ebx, [esp + 20]
 add eax, ebx
 mov [esp + 24], eax







 mov eax, [esp + 24]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 28], eax







 mov eax, [esp ]
 mov ebx, 1000000
 xor edx, edx
 div ebx
 mov ebx, [esp + 28]
 add eax, ebx
 mov [esp + 32], eax







 mov eax, [esp + 32]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 36], eax







 mov eax, [esp ]
 mov ebx, 100000
 xor edx, edx
 div ebx
 mov ebx, [esp + 36]
 add eax, ebx
 mov [esp + 40], eax







 mov eax, [esp + 40]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 44], eax







 mov eax, [esp ]
 mov ebx, 10000
 xor edx, edx
 div ebx
 mov ebx, [esp + 44]
 add eax, ebx
 mov [esp + 48], eax







 mov eax, [esp + 48]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 52], eax







 mov eax, [esp ]
 mov ebx, 1000
 xor edx, edx
 div ebx
 mov ebx, [esp + 52]
 add eax, ebx
 mov [esp + 56], eax







 mov eax, [esp + 56]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 60], eax







 mov eax, [esp ]
 mov ebx, 100
 xor edx, edx
 div ebx
 mov ebx, [esp + 60]
 add eax, ebx
 mov [esp + 64], eax







 mov eax, [esp + 64]
 mov ebx, 16
 xor edx, edx
 mul ebx
 mov [esp + 68], eax







 mov eax, [esp ]
 mov ebx, 10
 xor edx, edx
 div ebx
 mov ebx, [esp + 68]
 add eax, ebx
 mov [esp + 72], eax







 mov eax, [esp + 72]
 mov ebx, 6
 xor edx, edx
 mul ebx
 mov [esp + 76], eax







 mov eax, [esp ]
 mov ebx, [esp + 76]
 add eax, ebx
 mov [esp + 4], eax







.return:
 mov eax, [esp + 4]


.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_int2string:







.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov edx, [ebp + 12]

.set_local_variables:
 sub esp, 56
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
 mov dword [esp + 52], 0














 sub esp, 8
 mov eax, [esp + 8 ]
 mov ebx, [esp + 8 + 12]
 mov [esp ], eax
 mov [esp + 4], ebx
 call find_int_digits
 add esp, 8
 mov [esp + 16], eax















 mov eax, [esp + 12]
 cmp eax, 1
 jne .flag_notequal_1









.flag_equal_1:








 mov eax, [esp ]
 and eax, 0x80000000
 cmp eax, 0x80000000
 jne .sign_false









.sign_true:









 mov eax, [esp]
 not eax
 add eax, 1
 mov [esp], eax









 mov eax, 1
 mov [esp + 52], eax









.sign_false:









.flag_notequal_1:













 mov eax, [esp + 16]
 cmp eax, 8
 jg .skip_int_x_len_le_8
.goto_int_x_len_le_8:
 jmp .integer_x_len_lessequal_8
.skip_int_x_len_le_8:


.integer_x_len_morethan_8:







 mov eax, [esp ]
 mov ebx, 100000000
 xor edx, edx
 div ebx
 mov [esp + 20], eax







 mov [esp + 24], edx







 sub esp, 4
 mov eax, [esp + 4 + 24]
 mov [esp ], eax
 call cvt_hex2dec
 add esp, 4
 mov [esp + 28], eax







 sub esp, 4
 mov eax, [esp + 4 + 20]
 mov [esp ], eax
 call cvt_hex2dec
 add esp, 4
 mov [esp + 32], eax










 sub esp, 16
 mov eax, esp
 mov ecx, esp
 mov edx, esp
 add eax, (16+28)
 mov ebx, 2
 add ecx, (16+36)
 add edx, (16+48)
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call cvt_dec2string
 add esp, 16







 jmp .skip_integer_x_len_equalmore_8


.integer_x_len_lessequal_8:







 sub esp, 4
 mov eax, [esp + 4 ]
 mov [esp ], eax
 call cvt_hex2dec
 add esp, 4
 mov [esp + 28], eax










 sub esp, 16
 mov eax, esp
 mov ecx, esp
 mov edx, esp
 add eax, (16+28)
 mov ebx, 1
 add ecx, (16+36)
 add edx, (16+48)
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call cvt_dec2string
 add esp, 16


.skip_integer_x_len_equalmore_8:








 mov eax, [esp + 52]
 cmp eax, 1
 jne .is_negative_false


.is_negative_true:







 mov eax, [esp + 4]
 mov ebx, 0x2d
 mov [eax], ebx







 mov ebx, [esp + 8]
 mov eax, [ebx]
 add eax, 1
 mov [ebx], eax

.is_negative_false:










 sub esp, 16
 mov eax, [esp + (16 + 4)]
 mov ebx, [esp + (16 + 8)]
 mov ecx, esp
 add ecx, (16 + 36)
 mov edx, [esp + (16 + 48)]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call string_append
 add esp, 16


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_string2dec:







.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_parameters:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov edx, [ebp + 12]

.set_localvariables:
 sub esp, 48
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0







 mov eax, [esp ]
 mov [esp + 16], eax







 mov eax, [esp + 16]
 mov ebx, [eax]
 mov [esp + 20], ebx







 mov eax, [esp + 4]
 mov [esp + 44], eax










 mov eax, [esp + 4]
 cmp eax, 0
 jne .strlen_not_zero
.strlen_zero:
 jmp .return
.strlen_not_zero:








 mov eax, [esp + 4]
 mov ebx, 8
 cmp eax, ebx
 jg .decimal_num_2_blocks


.decimal_num_1_block:







 mov eax, [esp + 4]
 sub eax, 1
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov [esp + 32], eax







 mov eax, [esp + 8]
 mov [esp + 24], eax







 jmp .loop_get_decimal


.decimal_num_2_blocks:







 mov eax, [esp + 4]
 sub eax, 9
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov [esp + 32], eax







 mov eax, [esp + 8]
 mov ebx, 4
 add eax, ebx
 mov [esp + 24], eax


.loop_get_decimal:










 mov eax, [esp + 20]
 cmp eax, 0
 jne .in_buffer_not_empty


.in_buffer_empty:







 mov eax, [esp + 16]
 add eax, 4
 mov [esp + 16], eax







 mov eax, [esp + 16]
 mov ebx, [eax]
 mov [esp + 20], ebx


.in_buffer_not_empty:










 mov eax, [esp + 32]
 cmp eax, -4
 jne .out_buffer_not_full


.out_buffer_full:







 mov eax, [esp + 28]
 mov ebx, [esp + 24]
 mov [ebx], eax







 mov eax, [esp + 24]
 sub eax, 4
 mov [esp + 24], eax







 xor eax, eax
 mov [esp + 28], eax







 mov eax, 28
 mov [esp + 32], eax


.out_buffer_not_full:









 mov eax, [esp + 20]
 and eax, 0x0000000f
 mov [esp + 36], eax







 mov eax, [esp + 20]
 shr eax, 8
 mov [esp + 20], eax









 mov eax, [esp + 36]
 mov ecx, [esp + 32]
 shl eax, cl
 mov ebx, [esp + 28]
 or eax, ebx
 mov [esp + 28], eax







 mov eax, [esp + 32]
 sub eax, 4
 mov [esp + 32], eax







 mov eax, [esp+ 40]
 add eax, 1
 mov [esp + 40], eax







 mov eax, [esp + 44]
 sub eax, 1
 mov [esp + 44], eax








 mov eax, [esp + 44]
 cmp eax, 0
 jne .loop_get_decimal


.endloop_get_decimal:









 mov eax, [esp + 28]
 mov ebx, [esp + 24]
 mov [ebx], eax







 mov eax, [esp + 40]
 mov ebx, [esp + 12]
 mov [ebx], eax


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_string2double:





.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]

.setup_localvariables:
 sub esp, 56
 mov [esp ], eax
 mov [esp + 4], ebx
 mov dword [esp + 8], 0
 mov dword [esp + 12], 0
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
 mov dword [esp + 52], 0















 mov esi, [esp]












 mov al, [esi]
 cmp al, 0x2d
 jne .positive
.negative:
 mov eax, 1
 mov [esp + 56], eax
 add esi, 1
.positive:







 lea edi, [esp + 8]


.loop_get_intpt:








 lodsb
 cmp al, 0x2e
 je .endloop_get_intpt








 mov [edi], al
 add edi, 1







 mov eax, [esp + 20]
 add eax, 1
 mov [esp + 20], eax







 jmp .loop_get_intpt


.endloop_get_intpt:







 lea edi, [esp + 28]













 mov ecx, [esp + 52]
.loop_count_heading_zeroes:
 lodsb
 cmp al, 0x30
 jne .endloop_count_heading_zeroes
 add ecx, 1
 jmp .loop_count_heading_zeroes
.endloop_count_heading_zeroes:
 mov [esp + 52], ecx
 sub esi, 1


.loop_get_decpt:








 lodsb
 cmp al, 0x00
 je .endloop_get_decpt








 mov [edi], al
 add edi, 1







 mov eax, [esp + 40]
 add eax, 1
 mov [esp + 40], eax







 jmp .loop_get_decpt


.endloop_get_decpt:















 sub esp, 8
 lea eax, [esp + (8 + 8)]
 mov ebx, [esp + (8 + 20)]
 mov [esp ], eax
 mov [esp + 4], ebx
 call cvt_string2int
 add esp, 8
 mov [esp + 24], eax







 sub esp, 8
 lea eax, [esp + (8 + 28)]
 mov ebx, [esp + (8 + 40)]
 mov [esp ], eax
 mov [esp + 4], ebx
 call cvt_string2int
 add esp, 8
 mov [esp + 44], eax








 sub esp, 8
 mov eax, [esp + (8 + 44)]
 xor ebx, ebx
 mov [esp ], eax
 mov [esp + 4], ebx
 call find_int_digits
 add esp, 8


 mov ebx, [esp + 52]
 add eax, ebx
 mov [esp + 48], eax

 sub esp, 8
 mov eax, 10
 mov ebx, [esp + (8 + 48)]
 mov [esp ], eax
 mov [esp + 4], ebx
 call pow_int
 add esp, 8
 mov [esp + 48], eax









 fild dword [esp + 48]
 fild dword [esp + 44]
 fdiv st1
















 fild dword [esp + 24]
 fadd st1










 mov eax, [esp + 56]
 cmp eax, 0
 je .is_positive
.is_negative:
 fchs
.is_positive:


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





cvt_string2int:





.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]

.setup_localvariables:
 sub esp, 28
 mov [esp ], eax
 mov [esp + 4], ebx
 mov dword [esp + 8], 0
 mov dword [esp + 12], 0
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0










 sub esp, 16
 mov eax, [esp + 16 ]
 mov ebx, [esp + (16 + 4)]
 lea ecx, [esp + (16 + 8)]
 lea edx, [esp + (16 + 16)]
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 call cvt_string2dec
 add esp, 16







 sub esp, 4
 mov eax, [esp + (4 + 8)]
 mov [esp ], eax
 call cvt_dec2hex
 add esp, 4
 mov [esp + 20], eax







 mov eax, [esp + 16]
 cmp eax, 8
 jbe .digits_le_8


.digits_gt_8:







 sub esp, 4
 mov eax, [esp + (4 + 12)]
 mov [esp ], eax
 call cvt_dec2hex
 add esp, 4
 mov [esp + 24], eax









 sub esp, 8
 mov eax, 10
 mov ebx, [esp + (8 + 16)]
 sub ebx, 2
 mov [esp ], eax
 mov [esp + 4], ebx
 call pow_int
 add esp, 8


 mov ebx, [esp + 24]
 xor edx, edx
 mul ebx

 mov ebx, [esp + 20]
 add eax, ebx

 mov [esp + 20], eax


.digits_le_8:







 mov eax, [esp + 20]


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





read4096b_stdin:









.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov edx, [ebp + 12]
 mov esi, [ebp + 16]
 mov edi, [ebp + 20]

.setup_localvariables:
 sub esp, 40
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov [esp + 16], esi
 mov [esp + 20], edi
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0







 mov eax, [esp + 20]
 cmp eax, 1
 je .flag_1


.flag_0:







 mov eax, 0x0a
 mov [esp + 24], eax







 mov eax, 0x20
 mov [esp + 28], eax







 jmp .endflag_checks


.flag_1:







 mov eax, 0x0a
 mov [esp + 24], eax







 mov eax, 0x0a
 mov [esp + 28], eax


.endflag_checks:







 mov ebx, [esp + 8]
 mov eax, [ebx]
 mov [esp + 32], eax







 mov edi, [esp + 12]











 mov ebx, [esp + 4]
 mov eax, [ebx]
 cmp eax, 0
 je .dont_init_ESI
.init_ESI:
 mov esi, eax







 lodsb
 sub esi, 1
 cmp al, 0
 je .rb_empty
.dont_init_ESI:







 mov eax, [esp + 32]
 cmp eax, 0
 je .rb_empty







 mov eax, [esp + 32]
 cmp eax, 4096
 jne .rb_not_empty


.rb_empty:







 mov eax, 0x03
 xor ebx, ebx
 mov ecx, [esp]
 mov edx, 4096
 int 0x80







 mov ebx, [esp + 8]
 xor eax, eax
 mov [ebx], eax







 mov eax, [esp ]
 mov ebx, [esp + 4]
 mov [ebx], eax







 mov esi, [esp]
 cld


.rb_not_empty:

.loop_getdata:







 lodsb







 mov ebx, [esp + 32]
 add ebx, 1
 mov [esp + 32], ebx







 mov ebx, [esp + 24]
 cmp al, bl
 je .endloop_getdata







 mov ebx, [esp + 28]
 cmp al, bl
 je .endloop_getdata








 mov [edi], al
 add edi, 1







 mov eax, [esp + 36]
 add eax, 1
 mov [esp + 36], eax







 mov eax, [esp + 32]
 cmp eax, 4096
 je .rb_empty







 jmp .loop_getdata

.endloop_getdata:







 mov ebx, [esp + 4]
 mov [ebx], esi







 mov eax, [esp + 32]
 mov ebx, [esp + 8]
 mov [ebx], eax







 mov eax, [esp + 36]
 mov ebx, [esp + 16]
 mov [ebx], eax


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





find_int_digits:





.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]

.set_localvariables:
 sub esp, 16
 mov [esp ], eax
 mov [esp + 4], ebx
 mov dword [esp + 8], 0





























 mov eax, [esp + 4]
 cmp eax, 1
 jne .integer_x_is_unsigned


.integer_x_is_signed:










 mov eax, [esp]
 and eax, 0x80000000
 cmp eax, 0
 je .integer_x_is_positive


.integer_x_is_negative:










 mov eax, [esp]
 not eax
 mov [esp], eax
 mov eax, [esp]
 add eax, 1
 mov [esp], eax


.integer_x_is_positive:
.integer_x_is_unsigned:











 mov eax, [esp]








 cmp eax, 10
 jb .jumper_10








 cmp eax, 100
 jb .jumper_100








 cmp eax, 1000
 jb .jumper_1000








 cmp eax, 10000
 jb .jumper_10000








 cmp eax, 100000
 jb .jumper_100000








 cmp eax, 1000000
 jb .jumper_1000000








 cmp eax, 10000000
 jb .jumper_10000000








 cmp eax, 100000000
 jb .jumper_100000000








 cmp eax, 1000000000
 jb .jumper_1000000000








 jmp .more_equal_1000000000









.jumper_10:







 jmp .less_than_10


.jumper_100:







 jmp .less_than_100


.jumper_1000:







 jmp .less_than_1000


.jumper_10000:







 jmp .less_than_10000


.jumper_100000:







 jmp .less_than_100000


.jumper_1000000:







 jmp .less_than_1000000


.jumper_10000000:







 jmp .less_than_10000000


.jumper_100000000:







 jmp .less_than_100000000


.jumper_1000000000:







 jmp .less_than_1000000000









.less_than_10:








 mov dword [esp + 8], 1
 jmp .endcondition


.less_than_100:








 mov dword [esp + 8], 2
 jmp .endcondition


.less_than_1000:








 mov dword [esp + 8], 3
 jmp .endcondition


.less_than_10000:








 mov dword [esp + 8], 4
 jmp .endcondition


.less_than_100000:








 mov dword [esp + 8], 5
 jmp .endcondition


.less_than_1000000:








 mov dword [esp + 8], 6
 jmp .endcondition


.less_than_10000000:








 mov dword [esp + 8], 7
 jmp .endcondition


.less_than_100000000:








 mov dword [esp + 8], 8
 jmp .endcondition


.less_than_1000000000:








 mov dword [esp + 8], 9
 jmp .endcondition


.more_equal_1000000000:








 mov dword [esp + 8], 10


.endcondition:


.return:







 mov eax, [esp + 8]


.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





pow_int:





.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]

.set_local_variables:
 sub esp, 16
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ebx
 mov dword [esp + 12], 1


.loop_1:







 mov eax, [esp + 12]
 mov ebx, [esp ]
 xor edx, edx
 mul ebx
 mov [esp + 12], eax







 mov eax, [esp + 8]
 sub eax, 1
 mov [esp + 8], eax








 mov eax, [esp + 8]
 cmp eax, 0
 jne .loop_1


.endloop_1:


.return:







 mov eax, [esp + 12]


.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret





string_append:







.setup_stackframe:
 sub esp, 4
 mov [esp], ebp
 mov ebp, esp

.get_arguments:
 add ebp, 8
 mov eax, [ebp ]
 mov ebx, [ebp + 4]
 mov ecx, [ebp + 8]
 mov edx, [ebp + 12]

.set_local_variables:
 sub esp, 56
 mov [esp ], eax
 mov [esp + 4], ebx
 mov [esp + 8], ecx
 mov [esp + 12], edx
 mov dword [esp + 16], 0
 mov dword [esp + 20], 0
 mov dword [esp + 24], 0
 mov dword [esp + 28], 0
 mov dword [esp + 32], 0
 mov dword [esp + 36], 0
 mov dword [esp + 40], 0
 mov dword [esp + 44], 0
 mov dword [esp + 48], 0
 mov dword [esp + 52], 0

































 mov eax, [esp + 8]
 mov [esp + 32], eax









 mov ebx, [esp + 32]
 mov eax, [ebx]
 mov [esp + 36], eax













 mov ebx, [esp + 4]
 mov eax, [ebx]
 mov [esp + 16], eax






































 mov eax, [esp + 16]
 mov ebx, 4
 xor edx, edx
 div ebx
 mov [esp + 20], eax










 mov eax, [esp + 20]
 mov ebx, 4
 xor edx, edx
 mul ebx
 mov [esp + 24], eax
































 mov eax, [esp ]
 mov ebx, [esp + 24]
 add eax, ebx
 mov [esp + 28], eax








 mov ebx, [esp + 28]
 mov eax, [ebx]
 mov [esp + 40], eax














































 mov eax, [esp + 16]
 mov ebx, [esp + 24]
 sub eax, ebx
 mov ebx, 8
 xor edx, edx
 mul ebx
 mov [esp + 44], eax

















 mov eax, [esp + 12]
 mov [esp + 48], eax











.loop_1:




















 mov eax, [esp + 44]
 cmp eax, 32
 jne .endcond_1







.cond_1:









 mov eax, [esp + 40]
 mov ebx, [esp + 28]
 mov [ebx], eax









 mov eax, [esp + 28]
 add eax, 4
 mov [esp + 28], eax









 xor eax, eax
 mov [esp + 40], eax









 xor eax, eax
 mov [esp + 44], eax


.endcond_1:


















 mov eax, [esp + 36]
 cmp eax, 0
 jne .endcond_2







.cond_2:









 mov eax, [esp + 32]
 add eax, 4
 mov [esp + 32], eax









 mov ebx, [esp + 32]
 mov eax, [ebx]
 mov [esp + 36], eax


.endcond_2:
















 mov ecx, [esp + 44]
 mov eax, [esp + 36]
 and eax, 0xff
 shl eax, cl
 mov [esp + 52], eax










 mov eax, [esp + 40]
 mov ebx, [esp + 52]
 or eax, ebx
 mov [esp + 40], eax









 mov eax, [esp + 44]
 add eax, 8
 mov [esp + 44], eax









 mov eax, [esp + 16]
 add eax, 1
 mov [esp + 16], eax









 mov eax, [esp + 36]
 shr eax, 8
 mov [esp + 36], eax









 mov eax, [esp + 48]
 sub eax, 1
 mov [esp + 48], eax










 mov eax, [esp + 48]
 cmp eax, 0
 jne .loop_1


.endloop_1:

















 mov ebx, [esp + 28]
 mov eax, [esp + 40]
 mov [ebx], eax









 mov ebx, [esp + 4]
 mov eax, [esp + 16]
 mov [ebx], eax


.return:

.clean_stackframe:
 sub ebp, 8
 mov esp, ebp
 mov ebp, [esp]
 add esp, 4

 ret



