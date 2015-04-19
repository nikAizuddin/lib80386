ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            mat_get_element.o \
            get_vector_info.o \
            vec_multiply_elements.o

MAT_GET_ELEMENT = \
  "../../../matrix/mat_get_element/src/mat_get_element.asm"

GET_VECTOR_INFO = \
  "../../get_vector_info/src/get_vector_info.asm"

VEC_MULTIPLY_ELEMENTS = \
  "../src/vec_multiply_elements.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o test.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_GET_ELEMENT} \
		-o mat_get_element.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${GET_VECTOR_INFO} \
		-o get_vector_info.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_MULTIPLY_ELEMENTS} \
		-o vec_multiply_elements.o \
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
