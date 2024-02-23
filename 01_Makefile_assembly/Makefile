NASM = nasm

SOURCE_ASM = ./src/main.asm
SOURCE_ASM_OBJ = ./$(TARGET_FOLDER)/main.o

TARGET = ./$(TARGET_FOLDER)/main
TARGET_FOLDER = target
LDFLAGS_COMMON = -felf64

r:
		rm -rf $(TARGET_FOLDER)
		mkdir $(TARGET_FOLDER)
		$(NASM) $(LDFLAGS_COMMON) $(SOURCE_ASM)
		mv ./src/main.o ./$(TARGET_FOLDER)/.
		ld -o $(TARGET) $(SOURCE_ASM_OBJ)
		$(TARGET)

clean:
		rm -rf target

