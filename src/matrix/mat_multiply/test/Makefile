ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            vec_dotproduct.o \
            mat_multiply.o

VEC_DOTPRODUCT = \
  "../../../vector/vec_dotproduct/src/vec_dotproduct.asm"

MAT_MULTIPLY = \
  "../src/mat_multiply.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o test.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_DOTPRODUCT} \
		-o vec_dotproduct.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_MULTIPLY} \
		-o mat_multiply.o \
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
