ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm

# Mathematics

POW_INT = \
  "../../../../math/pow_int/src/pow_int.asm"

POW_DOUBLE = \
  "../../../../math/pow_double/src/pow_double.asm"

CALCULATE_INTEGER_LENGTH = \
  "../../../../math/calculate_integer_length/src/calculate_integer_length.asm"

CVT_HEX2DEC = \
  "../../../../converter/cvt_hex2dec/src/cvt_hex2dec.asm"

# Input/Output

APPEND_STRING = \
  "../../../../string/append_string/src/append_string.asm"

CVT_DOUBLE2STRING = \
  "../../../../converter/cvt_double2string/src/cvt_double2string.asm"

CVT_INT2STRING = \
  "../../../../converter/cvt_int2string/src/cvt_int2string.asm"

CVT_DEC2STRING = \
  "../../../../converter/cvt_dec2string/src/cvt_dec2string.asm"

OBJ = _start.o \
      cvt_int2string.o \
      calculate_integer_length.o \
      cvt_hex2dec.o \
      cvt_dec2string.o \
      cvt_double2string.o \
      append_string.o \
      pow_double.o \
      pow_int.o

BIN = exe

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o_start.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${POW_INT} \
		-opow_int.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${POW_DOUBLE} \
		-opow_double.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${APPEND_STRING} \
		-oappend_string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CVT_DOUBLE2STRING} \
		-ocvt_double2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CVT_INT2STRING} \
		-ocvt_int2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CALCULATE_INTEGER_LENGTH} \
		-ocalculate_integer_length.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2STRING} \
		-ocvt_dec2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CVT_HEX2DEC} \
		-ocvt_hex2dec.o \
		-f${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o${BIN} \
		-m${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}

