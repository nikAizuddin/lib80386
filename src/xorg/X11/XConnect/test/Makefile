ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = _start.asm
BIN       =  exe
OBJ       = _start.o \
            create_socket.o \
            XConnect.o

CREATE_SOCKET = \
  "../../../../linux/create_socket/src/create_socket.asm"

XCONNECT = \
  "../../../../xorg/X11/XConnect/src/XConnect.asm"

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o _start.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CREATE_SOCKET} \
		-o create_socket.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${XCONNECT} \
		-o XConnect.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
