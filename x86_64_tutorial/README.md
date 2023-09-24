# build & execution

```
nasm -felf64 add.asm && ld add.o && ./a.out
  
```
- ASM Sample (elf32)

```
$ nasm -f elf32 -o hello.o hello.asm

$ ls
hello.asm  hello.o

$ ld -m elf_i386 -o hello hello.o

$ ls
hello  hello.asm  hello.o

$ ./hello
Hello World!
```

# Nasm Tutorial

https://cs.lmu.edu/~ray/notes/nasmtutorial/

# 외국 사람이 만든 CS12 어셈블리 예시가 많아서 좋다. 

https://github.com/stuart-srjc/CS12-Labs

# become a gigachad assembly programmer in only 10 minutes (yes YOU! right now) | Low Level Learning

https://youtu.be/6S5KRJv-7RU

# x86_64 Linux Assembly

https://youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn


# Architecture 1001: Intel x86-64 Assembly

https://youtube.com/playlist?list=PLUFkSN0XLZ-m9B0DhHjkXd8foIMuZO1Gd


# Modern x64 Assembly

https://youtube.com/playlist?list=PLKK11Ligqitg9MOX3-0tFT1Rmh3uJp7kA
