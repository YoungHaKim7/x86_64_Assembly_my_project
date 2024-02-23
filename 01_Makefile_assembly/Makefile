NASM = nasm

SOURCE_ASM = ./src/main.asm
SOURCE_ASM_OBJ = ./target/main.o

TARGET = ./target/main
LDFLAGS_COMMON = -felf64

r:
		rm -rf target
		mkdir target
		$(NASM) $(LDFLAGS_COMMON) $(SOURCE_ASM)
		mv ./src/main.o ./target/.
		ld -o $(TARGET) $(SOURCE_ASM_OBJ)
		$(TARGET)

clean:
		rm -rf target
