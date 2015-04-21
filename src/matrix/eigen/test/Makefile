ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = test.asm
BIN       = exe
OBJ       = test.o \
            get_vector_info.o \
            vec_copy.o \
            euclidean_norm.o \
            vec_divide_elements.o \
            vec_dotproduct.o \
            vec_multiply_elements.o \
            vec_subtract_vv.o \
            vec_normalize_0_1.o \
            vec_max_absvalue.o \
            mat_set_element.o \
            qr_decomposition.o \
            eigen.o \
            mat_copy.o \
            mat_diagonal.o \
            mat_multiply.o \
            mat_normalize_0_1.o

GET_VECTOR_INFO = \
  "../../../vector/get_vector_info/src/get_vector_info.asm"

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

VEC_NORMALIZE_0_1 = \
  "../../../vector/vec_normalize_0_1/src/vec_normalize_0_1.asm"

VEC_MAX_ABSVALUE = \
  "../../../vector/vec_max_absvalue/src/vec_max_absvalue.asm"

MAT_SET_ELEMENT = \
  "../../mat_set_element/src/mat_set_element.asm"

QR_DECOMPOSITION = \
  "../../qr_decomposition/src/qr_decomposition.asm"

EIGEN = \
  "../src/eigen.asm"

MAT_COPY = \
  "../../mat_copy/src/mat_copy.asm"

MAT_DIAGONAL = \
  "../../mat_diagonal/src/mat_diagonal.asm"

MAT_MULTIPLY = \
  "../../mat_multiply/src/mat_multiply.asm"

MAT_NORMALIZE_0_1 = \
  "../../mat_normalize_0_1/src/mat_normalize_0_1.asm"

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
		${VEC_COPY} \
		-o vec_copy.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${EUCLIDEAN_NORM} \
		-o euclidean_norm.o \
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
		${VEC_NORMALIZE_0_1} \
		-o vec_normalize_0_1.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${VEC_MAX_ABSVALUE} \
		-o vec_max_absvalue.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_SET_ELEMENT} \
		-o mat_set_element.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${QR_DECOMPOSITION} \
		-o qr_decomposition.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${EIGEN} \
		-o eigen.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_COPY} \
		-o mat_copy.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_DIAGONAL} \
		-o mat_diagonal.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_MULTIPLY} \
		-o mat_multiply.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${MAT_NORMALIZE_0_1} \
		-o mat_normalize_0_1.o \
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
