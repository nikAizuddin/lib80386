ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       =  exe
OBJ       = _start.o \
            cvt_dec2hex.o

CVT_DEC2HEX = \
  "../../../../converter/cvt_dec2hex/src/cvt_dec2hex.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2HEX} \
		-o cvt_dec2hex.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
