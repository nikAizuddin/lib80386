ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       =  exe
OBJ       = _start.o \
            string_compare.o

STRING_COMPARE = \
  "../../../../string/string_compare/src/string_compare.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${STRING_COMPARE} \
		-o string_compare.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
