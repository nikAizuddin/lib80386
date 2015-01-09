ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       = exe
OBJ       = _start.o \
            cvt_double2string.o \
            cvt_int2string.o \
            string_append.o \
            pow_int.o \
            find_int_digits.o \
            cvt_hex2dec.o \
            cvt_dec2string.o \

CVT_DOUBLE2STRING = \
  "../../../../converter/cvt_double2string/src/cvt_double2string.asm"

CVT_INT2STRING = \
  "../../../../converter/cvt_int2string/src/cvt_int2string.asm"

STRING_APPEND = \
  "../../../../string/string_append/src/string_append.asm"

POW_INT = \
  "../../../../math/pow_int/src/pow_int.asm"

FIND_INT_DIGITS = \
  "../../../../math/find_int_digits/src/find_int_digits.asm"

CVT_HEX2DEC = \
  "../../../../converter/cvt_hex2dec/src/cvt_hex2dec.asm"

CVT_DEC2STRING = \
  "../../../../converter/cvt_dec2string/src/cvt_dec2string.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DOUBLE2STRING} \
		-o cvt_double2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_INT2STRING} \
		-o cvt_int2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${STRING_APPEND} \
		-o string_append.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${POW_INT} \
		-o pow_int.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${FIND_INT_DIGITS} \
		-o find_int_digits.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_HEX2DEC} \
		-o cvt_hex2dec.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2STRING} \
		-o cvt_dec2string.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}

