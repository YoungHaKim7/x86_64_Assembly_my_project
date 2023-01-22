# x86 Assembly : Hello World

https://youtu.be/HgEGAaYdABA

# x86_64_Assembly_my_project

- x86_64_Assembly Language Programming with Ubuntu

http://www.egr.unlv.edu/~ed/assembly64.pdf

# apt install

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
