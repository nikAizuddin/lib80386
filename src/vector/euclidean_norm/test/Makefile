ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            euclidean_norm.o

EUCLIDEAN_NORM = \
  "../src/euclidean_norm.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o test.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${EUCLIDEAN_NORM} \
		-o euclidean_norm.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
