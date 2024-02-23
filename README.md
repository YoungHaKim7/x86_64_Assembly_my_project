# 어셈블러의 비교
- https://ko.wikipedia.org/wiki/%EC%96%B4%EC%85%88%EB%B8%94%EB%9F%AC%EC%9D%98_%EB%B9%84%EA%B5%90

<hr>

# Mara Bos
@m_ou_se
⚛️📋 I made an overview of the ARMv8 and x86-64 machine instructions for all the common atomic operations:

<p>
       <img src="https://pbs.twimg.com/media/FhH-RYzWIAE24_v?format=jpg&name=4096x4096" />
</p>

https://twitter.com/m_ou_se/status/1590333332012662784/photo/1

# Assembly Debugging

https://www.gnu.org/software/ddd/manual/

https://github.com/BetelGeuseee/x86-assembly-yasm

<hr>

# rust_웹으로 어셈블리 보기Assembly

https://rust.godbolt.org/

- 뒤에 최적화 옵션

```
-C opt-level=3 --target i686-unknown-linux-gnu
```

# Vim \_ Assembly Highlight Syntax

```

:set ft=nasm  " assembly highlight syntax

```

# vim tab setting

```
set tabstop=4
set shiftwidth=4
```

<hr>

# To debug NASM you might want to use DDD.

To debug NASM you might want to use DDD. The following course teaches assembly for Intel/Linux using NASM and DDD, you might want to have a look at it as you might find it helpful:

Getting started with NASM and DDD --> https://www.youtube.com/watch?v=YyovCxsMVio

Assembly integer arithmetic --> https://www.youtube.com/watch?v=-KfZaJclqk4

Assembly floating-point arithmetic --> https://www.youtube.com/watch?v=n1gIv40VSgA

Assembly control instructions --> https://www.youtube.com/watch?v=s38DcLv1wYk

Assembly and process stack --> https://www.youtube.com/watch?v=7nPru8b7SjY

Assembly functions --> https://www.youtube.com/watch?v=QOPOeDPlNZo

Stack buffer overflow --> https://www.youtube.com/watch?v=BW2obfJtkPw

System services --> https://www.youtube.com/watch?v=qzTlkJsq3Xo 

https://www.reddit.com/r/asm/comments/ba4qi9/debugging_nasm/

<hr>

<br>

<hr>

# 외국 사람이 만든 x86_64 설명서 github 예시 좋다.!

https://github.com/compilepeace/SHELLCODING_INTEL_x86-64/

# Debugging BIOS Assembly Visually with Visual Studio Code and GDB [Ep 13]

https://youtu.be/aMSFaAcup50?si=91Qr4sMRqIsa5_TT

# 3분안에 설명하는 Assembly Language

- Assembly Language in 100 Seconds
  - https://youtu.be/4gwYkEK0gOk?si=Eey3U0MpndLj1zPF

# 10분안에 익히는 x86 Assembly | x86 Assembly Crash Course | HackUCF

https://youtu.be/75gBFiFtAb8?si=skDTgz3WiarSaKbY

<hr>

# x86asm.net

http://ref.x86asm.net/coder64.html

<br>

# x86-x64 명령어 레퍼런스 읽는 법

https://modoocode.com/316

# The Go tools for Windows + Assembler

http://godevtool.com/

<br>

# 1.4.4.1 YASM References

http://yasm.tortall.net/

1.4.4.1 YASM References
The YASM assembler is an open source assembler commonly available on Linux-based
systems.
The YASM references are as follows:

- Yasm Web Site http://yasm.tortall.net/
- Yasm Documentation http://yasm.tortall.net/Guide.html

  Additional information regarding YASM may be available a number of assembly
  language sites and can be found through an Internet search.

# 1.4.4.2 DDD Debugger References

The DDD debugger is an open source debugger capable of supporting assembly
language.

- DDD Web Site https://www.gnu.org/software/ddd/
- DDD Documentation https://www.gnu.org/software/ddd/manual/

Additional information regarding DDD may be at a number of assembly language sites
and can be found through an Internet search.

<br>

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

# ASM Build & Execution

- elf64
```
nasm -felf64 add.asm && ld add.o && ./a.out
```

- elf32
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
- Nasm Tutorial
  - https://cs.lmu.edu/~ray/notes/nasmtutorial/

# ASM hello.asm

```asm
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

# Assembly 기초 basic
<a href="https://en.wikipedia.org/wiki/Assembly_language"><img alt="assembly" width="22px" src="https://user-images.githubusercontent.com/67513038/210325356-f21c646d-6ef1-4736-ac42-53f0b5e149ca.png"></a>

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

# x86_64_Assembly Language Programming with Ubuntu<a href="https://en.wikipedia.org/wiki/Assembly_language"><img alt="assembly" width="22px" src="https://user-images.githubusercontent.com/67513038/210325356-f21c646d-6ef1-4736-ac42-53f0b5e149ca.png"></a>

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

- General-purpose register layout
 - The x86-64 general-purpose registers are 
   - aliased: each has multiple names, which refer to overlapping bytes in the register.
<table border="1">
    <tr>
    <td colspan="8" align="center">General-purpose register layout</td>
    </tr>
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
    <tr align="center">
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr align="center" border="3">
        <td border="3">Byte 7</td>
        <td>Byte 6</td>
        <td>Byte 5</td>
        <td>Byte 4</td>
        <td>Byte 3</td>
        <td>Byte 2</td>
        <td>Byte 1</td>
        <td>Byte 0</td>
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

<br>

# Stack Pointer Register (RSP)

- Stack Pointer Register

<table border="1">
    <tr>
    <td colspan="3" align="center"></td>
    </tr>
    <tr align="center">
        <td>Stack Pointer Register</td>
        <td></td>
        <td>RSP</td>
    </tr>
</table>

- One of the CPU registers, rsp, is used to point to the current top of the stack. The rsp
  register should not be used for data or other uses. Additional information regarding the
  stack and stack operations is provided in Chapter 9, Process Stack.

# Base Pointer Register (RBP)

<table border="1">
    <tr>
    <td colspan="3" align="center"></td>
    </tr>
    <tr align="center">
        <td>Base Pointer Register</td>
        <td></td>
        <td>RBP</td>
    </tr>
</table>

- One of the CPU registers, rbp, is used as a base pointer during function calls. The rbp
  register should not be used for data or other uses. Additional information regarding the
  functions and function calls is provided in Chapter 12, Functions.

# Instruction Pointer Register (RIP)

<table border="1">
    <tr>
    <td colspan="3" align="center"></td>
    </tr>
    <tr align="center">
        <td>Instruction Pointer Register
</td>
        <td></td>
        <td>RIP</td>
    </tr>
</table>

- In addition to the GPRs, there is a special register, rip, which is used by the CPU to
  point to the next instruction to be executed. Specifically, since the rip points to the
  next instruction, that means the instruction being pointed to by rip, and shown in the
  debugger, has not yet been executed. This is an important distinction which can be
  confusing when reviewing code in a debugger.

# Flag Register (rFlags)

- Assembly Language & Computer Architecture | MIT OpenCourseWare(33min05sec)
  - https://youtu.be/L1ung0wil9Y?si=rPsC0iQicpE7iy2i 
 

- The flag register, rFlags, is used for status and CPU control information

- This register stores status information about the instruction that was just
  executed. Of the 64-bits in the rFlag register, many are reserved for future use.

- Arithmetic and logic operations update status flags in the RFLAGS register.

```s
decq %rbx   
jne .LBB7_1
```
- ```decq %rbx     ```; Decrement ```%rbx```, and set ZF if the result is 0.

<table border="1">
    <tr>
    <td colspan="4" align="center">Flag Register (rFlags)<br>RFLAGS Register</td>
    </tr>
    <tr align="center">
        <td>Name<br>Description</td>
        <td>Symbol<br>or<br>(Abbreviation)</td>
        <td>Bit(s)</td>
        <td>Use</td>
    </tr>
    <tr align="center">
        <td>Carry</td>
        <td>CF</td>
        <td>0</td>
        <td>Used to indicate if the previous operation
resulted in a carry.</td>
    </tr>
    <tr align="center">
        <td>Reserved</td>
        <td></td>
        <td>1</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>Parity</td>
        <td>PF</td>
        <td>2</td>
        <td>Used to indicate if the last byte has an even
number of 1's (i.e., even parity). </td>
    </tr>
    <tr align="center">
        <td>Reserved</td>
        <td></td>
        <td>3</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>Adjust</td>
        <td>AF</td>
        <td>4</td>
        <td>Used to support Binary Coded Decimal
operations.</td>
    </tr>
    <tr align="center">
        <td>Reserved</td>
        <td></td>
        <td>5</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>Zero</td>
        <td>ZF</td>
        <td>6</td>
        <td>Used to indicate if the previous operation
resulted in a zero result.</td>
    </tr>
    <tr align="center">
        <td>Sign</td>
        <td>SF</td>
        <td>7</td>
        <td>Used to indicate if the result of the
previous operation resulted in a 1 in the
most significant bit (indicating negative in
the context of signed data).</td>
    </tr>
    <tr align="center">
        <td>Trap</td>
        <td>TF</td>
        <td>8</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>Interrupt<br>enable</td>
        <td>IF</td>
        <td>9</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>Direction</td>
        <td>DF</td>
        <td>10</td>
        <td>Used to specify the direction (increment or
decrement) for some string operations.</td>
    </tr>
    <tr align="center">
        <td>Overflow</td>
        <td>OF</td>
        <td>11</td>
        <td>Used to indicate if the previous operation
resulted in an overflow.</td>
    </tr>
    <tr align="center">
        <td>System flags or<br>reserved</td>
        <td></td>
        <td>12 - 63</td>
        <td></td>
    </tr>
</table>

<br>

# Common x86-64 Registers
- Assembly Language & Computer Architecture(15min33sec)
  - https://youtu.be/L1ung0wil9Y?si=GCVZvxM4-omcrNM-

<table border="1">
    <tr>
    <tr align="center">
        <td colspan="5">Number</td>
        <td>Width<br>(bits)</td>
        <td>Names(s)</td>
        <td>Purpose</td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td colspan="5"><em><mark>16</mark></em></td>
        <td><em><mark>64</mark></em></td>
        <td><em><mark>(many)</em></mark></td>
        <td><em><mark>General-purpose registers</mark></em></td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td colspan="5">6</td>
        <td>16</td>
        <td>%ss,%[c-g]s</td>
        <td>Segment registers</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5"><em><mark>1</mark></em></td>
        <td><em><mark>64</mark></em></td>
        <td><em><mark>RFLAGS</em></mark></td>
        <td><em><mark>Flags register</mark></em></td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td colspan="5"><em><mark>1</mark></em></td>
        <td><em><mark>64</mark></em></td>
        <td><em><mark>%rip</em></mark></td>
        <td><em><mark>Instruction pointer register</mark></em></td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td colspan="5">7</td>
        <td>64</td>
        <td>%cr[0-4,8], %xcr0</td>
        <td>Control registers</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">8</td>
        <td>64</td>
        <td>%mm[0-7]</td>
        <td>MMX registers</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>32</td>
        <td>mxcsr</td>
        <td>SSE2 control register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5" rowspan="2"><em><mark>16</mark></em></td>
        <td><em><mark>128</mark></em></td>
        <td><em><mark>%xmm[0-15]</em></mark></td>
        <td><em><mark>XMM registers (for SSE)</mark></em></td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td><em><mark>256</mark></em></td>
        <td><em><mark>%ymm[0-15]</em></mark></td>
        <td><em><mark>YMM registers (for AVX)</mark></em></td>
        <td>★</td>
    </tr>
    <tr align="center">
        <td colspan="5">8</td>
        <td>80</td>
        <td>%st([0-7])</td>
        <td>x87 FPU data registers</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>16</td>
        <td>x87 CW</td>
        <td>x87 FPU control register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>16</td>
        <td>x87 SW</td>
        <td>x87 FPU status register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>48</td>
        <td></td>
        <td>x87 FPU instruction<br>pointer register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>48</td>
        <td></td>
        <td>x87 FPU data operand<br>pointer register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>16</td>
        <td></td>
        <td>x87 FPU tag register</td>
        <td></td>
    </tr>
    <tr align="center">
        <td colspan="5">1</td>
        <td>11</td>
        <td></td>
        <td>x87 FPU opcode register</td>
        <td></td>
    </tr>

</table>


# x86-64 Data Types

<table border="1">
    <tr>
    <td colspan="5" align="center">x86-64 Data Types</td>
    </tr>
    <tr align="center">
        <td>C declaration</td>
        <td>C<br>constant</td>
        <td>x86-64<br>size<br>(bytes)</td>
        <td>Assembly<br>suffix</td>
        <td>x-86-64<br>data type</td>
    </tr>
    <tr align="center">
        <td>char</td>
        <td>'c'</td>
        <td>1</td>
        <td>b</td>
        <td>Byte</td>
    </tr>
    <tr align="center">
        <td>short</td>
        <td>172</td>
        <td>2</td>
        <td>w</td>
        <td>Word</td>
    </tr>
    <tr align="center">
        <td>int</td>
        <td>172</td>
        <td>4</td>
        <td>l or d</td>
        <td>Double word</td>
    </tr>
    <tr align="center">
        <td>unsigned<br>int</td>
        <td>172U</td>
        <td>4</td>
        <td>l or d</td>
        <td>Double word</td>
    </tr>
    <tr align="center">
        <td>long</td>
        <td>172L</td>
        <td>8</td>
        <td>q</td>
        <td>Quad word</td>
    </tr>
    <tr align="center">
        <td>unsigned long</td>
        <td>172UL</td>
        <td>8</td>
        <td>q</td>
        <td>Quad word</td>
    </tr>
    <tr align="center">
        <td>char *</td>
        <td>"6.172"</td>
        <td>8</td>
        <td>q</td>
        <td>Quad word</td>
    </tr>
    <tr align="center">
        <td>float</td>
        <td>6.172F</td>
        <td>4</td>
        <td>s</td>
        <td>Single precision</td>
    </tr>
    <tr align="center">
        <td>double</td>
        <td>6.172</td>
        <td>8</td>
        <td>d</td>
        <td>Double precision</td>
    </tr>
    <tr align="center">
        <td>long double</td>
        <td>6.172L</td>
        <td>16(10)</td>
        <td>t</td>
        <td>Extended precision</td>
    </tr>
</table>

28min30sec
https://youtu.be/L1ung0wil9Y?si=XEBdCmwbP48LLYOE

<br>

<hr>

# Computer Architecture(Page 7)

![1](https://user-images.githubusercontent.com/67513038/217710708-7140b1d9-2685-4a33-966d-3c19ca9af463.png)

<br>

# Common x86-64 Opcodes
- Assembly Language & Computer Architecture(25min33sec)
  - https://youtu.be/L1ung0wil9Y?si=GCVZvxM4-omcrNM-

<table border="1">
    <tr>
    <td colspan="4" align="center">Opcodes</td>
    </tr>
    <tr align="center">
        <td colspan="2">Type of peration</td>
        <td>Example</td>
    </tr>
    <tr align="center">
        <td rowspan="4">Data<br>movement</td>
        <td>Move</td>
        <td>mov</td>
    </tr>
    <tr align="center">
        <td>Conditional<br>move</td>
        <td>cmov</td>
    </tr>
    <tr align="center">
        <td>Sign or<br>zero extension</td>
        <td>movs, movz</td>
    </tr>
    <tr align="center">
        <td>Stack</td>
        <td>push, pop</td>
    </tr>
    <tr align="center">
        <td rowspan="3">Arithmetic <br>and logic</td>
        <td>Integer<br>arithmetric</td>
        <td>add, sub, mul, imul,div, idiv,<br>lea,sal, sar, shl, shr, rol,<br>ror, inc, dec,neg</td>
    </tr>
    <tr align="center">
        <td>Binary logic</td>
        <td>and, or, xor, not</td>
    </tr>
    <tr align="center">
        <td>Boolean logic</td>
        <td>test, cmp</td>
    </tr>
    <tr align="center">
        <td rowspan="3">Control<br>transfer</td>
        <td>Unconditional<br>jump</td>
        <td>jmp</td>
    </tr>
    <tr align="center">
        <td>Conditional<br>jump</td>
        <td>j&lt;condition&gt;</td>
    </tr>
    <tr align="center">
        <td>Subroutines</td>
        <td>call, ret</td>
    </tr>
</table>


# Condition Codes

<table border="1">
    <tr>
    <td colspan="3" align="center">Condition Codes</td>
    </tr>
    <tr align="center">
        <td>Condition code</td>
        <td>Translation</td>
        <td>RFLAGS status flags<br>checked</td>
    </tr>
    <tr align="center">
        <td>a</td>
        <td>if above</td>
        <td>CF = 0 and ZF = 0</td>
    </tr>
    <tr align="center">
        <td>ae</td>
        <td>if above or equal</td>
        <td>CF = 0</td>
    </tr>
    <tr align="center">
        <td>c</td>
        <td>on carry</td>
        <td>CF = 1</td>
    </tr>
    <tr align="center">
        <td>e</td>
        <td>if equal</td>
        <td>ZF = 1</td>
    </tr>
    <tr align="center">
        <td>ge</td>
        <td>if greater or equal</td>
        <td>SF = OF</td>
    </tr>
    <tr align="center">
        <td>ne</td>
        <td>if not equal</td>
        <td>ZF = 0</td>
    </tr>
    <tr align="center">
        <td>o</td>
        <td>on overflow</td>
        <td>OF = 1</td>
    </tr>
    <tr align="center">
        <td>z</td>
        <td>if zero</td>
        <td>ZF = 1</td>
    </tr>
</table>


# CPU Block Diagram(Page 15)

```mermaid

stateDiagram-v2

    state CPU__Chip {
        Core__0 --> L1_Cache
        Core__1 --> L1_Cache_
        L1_Cache --> L2_Cache
        L1_Cache_ --> L2_Cache
    }

    L2_Cache --> BUS

```

<br>

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

<br>

# Data Section(Page34) - All initialized variables & constants

Refer to the following sections for a series of examples using various data types.

The supported data types are as follows:

<table border="1">
    <tr>
    <td colspan="2" align="center">section .data<br>All initialized variables and constants</td>
    </tr>
    <tr align="center">
        <td>Declaration</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>db</td>
        <td>8-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>dw</td>
        <td>16-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>dd</td>
        <td>32-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>dq</td>
        <td>64-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>ddq</td>
        <td>128-bit variable(s) -> integer</td>
    </tr>
    <tr align="center">
        <td>dt</td>
        <td>128-bit variable(s) -> float</td>
    </tr>
</table>

http://www.egr.unlv.edu/~ed/assembly64.pdf

ex)

```asm

; The general format is:

; <variableName> <dataType> <initialValue>

section .data

  bVar     db      10             ; byte variable
  cVar     db      "H"            ; single character
  strng    db      "Hello World"  ; string
  wVar     dw      5000           ; 16-bit variable
  dVar     dd      50000          ; 32-bit variable
  arr      dd      100, 200, 300  ; 3 element array
  flt1     dd      3.14159        ; 32-bit float
  qVar     dq      1000000000     ; 64-bit variable

```

The value specified must be able to fit in the specified data type. For example, if the
value of a byte sized variables is defined as 500, it would generate an assembler error.

<br>

# BSS Section(Page35) - All uninitialized variables

Uninitialized data is declared in the "section .bss" section.

The supported data types are as follows:

<table border="1">
    <tr>
    <td colspan="2" align="center">section .bss<br>Uninitialized data</td>
    </tr>
    <tr align="center">
        <td>Declaration</td>
        <td></td>
    </tr>
    <tr align="center">
        <td>resb</td>
        <td>8-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>resw</td>
        <td>16-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>resd</td>
        <td>32-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>resq</td>
        <td>64-bit variable(s)</td>
    </tr>
    <tr align="center">
        <td>resdq</td>
        <td>128-bit variable(s)</td>
    </tr>
</table>

ex)

```asm
; The general format is:

; <variableName> <resType> <count>

section .bbs

  bArr    resb    10     ; 10 element byte array
  wArr    resw    50     ; 50 element word array
  dArr    resd    100    ; 100 element double array
  qArr    resq    200    ; 200 element quad array


; The allocated array is not initialized to any specific value.

```

http://www.egr.unlv.edu/~ed/assembly64.pdf

<br>

# Text Section(Page36)

```asm

; Code Section
section .text

global _start
_start:


```

# 4.7 Example Program(page37)

```asm
; Simple example demonstrating basic program format and layout.
; Ed Jorgensen
; July 18, 2014
; ************************************************************
; Some basic data declarations
section .data
; -----
  ; Define constants
  EXIT_SUCCESS equ 0 ; successful operation
  SYS_exit equ 60 ; call code for terminate
  ; -----
  ; Byte (8-bit) variable declarations
  bVar1   db 17
  bVar2   db 9
  bResult db 0
  ; -----
  ; Word (16-bit) variable declarations
  wVar1   dw 17000
  wVar2   dw 9000
  wResult dw 0
  ; -----
  ; Double-word (32-bit) variable declarations
  dVar1   dd 17000000
  dVar2   dd 9000000
  dResult dd 0

  ; -----
  ; quadword (64-bit) variable declarations
  qVar1   dq 170000000
  qVar2   dq 90000000
  qResult dq 0
; ************************************************************

; Code Section
section .text
global _start
_start:

  ; Performs a series of very basic addition operations
  ; to demonstrate basic program format.
  ; ----------
  ; Byte example
  ; bResult = bVar1 + bVar2
   mov al, byte [bVar1]
   add al, byte [bVar2]
   mov byte [bResult], al

  ; ----------
  ; Word example
  ; wResult = wVar1 + wVar2
   mov ax, word [wVar1]
   add ax, word [wVar2]
   mov word [wResult], ax

  ; ----------
  ; Double-word example
  ; dResult = dVar1 + dVar2
   mov eax, dword [dVar1]
   add eax, dword [dVar2]
   mov dword [dResult], eax

  ; ----------
  ; Quadword example
  ; qResult = qVar1 + qVar2
   mov rax, qword [qVar1]
   add rax, qword [qVar2]
   mov qword [qResult], rax
  ; ************************************************************
  ; Done, terminate program.
last:
  mov rax, SYS_exit ; Call code for exit
  mov rdi, EXIT_SUCCESS ; Exit program with success
  syscall
```

http://www.egr.unlv.edu/~ed/assembly64.pdf
