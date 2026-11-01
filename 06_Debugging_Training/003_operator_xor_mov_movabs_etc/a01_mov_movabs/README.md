# binutils(docs)
- https://sourceware.org/binutils/docs-2.41/as/Section.html

# 코드랑 주소랑 비교하면서 보자
```bash
objdump -d -M intel target/main

target/main:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:	48 b8 f0 de bc 9a 78 	movabs rax,0x123456789abcdef0
  401007:	56 34 12
  40100a:	b8 11 11 11 11       	mov    eax,0x11111111
  40100f:	48 b8 f0 de bc 9a 78 	movabs rax,0x123456789abcdef0
  401016:	56 34 12
  401019:	66 b8 22 22          	mov    ax,0x2222
  40101d:	b0 33                	mov    al,0x33
  40101f:	48 c7 c0 3c 00 00 00 	mov    rax,0x3c
  401026:	48 31 ff             	xor    rdi,rdi
  401029:	0f 05                	syscall
```

# gdb

```bash
$ just gdb

Reading symbols from ./target/main...
(No debugging symbols found in ./target/main)
(gdb) b main
Breakpoint 1 at 0x401000
(gdb) r
Starting program: /home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/06_Debugging_Training/003_operator_xor_mov_movabs_etc/a01_mov_movabs/target/main

Breakpoint 1, 0x0000000000401000 in main ()
(gdb) display/x $rax
1: /x $rax = 0x0
(gdb) si
0x000000000040100a in main ()
1: /x $rax = 0x123456789abcdef0
(gdb) si
0x000000000040100f in main ()
1: /x $rax = 0x11111111
(gdb) si
0x0000000000401019 in main ()
1: /x $rax = 0x123456789abcdef0
(gdb) si
0x000000000040101d in main ()
1: /x $rax = 0x123456789abc2222
(gdb) si
0x000000000040101f in main ()
1: /x $rax = 0x123456789abc2233
(gdb) si
0x0000000000401026 in main ()
1: /x $rax = 0x3c
(gdb) si
0x0000000000401029 in main ()
1: /x $rax = 0x3c
(gdb) si
[Inferior 1 (process 13224) exited normally]
(gdb) q
```
