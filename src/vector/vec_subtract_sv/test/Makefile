ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       = exe
OBJ       = test.o \
            vec_subtract_sv.o

VEC_SUBTRACT_SV = \
  "../src/vec_subtract_sv.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o test.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_SUBTRACT_SV} \
		-o vec_subtract_sv.o \
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
