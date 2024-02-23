# Makefile

- makefile
```makefile
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
```


- easy
```Makefile

r:
		rm -rf out
		mkdir out
		nasm -felf64 src/main.asm
		mv ./src/main.o ./out/.
		ld ./out/main.o
		mv a.out out/.
		./out/a.out

clean:
		rm -rf out

```


```asm

global      _start

section     .text

_start:
    mov     rax, 1              ; system call for write
    mov     rdi, 1              ; file handle 1 is stdout
    mov     rsi, message        ; address of string to output
    mov     rdx, 13             ; number of bytes
    syscall
    mov     rax, 60             ; system call for exit
    xor     rdi, rdi            ; exit code 0
    syscall

section     .data
    message: db         "Hello, World Asm", 10  ; note the newline at the end

```
