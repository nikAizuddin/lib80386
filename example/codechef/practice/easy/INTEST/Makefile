ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/_start.asm
BIN       = bin/exe
OBJ       = build/_start.o \
            build/read4096b_stdin.o \
            build/string_append.o \
            build/cvt_string2int.o \
            build/cvt_string2dec.o \
            build/cvt_dec2hex.o \
            build/cvt_hex2dec.o \
            build/cvt_dec2string.o \
            build/cvt_int2string.o \
            build/find_int_digits.o \
            build/pow_int.o

READ4096B_STDIN = \
"../../../../../src/io/read4096b_stdin/src/read4096b_stdin.asm"

STRING_APPEND = \
"../../../../../src/string/string_append/src/string_append.asm"

CVT_STRING2INT = \
"../../../../../src/converter/cvt_string2int/src/cvt_string2int.asm"

CVT_STRING2DEC = \
"../../../../../src/converter/cvt_string2dec/src/cvt_string2dec.asm"

CVT_DEC2HEX = \
"../../../../../src/converter/cvt_dec2hex/src/cvt_dec2hex.asm"

CVT_HEX2DEC = \
"../../../../../src/converter/cvt_hex2dec/src/cvt_hex2dec.asm"

CVT_DEC2STRING = \
"../../../../../src/converter/cvt_dec2string/src/cvt_dec2string.asm"

CVT_INT2STRING = \
"../../../../../src/converter/cvt_int2string/src/cvt_int2string.asm"

FIND_INT_DIGITS = \
"../../../../../src/math/find_int_digits/src/find_int_digits.asm"

POW_INT = \
"../../../../../src/math/pow_int/src/pow_int.asm"

.PHONY: all clean

all:
	@mkdir -p bin
	@mkdir -p build

	@${ASSEMBLER} \
		${_START} \
		-o build/_start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${READ4096B_STDIN} \
		-o build/read4096b_stdin.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${STRING_APPEND} \
		-o build/string_append.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_STRING2INT} \
		-o build/cvt_string2int.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_STRING2DEC} \
		-o build/cvt_string2dec.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2HEX} \
		-o build/cvt_dec2hex.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_HEX2DEC} \
		-o build/cvt_hex2dec.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2STRING} \
		-o build/cvt_dec2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_INT2STRING} \
		-o build/cvt_int2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${FIND_INT_DIGITS} \
		-o build/find_int_digits.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${POW_INT} \
		-o build/pow_int.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
	@rm -r \
		bin \
		build
