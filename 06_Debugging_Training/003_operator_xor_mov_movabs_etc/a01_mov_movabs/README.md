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
# **GDB + objdump + nm together**.
- For what you're trying to do, I recommend using **GDB + objdump + nm together**.

However, GDB should be your primary tool because you want to see the instruction currently executing, its address, and how registers and memory change.

Here's how to set it up.

# 1. First, understand the relationship

Each tool has a different responsibility:

| Tool | What you use it for |
|---|---|
| `nm` | Find function and variable addresses |
| `objdump` | See every instruction and its machine-code address |
| `gdb` | Follow execution instruction by instruction |
| `readelf` | Inspect ELF sections and memory segments |

For your particular task:

```text
Assembly source
      |
      v
   objdump
      |
      v
Instruction addresses
      |
      v
     GDB
      |
      v
Current instruction + registers + memory
```

# 2. Use objdump to see every instruction address

Compile your assembly:

```bash
as --64 -g -o main.o main.s
ld -o main main.o
```

Run:

```bash
objdump -d -M intel main
```

You'll see something similar to:

```asm
0000000000401000 <main>:
  401000: 48 b8 f0 de bc 9a 78 56 34 12
           movabs rax, 0x123456789abcdef0

  40100a: b8 11 11 11 11
           mov eax, 0x11111111

  40100f: 48 b8 f0 de bc 9a 78 56 34 12
           movabs rax, 0x123456789abcdef0

  401019: 66 b8 22 22
           mov ax, 0x2222

  40101d: b0 33
           mov al, 0x33

  40101f: 48 c7 c0 3c 00 00 00
           mov rax, 60

  401026: 48 31 ff
           xor rdi, rdi

  401029: 0f 05
           syscall
```

These addresses correspond to the addresses in your GDB output.

For example:

```text
0x401000
0x40100a
0x40100f
0x401019
0x40101d
0x40101f
0x401026
0x401029
```

# 3. Use GDB to display the current instruction automatically

Start GDB:

```bash
gdb ./main
```

Enter:

```gdb
break main
run
```

Now configure automatic displays:

```gdb
display/i $rip
display/x $rax
display/x $rbx
display/x $rcx
display/x $rdx
```

Execute:

```gdb
si
```

GDB will automatically display the next instruction and register values.

For example:

```text
0x40100a: mov eax, 0x11111111
$1 = 0x123456789abcdef0
```

Then:

```gdb
si
```

You can observe the updated value:

```text
0x40100f: movabs rax, 0x123456789abcdef0
$1 = 0x11111111
```

This is exactly what you need to understand register modifications.

# 4. Display the current instruction and its memory address

Use:

```gdb
x/i $rip
```

To display multiple instructions:

```gdb
x/10i $rip
```

To display the current instruction with its raw machine-code bytes:

```gdb
disassemble /r main
```

Example:

```text
Dump of assembler code for function main:
   0x401000: 48 b8 f0 de bc 9a 78 56 34 12
             movabs rax,0x123456789abcdef0

   0x40100a: b8 11 11 11 11
             mov eax,0x11111111
```

The `/r` option includes raw instruction bytes.

# 5. Display memory addresses and their contents

You can inspect the memory surrounding the current instruction.

For example:

```gdb
x/16xb $rip
```

This displays 16 bytes starting at the current instruction address.

Example:

```text
0x401000: 0x48 0xb8 0xf0 0xde 0xbc 0x9a 0x78 0x56
0x401008: 0x34 0x12 0xb8 0x11 0x11 0x11 0x11 0x48
```

You can also inspect the stack:

```gdb
x/8gx $rsp
```

And inspect a particular memory address:

```gdb
x/gx 0x402000
```

Remember:

- `$rip` = address of the next instruction to execute.
- `$rsp` = current stack pointer.
- `$rax` = general-purpose register.
- `x` = examine memory.

# 6. Use GDB's layout mode (very useful!)

GDB has a TUI (Text User Interface) that displays assembly and registers simultaneously.

Start:

```bash
gdb -tui ./main
```

Inside GDB:

```gdb
break main
run
layout asm
layout regs
```

You can also use:

```gdb
layout split
```

Useful shortcuts:

| Command | Description |
|---|---|
| `layout asm` | Show assembly |
| `layout regs` | Show registers |
| `layout split` | Show source and assembly |
| `tui enable` | Enable TUI |
| `tui disable` | Disable TUI |
| `refresh` | Refresh screen |

For your assembly learning, I recommend:

```gdb
layout asm
layout regs
```

Then:

```gdb
si
si
si
```

You can watch the instruction pointer move through your program.

---

# 7. My recommended GDB configuration

You can create a `.gdbinit` file in your project directory:

```gdb
set disassembly-flavor intel
set pagination off
set print pretty on

display/i $rip
display/x $rax
display/x $rbx
display/x $rcx
display/x $rdx
display/x $rdi
display/x $rsi

define stepasm
    si
end

define showmem
    x/16xb $rip
end
```

Now start:

```bash
gdb -q ./main
```

You can simply execute:

```gdb
break main
run
stepasm
stepasm
showmem
```

Note: GDB may not automatically load a local `.gdbinit` because of its auto-load security settings. You can explicitly load it with `source .gdbinit`.

# 8. Bonus: Use nm to find your function addresses

Run:

```bash
nm -n -S main
```

Example:

```text
0000000000401000 000000000000002b T main
```

This tells you:

```text
Function: main
Address:  0x401000
Size:     0x2b bytes
```

You can then inspect that exact address in GDB:

```gdb
x/11i 0x401000
```

---

## Final recommendation: Your assembly debugging workflow

For your x86-64 assembly projects, I recommend this sequence:

**Terminal 1 — Static analysis**

```bash
nm -n -S main
objdump -d -M intel main
readelf -hW main
```

**Terminal 2 — Interactive debugging**

```bash
gdb -tui ./main
```

Inside GDB:

```gdb
set disassembly-flavor intel
break main
run

layout asm
layout regs

display/i $rip
display/x $rax

si
si
si
```

The key is:

- `objdump` tells you what instructions exist and their addresses.
- `nm` tells you where functions and symbols are located.
- `GDB` tells you which instruction is executing and what is happening to the CPU state.

**You don't need to guess instruction addresses anymore. GDB's `$rip` tells you exactly where execution is currently positioned.**
