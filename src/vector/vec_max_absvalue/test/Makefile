ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            get_vector_info.o \
            vec_max_absvalue.o

GET_VECTOR_INFO = \
  "../../get_vector_info/src/get_vector_info.asm"

VEC_MAX_ABSVALUE = \
  "../src/vec_max_absvalue.asm"

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
		${VEC_MAX_ABSVALUE} \
		-o vec_max_absvalue.o \
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
