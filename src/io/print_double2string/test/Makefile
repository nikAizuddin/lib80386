ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       = exe
OBJ       = _start.o \
            print_double2string.o \
            print_int2string.o \
            append_string.o \
            pow_int.o

PRINT_DOUBLE2STRING = \
  "../../../io/print_double2string/src/print_double2string.asm"

PRINT_INT2STRING = \
  "../../../io/print_int2string/src/print_int2string.asm"

APPEND_STRING = \
  "../../../io/append_string/src/append_string.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o_start.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${APPEND_STRING} \
		-oappend_string.o \
		-f${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o${BIN} \
		-m${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}

