ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       =  exe
OBJ       = _start.o \
            cvt_string2double.o \
            cvt_string2int.o \
            cvt_string2dec.o \
            cvt_dec2hex.o \
            pow_int.o \
            find_int_digits.o

CVT_STRING2DOUBLE = \
  "../../../converter/cvt_string2double/src/cvt_string2double.asm"

CVT_STRING2INT = \
  "../../../converter/cvt_string2int/src/cvt_string2int.asm"

CVT_STRING2DEC = \
  "../../../converter/cvt_string2dec/src/cvt_string2dec.asm"

CVT_DEC2HEX = \
  "../../../converter/cvt_dec2hex/src/cvt_dec2hex.asm"

POW_INT = \
  "../../../math/pow_int/src/pow_int.asm"

FIND_INT_DIGITS = \
  "../../../math/find_int_digits/src/find_int_digits.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_STRING2DOUBLE} \
		-o cvt_string2double.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_STRING2INT} \
		-o cvt_string2int.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_STRING2DEC} \
		-o cvt_string2dec.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2HEX} \
		-o cvt_dec2hex.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${POW_INT} \
		-o pow_int.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${FIND_INT_DIGITS} \
		-o find_int_digits.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
