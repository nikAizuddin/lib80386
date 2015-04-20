ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       = exe
OBJ       = test.o \
            get_vector_info.o \
            mat_get_element.o \
            vec_subtract_sv.o

GET_VECTOR_INFO = \
  "../../get_vector_info/src/get_vector_info.asm"

MAT_GET_ELEMENT = \
  "../../../matrix/mat_get_element/src/mat_get_element.asm"

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
		${GET_VECTOR_INFO} \
		-o get_vector_info.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_GET_ELEMENT} \
		-o mat_get_element.o \
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
