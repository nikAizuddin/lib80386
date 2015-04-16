ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       = exe
OBJ       = test.o \
            vec_copy.o \
            euclidean_norm.o \
            vec_divide_elements.o \
            vec_dotproduct.o \
            vec_multiply_elements.o \
            vec_subtract_vv.o \
            qr_decomposition.o

VEC_COPY = \
  "../../../vector/vec_copy/src/vec_copy.asm"

EUCLIDEAN_NORM = \
  "../../../vector/euclidean_norm/src/euclidean_norm.asm"

VEC_DIVIDE_ELEMENTS = \
  "../../../vector/vec_divide_elements/src/vec_divide_elements.asm"

VEC_DOTPRODUCT = \
  "../../../vector/vec_dotproduct/src/vec_dotproduct.asm"

VEC_MULTIPLY_ELEMENTS = \
  "../../../vector/vec_multiply_elements/src/vec_multiply_elements.asm"

VEC_SUBTRACT_VV = \
  "../../../vector/vec_subtract_vv/src/vec_subtract_vv.asm"

QR_DECOMPOSITION = \
  "../src/qr_decomposition.asm"

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

	@${ASSEMBLER} \
		${VEC_COPY} \
		-o vec_copy.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_DIVIDE_ELEMENTS} \
		-o vec_divide_elements.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_DOTPRODUCT} \
		-o vec_dotproduct.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_MULTIPLY_ELEMENTS} \
		-o vec_multiply_elements.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_SUBTRACT_VV} \
		-o vec_subtract_vv.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${QR_DECOMPOSITION} \
		-o qr_decomposition.o \
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
