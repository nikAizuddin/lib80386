ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm

# Mathematics

POW_INT = \
  "../../../math/pow_int/src/pow_int.asm"

POW_DOUBLE = \
  "../../../math/pow_double/src/pow_double.asm"

CALCULATE_INTEGER_LENGTH = \
  "../../../math/calculate_integer_length/src/calculate_integer_length.asm"

FORMULA_HEX2DEC = \
  "../../../math/formula_hex2dec/src/formula_hex2dec.asm"

# Input/Output

APPEND_STRING = \
  "../../../io/append_string/src/append_string.asm"

PRINT_DOUBLE2STRING = \
  "../../../io/print_double2string/src/print_double2string.asm"

PRINT_INT2STRING = \
  "../../../io/print_int2string/src/print_int2string.asm"

WRITE_DEC2STRING = \
  "../../../io/write_dec2string/src/write_dec2string.asm"

OBJ = _start.o \
      print_int2string.o \
      calculate_integer_length.o \
      formula_hex2dec.o \
      write_dec2string.o \
      print_double2string.o \
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
		${PRINT_DOUBLE2STRING} \
		-oprint_double2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${PRINT_INT2STRING} \
		-oprint_int2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${CALCULATE_INTEGER_LENGTH} \
		-ocalculate_integer_length.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${WRITE_DEC2STRING} \
		-owrite_dec2string.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${FORMULA_HEX2DEC} \
		-oformula_hex2dec.o \
		-f${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o${BIN} \
		-m${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}

