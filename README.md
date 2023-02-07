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

# Rust Languages & Assembly<a href="https://www.rust-lang.org/"><img align="left" alt="rust1" width="39px" src="https://user-images.githubusercontent.com/67513038/213436632-820a1675-98d9-4626-979d-be63c60cdcb7.png" /></a>

<br>

# RustLang inline-assembly

https://doc.rust-lang.org/reference/inline-assembly.html

https://doc.rust-lang.org/rust-by-example/unsafe/asm.html

<br>

## Rust ~~~~~~~~~ ~~~~~~~

<br>

<hr>

# Assembly 기초 basic<a href="https://en.wikipedia.org/wiki/Assembly_language"><img align="left" alt="assembly" width="39px" src="https://user-images.githubusercontent.com/67513038/210325356-f21c646d-6ef1-4736-ac42-53f0b5e149ca.png"></a>

# Bootsector Game From Scratch - Space Invaders (x86 asm) Game만들기(Assembly로)

[https://youtu.be/TVvTDjMph1M](https://youtu.be/TVvTDjMph1M)

<br>

# ASCII Table

https://www.asciitable.com/

```
$ python

Python 3.11.0 (main, Oct 24 2022, 18:26:48) [MSC v.1933 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.

>>> 0x0a
10

>>> chr(0x0a)
'\n'

>>>


```



<br>

<hr>

====================================================

# x86_64_Assembly Language Programming with Ubuntu<a href="https://en.wikipedia.org/wiki/Assembly_language"><img align="left" alt="assembly" width="39px" src="https://user-images.githubusercontent.com/67513038/210325356-f21c646d-6ef1-4736-ac42-53f0b5e149ca.png"></a>

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

<br>

# General Purpose Registers(GPRs) page 10


<table border="1">
    <tr>
    <td colspan="8" align="center">rax<br><-- 64 bits --></td>
    </tr>
    <tr align="center">
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td colspan="4" align="center">eax<br>(Lowest 32-bits<br><----------------    ----------------------></td>
        </tr>
    </tr>
    <tr align="center">
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td colspan="2", align="center"><---    ax     ---><br>Lowest 16-bits</td>
    </tr>
    <tr align="center">
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>8bit</td>
        <td>ah<br><-- 8-bits --></td>
        <td>al<br><-- 8-bits --></td>
    </tr>
</table>

<br>


<table border="1">
    <tr>
    <td colspan="4" align="center">General Purpose Registers(GPRs)</td>
    </tr>
    <tr align="center">
        <td>64-bit register</td>
        <td>Lowest<br>32-bits</td>
        <td>Lowest<br>16-bits</td>
        <td>Lowest<br>8-bits</td>
    </tr>
    <tr align="center">
        <td>rax</td>
        <td>eax</td>
        <td>ax</td>
        <td>al</td>
    </tr>
    <tr align="center">
        <td>rbx</td>
        <td>ebx</td>
        <td>bx</td>
        <td>bl</td>
    </tr>
    <tr align="center">
        <td>rcx</td>
        <td>ecx</td>
        <td>cx</td>
        <td>cl</td>
    </tr>
    <tr align="center">
        <td>rdx</td>
        <td>edx</td>
        <td>dx</td>
        <td>dl</td>
    </tr>
    <tr align="center">
        <td>rsi</td>
        <td>esi</td>
        <td>si</td>
        <td>sil</td>
    </tr>
    <tr align="center">
        <td>rdi</td>
        <td>edi</td>
        <td>di</td>
        <td>dil</td>
    </tr>
    <tr align="center">
        <td>rbp</td>
        <td>ebp</td>
        <td>bp</td>
        <td>bpl</td>
    </tr>
    <tr align="center">
        <td>rsp</td>
        <td>esp</td>
        <td>sp</td>
        <td>spl</td>
    </tr>
    <tr align="center">
        <td>r8</td>
        <td>r8d</td>
        <td>r8w</td>
        <td>r8b</td>
    </tr>
    <tr align="center">
        <td>r9</td>
        <td>r9d</td>
        <td>r9w</td>
        <td>r9b</td>
    </tr>
    <tr align="center">
        <td>r10</td>
        <td>r10d</td>
        <td>r10w</td>
        <td>r10b</td>
    </tr>
    <tr align="center">
        <td>r11</td>
        <td>r11d</td>
        <td>r11w</td>
        <td>r11b</td>
    </tr>
    <tr align="center">
        <td>r12</td>
        <td>r12d</td>
        <td>r12w</td>
        <td>r12b</td>
    </tr>
    <tr align="center">
        <td>r13</td>
        <td>r13d</td>
        <td>r13w</td>
        <td>r13b</td>
    </tr>
    <tr align="center">
        <td>r14</td>
        <td>r14d</td>
        <td>r14w</td>
        <td>r14b</td>
    </tr>
    <tr align="center">
        <td>r15</td>
        <td>r15d</td>
        <td>r15w</td>
        <td>r15b</td>
    </tr>
</table>

http://www.egr.unlv.edu/~ed/assembly64.pdf


# Memory Layout(Page17)

<table border="1">
    <tr>
    <td colspan="2" align="center">General Memory Layout</td>
    </tr>
    <tr align="center">
        <td rowspan="5">high memory<br><br><br><br><br><br><br><br><br>low memory</td>
        <td>stack<br>.<br>.<br>.<br>heap</td>
    </tr>
    <tr align="center">
        <td>BSS - uninitialized data</td>
    </tr>
    <tr align="center">
        <td>data</td>
    </tr>
    <tr align="center">
        <td>text (code)</td>
    </tr>
    <tr align="center">
        <td>reserved</td>
    </tr>
</table>

http://www.egr.unlv.edu/~ed/assembly64.pdf

<br>

# Memory Hierarchy(Page18)

<table border="1">
    <tr>
    <td colspan="2" align="center">Memory Hierarchy</td>
    </tr>
    <tr align="center">
        <td rowspan="5">Smaller, faster,<br>and more expensive<br><br><br><br><br><br><br><br><br>Larger,slower,<br>and less expensive</td>
        <td>CPU<br>Registers</td>
    </tr>
    <tr align="center">
        <td>Cache</td>
    </tr>
    <tr align="center">
        <td>Primary Storage<br>Main Memory(RAM)</td>
    </tr>
    <tr align="center">
        <td>Secondary Storage<br>(disk drives, SSD's, etc.)</td>
    </tr>
    <tr align="center">
        <td>Tertiary Storage<br>(remote storage, optical, backups,etc.)</td>
    </tr>
</table>

http://www.egr.unlv.edu/~ed/assembly64.pdf


# Some typical performance and size characteristics (Page19)


<table border="1">
    <tr>
    <td colspan="3" align="center"></td>
    </tr>
    <tr align="center">
        <td>Memory Unit</td>
        <td>Example Size</td>
        <td>Typical Speed</td>
    </tr>
    <tr align="center">
        <td>Registers</td>
        <td>16, 64-bit registers</td>
        <td>~1 nanoseconds<sup>13</sup></td>
    </tr>
    <tr align="center">
        <td>Cache Memory</td>
        <td>4 - 8+ Megabytes<sup>14</sup><br>(L1 and L2)</td>
        <td>~5-60 nanoseconds</td>
    </tr>
    <tr align="center">
        <td>Primary Storage<br>(i.e., main memory)</td>
        <td>2 - 32+ Gigabytes<sup>15</sup></td>
        <td>~100-150 nanoseconds</td>
    </tr>
    <tr align="center">
        <td>Secondary Storage<br>(i.e., disk, SSD's, etc.)</td>
        <td>500 Gigabytes -<br> 4+ Terabytes<sup>16</sup></td>
        <td>~3-15 milliseconds<sup>17</sup></td>
    </tr>
</table>