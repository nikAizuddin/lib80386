ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       = exe
OBJ       = _start.o \
            string_append.o

STRING_APPEND = \
  "../../../../string/string_append/src/string_append.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o_start.o \
		-f${FORMAT}

	@${ASSEMBLER} \
		${STRING_APPEND} \
		-ostring_append.o \
		-f${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o${BIN} \
		-m${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}

