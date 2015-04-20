ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            get_vector_info.o \
            vec_dotproduct.o \
            mat_multiply.o

GET_VECTOR_INFO = \
  "../../../vector/get_vector_info/src/get_vector_info.asm"

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
		${GET_VECTOR_INFO} \
		-o get_vector_info.o \
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
