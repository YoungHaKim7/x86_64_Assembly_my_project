# Vim \_ Assembly Highlight Syntax

```

:set ft=nasm  " assembly highlight syntax

```

# Assembly Language

https://github.com/EbookFoundation/free-programming-books/blob/main/books/free-programming-books-langs.md#non-x86

# x86 Assembly : Hello World

https://youtu.be/HgEGAaYdABA

# x86_64_Assembly_my_project

- x86_64_Assembly Language Programming with Ubuntu

http://www.egr.unlv.edu/~ed/assembly64.pdf

# apt install(Linux OS)

```
$ sudo apt install nasm
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  nasm
0 upgraded, 1 newly installed, 0 to remove and 11 not upgraded.
Need to get 375 kB of archives.
After this operation, 3,345 kB of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 nasm amd64 2.15.05-1 [375 kB]
Fetched 375 kB in 2s (217 kB/s)
Selecting previously unselected package nasm.
(Reading database ... 263485 files and directories currently installed.)
Preparing to unpack .../nasm_2.15.05-1_amd64.deb ...
Unpacking nasm (2.15.05-1) ...
Setting up nasm (2.15.05-1) ...
Processing triggers for man-db (2.10.2-1) ...
```

# ASM Sample

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

# ASM hello.asm

```
; World World x86_64 Intel Cpu Assembly
; hello.asm

global _start

section     .text:

_start:
    mov eax, 0x4                    ; use the write syscall
    mov ebx, 1                      ; use stdout as the fd
    mov ecx, message                ; use the message as the buffer
    mov edx, message_length         ; and supply the length
    int 0x80                        ; invoke the syscall

    ; now gracefully exit

    mov eax, 0x1
    mov ebx, 0
    int 0x80


section     .data:
    message: db     "Hello World!", 0xA
    message_length equ $-message



```

# Windows OS

```
choco install nasm

```

- This package uses the official nasm Windows installer, which doesn't add nasm to PATH. You may voice out your request in the nasm issue tracker, in which there is an existing issue filed

- PATH설정해줘야함. 나 같은 경우는
  "C:\Program Files\NASM"
  여기 PATH 설정함.

[https://community.chocolatey.org/packages/nasm](https://community.chocolatey.org/packages/nasm)

<br>

<hr>
# Rust Languages & Assembly

# RustLang inline-assembly

https://doc.rust-lang.org/reference/inline-assembly.html

https://doc.rust-lang.org/rust-by-example/unsafe/asm.html

<br>

<hr>

# Assembly 기초 basic

# Bootsector Game From Scratch - Space Invaders (x86 asm) Game만들기(Assembly로)

[https://youtu.be/TVvTDjMph1M](https://youtu.be/TVvTDjMph1M)

<br>



<br>

<hr>

====================================================

# x86_64_Assembly Language Programming with Ubuntu

# Data Storage Sizes(page 8.)

<table border="1">
    <tr>
    <td colspan="3" align="center">Data Storage Sizes</td>
    </tr>
    <tr align="center">
        <td>Storage</td>
        <td>Size(bits)</td>
        <td>Size(bytes)</td>
    </tr>
    <tr align="center">
        <td>Byte</td>
        <td>8-bits</td>
        <td>1 byte</td>
    </tr>
    <tr align="center">
        <td>Word</td>
        <td>16-bits</td>
        <td>2 bytes</td>
    </tr>
    <tr align="center">
        <td>Double-word</td>
        <td>32-bits</td>
        <td>4 bytes</td>
    </tr>
    <tr align="center">
        <td>Quadword</td>
        <td>64-bits</td>
        <td>8 bytes</td>
    </tr>
    <tr align="center">
        <td>Double quadword</td>
        <td>128-bits</td>
        <td>16 bytes</td>
    </tr>
</table>

http://www.egr.unlv.edu/~ed/assembly64.pdf

<table border="1">
    <tr>
    <td colspan="3" align="center">Data Storage Sizes(page9.)<br>C/C++ declarations are mapped as follows:</td>
    </tr>
    <tr align="center">
        <td>C/C++<br>Declaration</td>
        <td>Storage</td>
        <td>Size(bits)</td>
        <td>Size(bytes)</td>
    </tr>
    <tr align="center">
        <td>char</td>
        <td>Byte</td>
        <td>8-bits</td>
        <td>1 byte</td>
    </tr>
    <tr align="center">
        <td>Word</td>
        <td>16-bits</td>
        <td>2 bytes</td>
    </tr>
    <tr align="center">
        <td>Double-word</td>
        <td>32-bits</td>
        <td>4 bytes</td>
    </tr>
    <tr align="center">
        <td>Quadword</td>
        <td>64-bits</td>
        <td>8 bytes</td>
    </tr>
    <tr align="center">
        <td>Double quadword</td>
        <td>128-bits</td>
        <td>16 bytes</td>
    </tr>
</table>
