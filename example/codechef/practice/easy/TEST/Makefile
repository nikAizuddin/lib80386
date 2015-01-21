ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/_start.asm
BIN       = bin/exe
OBJ       = build/_start.o \

.PHONY: all clean

all: submit
	@mkdir -p bin
	@mkdir -p build

	@${ASSEMBLER} \
		${_START} \
		-o build/_start.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

submit:
	@mkdir -p submit
	@${ASSEMBLER} \
		-e ${_START} \
		-o submit/submit.asm \
		-f ${FORMAT}

clean:
	@rm \
		${OBJ} \
		${BIN}
	@rm -r \
		bin \
		build \
		submit
