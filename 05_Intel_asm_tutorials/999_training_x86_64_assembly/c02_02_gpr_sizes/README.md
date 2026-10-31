# GDB debugging

```bash
gdb ./target/c02_02_gpr_sizes
GNU gdb (Ubuntu 17.1-2ubuntu1) 17.1
Copyright (C) 2025 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./target/c02_02_gpr_sizes...
(gdb) set disassembly-flavor intel
(gdb) b main
Breakpoint 1 at 0x401110: file src/main.asm, line 19.
(gdb) r
Starting program: /home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/05_Intel_asm_tutorials/999_training_x86_64_assembly/c02_02_gpr_sizes/target/c02_02_gpr_sizes
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main () at src/main.asm:19
19          xor     rax, rax                        ; rax = 0 (all 64 bits cleared)
(gdb) display/i $pc
1: x/i $pc
=> 0x401110 <main>:     xor    rax,rax
(gdb) display/x $rax
2: /x $rax = 0x7ffff7e19de8
(gdb) display/x $eax
3: /x $eax = 0xf7e19de8
(gdb) display/x $ax
4: /x $ax = 0x9de8
(gdb) display/x $al
5: /x $al = 0xe8
(gdb) display/x $rdi
6: /x $rdi = 0x1
(gdb) si
20          mov     al, 0xFF                        ; write ONLY the low 8 bits
1: x/i $pc
=> 0x401113 <main+3>:   mov    al,0xff
2: /x $rax = 0x0
3: /x $eax = 0x0
4: /x $ax = 0x0
5: /x $al = 0x0
6: /x $rdi = 0x1
(gdb) si
23          mov     rdi, rax                        ; exit code 255 (0xFF)
1: x/i $pc
=> 0x401115 <main+5>:   mov    rdi,rax
2: /x $rax = 0xff
3: /x $eax = 0xff
4: /x $ax = 0xff
5: /x $al = 0xff
6: /x $rdi = 0x1
(gdb) si
last () at src/main.asm:26
26          mov     rax, SYS_exit                   ; call code for exit
1: x/i $pc
=> 0x401118 <last>:     mov    eax,0x3c
2: /x $rax = 0xff
3: /x $eax = 0xff
4: /x $ax = 0xff
5: /x $al = 0xff
6: /x $rdi = 0xff
(gdb) si
27          syscall
1: x/i $pc
=> 0x40111d <last+5>:   syscall
2: /x $rax = 0x3c
3: /x $eax = 0x3c
4: /x $ax = 0x3c
5: /x $al = 0x3c
6: /x $rdi = 0xff
(gdb) si
[Inferior 1 (process 27096) exited with code 0377]
(gdb) q

```

- To determine the size of a General-Purpose Register (GPR) while debugging, use **GDB to inspect the register's value and its subregisters**.

For your example, the key thing to verify is that:

```asm
xor rax, rax
mov al, 0xFF
```

`xor rax, rax` clears all 64 bits of RAX, while `mov al, 0xFF` changes only the lowest 8 bits.

Let's debug this instruction by instruction and inspect the register contents.

## 1. Understand the register sizes

RAX is a 64-bit register. Its smaller names refer to portions of the same physical register:

```text
64-bit:  RAX
        ┌────────────────────────────────┐
        │             RAX                │
        └────────────────────────────────┘
         63                             0

32-bit:                  EAX
                         ┌──────────────┐
                         │              │
                         └──────────────┘
                         31             0

16-bit:                         AX
                                ┌──────┐
                                │      │
                                └──────┘
                                15     0

 8-bit:                            AH AL
                                   ┌──┬──┐
                                   │AH│AL│
                                   └──┴──┘
                                   15  8 7  0
```

In particular:

| Register | Size | Bits of RAX |
|---|---:|---|
| RAX | 64-bit | 63–0 |
| EAX | 32-bit | 31–0 |
| AX | 16-bit | 15–0 |
| AH | 8-bit | 15–8 |
| AL | 8-bit | 7–0 |

GDB can display these independently, which is very useful for understanding partial-register writes.

## 2. Assemble your program with debugging information

Save your code as `main.asm`.

Assemble it with NASM:

```bash
nasm -f elf64 -g -F dwarf main.asm -o main.o
```

Link it with GCC:

```bash
gcc -no-pie -g main.o -o main
```

Why these options?

| Option | Meaning |
|---|---|
| `-f elf64` | Generate a 64-bit ELF object file |
| `-g` | Generate debugging information |
| `-F dwarf` | Use DWARF debugging format |
| `-no-pie` | Disable position-independent executable linking |
| `-o main` | Name the executable `main` |

You can check the executable:

```bash
file ./main
```

## 3. Start GDB

```bash
gdb ./main
```

Inside GDB, enter:

```gdb
set disassembly-flavor intel
break main
run
```

GDB should stop at the beginning of your `main` function.

Now inspect the current instruction:

```gdb
x/i $pc
```

Example:

```text
=> 0x401106 <main>: xor rax,rax
```

Here:

- `x` means examine memory.
- `/i` means display an instruction.
- `$pc` is the program counter (RIP on x86-64).

You can also inspect all registers:

```gdb
info registers
```

Or inspect only RAX and its subregisters:

```gdb
info registers rax
p/x $rax
p/x $eax
p/x $ax
p/x $al
```

`p/x` displays a value in hexadecimal.

To check the size of a register expression:

```gdb
p sizeof($rax)
p sizeof($eax)
p sizeof($ax)
p sizeof($al)
```

Expected results:

```text
$1 = 8
$2 = 4
$3 = 2
$4 = 1
```

These sizes are in bytes:

```text
RAX = 8 bytes = 64 bits
EAX = 4 bytes = 32 bits
AX  = 2 bytes = 16 bits
AL  = 1 byte  =  8 bits
```

## 4. Debug instruction by instruction

The most useful GDB command for this exercise is:

```gdb
si
```

`si` means **Step Instruction**. It executes exactly one machine instruction.

Let's follow your program.

### Step 1: Before executing `xor rax, rax`

```gdb
x/i $pc
info registers rax
```

RAX may contain an arbitrary initial value. Do not assume it starts at zero.

### Step 2: Execute `xor rax, rax`

```gdb
si
```

Inspect the result:

```gdb
p/x $rax
p/x $eax
p/x $ax
p/x $al
```

Expected:

```text
RAX = 0x0000000000000000
EAX = 0x00000000
AX  = 0x0000
AL  = 0x00
```

Why?

```asm
xor rax, rax
```

XORing a value with itself always produces zero.

Because the destination is RAX, all 64 bits are cleared.

### Step 3: Execute `mov al, 0xFF`

First check the next instruction:

```gdb
x/i $pc
```

You should see:

```asm
mov al, 0xff
```

Execute it:

```gdb
si
```

Now inspect the register:

```gdb
p/x $rax
p/x $eax
p/x $ax
p/x $al
```

Expected:

```text
RAX = 0x00000000000000ff
EAX = 0x000000ff
AX  = 0x00ff
AL  = 0xff
```

This demonstrates that writing to AL changes only bits 7–0.

The upper 56 bits remain unchanged.

```text
Before mov al, 0xFF:

RAX = 00000000 00000000 00000000 00000000
      00000000 00000000 00000000 00000000

After mov al, 0xFF:

RAX = 00000000 00000000 00000000 00000000
      00000000 00000000 00000000 11111111
```

### Step 4: Execute `mov rdi, rax`

```gdb
si
```

Inspect:

```gdb
p/x $rdi
p/x $rax
```

Expected:

```text
RDI = 0x00000000000000ff
RAX = 0x00000000000000ff
```

RDI now contains the same 64-bit value as RAX.

### Step 5: Inspect the exit syscall

Execute:

```gdb
si
```

You should reach:

```asm
mov rax, 60
```

Execute it:

```gdb
si
```

Inspect:

```gdb
p/x $rax
p/x $rdi
```

Expected:

```text
RAX = 0x3c
RDI = 0xff
```

On Linux x86-64:

| Register | Purpose |
|---|---|
| RAX | System call number |
| RDI | First system call argument |

System call number `60` means `exit`.

Your program exits with status `255`.

---

## 5. Useful GDB commands to remember

Here is a small reference table:

| GDB command | Purpose |
|---|---|
| `info registers` | Display all registers |
| `info registers rax` | Display RAX |
| `p/x $rax` | Display RAX in hexadecimal |
| `p/t $rax` | Display RAX in binary |
| `p/d $rax` | Display RAX in decimal |
| `p sizeof($rax)` | Display the size in bytes |
| `x/i $pc` | Display the current instruction |
| `x/10i $pc` | Display the next 10 instructions |
| `si` | Execute one instruction |
| `ni` | Execute one instruction, stepping over calls |
| `display/i $pc` | Automatically display the current instruction |
| `display/x $rax` | Automatically display RAX |
| `info breakpoints` | List breakpoints |
| `continue` | Continue execution |
| `quit` | Exit GDB |

## 6. A useful debugging session shortcut

Instead of entering every command individually, you can use:

```gdb
set disassembly-flavor intel
break main
run

display/i $pc
display/x $rax
display/x $eax
display/x $ax
display/x $al
display/x $rdi

si
si
si
si
si
```

GDB automatically displays the configured expressions after each instruction step.

**One important distinction:** GDB tells you the register's size, but the assembly instruction tells you which portion of the register it accesses.

For example:

```asm
mov rax, 0xFF     ; write 64 bits
mov eax, 0xFF     ; write 32 bits; zero upper 32 bits
mov ax, 0xFF      ; write 16 bits
mov al, 0xFF      ; write 8 bits
```

Try changing your original `mov al, 0xFF` to each of these instructions and observe the results with GDB. This is one of the best ways to understand x86-64 register behavior.
