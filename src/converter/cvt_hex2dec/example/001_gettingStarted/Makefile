ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm

CVT_HEX2DEC = \
  "../../../../converter/cvt_hex2dec/src/cvt_hex2dec.asm"

OBJ = _start.o \
      cvt_hex2dec.o

BIN = exe

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_HEX2DEC} \
		-o cvt_hex2dec.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o${BIN} \
		-m${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
