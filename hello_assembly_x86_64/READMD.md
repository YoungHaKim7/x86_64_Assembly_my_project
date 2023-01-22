# Result:

``
```
$ ls
hello.asm
$ nasm -f elf32 -o hello.o hello.asm

$ ls
hello.asm  hello.o

$ ld -m elf_i386 -o hello hello.o

$ ls
hello  hello.asm  hello.o

$ ./hello
Hello World!
```
