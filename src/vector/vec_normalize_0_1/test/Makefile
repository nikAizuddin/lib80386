ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       =  exe
OBJ       = test.o \
            vec_max_absvalue.o \
            vec_normalize_0_1.o

VEC_MAX_ABSVALUE = \
  "../../vec_max_absvalue/src/vec_max_absvalue.asm"
VEC_NORMALIZE_0_1 = \
  "../src/vec_normalize_0_1.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o test.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_MAX_ABSVALUE} \
		-o vec_max_absvalue.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_NORMALIZE_0_1} \
		-o vec_normalize_0_1.o \
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
