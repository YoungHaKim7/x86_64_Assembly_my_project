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

# 세부적으로 더 자세히

- Your GDB session is successful. It demonstrates exactly how the x86-64 General-Purpose Registers (GPRs) behave when you write to different register sizes.

The most important observation is this:

```text
Before xor:
RAX = 0x7ffff7e19de8

After xor rax, rax:
RAX = 0x0000000000000000

After mov al, 0xFF:
RAX = 0x00000000000000ff
```

You have verified two important CPU behaviors:

1. Writing to `RAX` with `xor rax, rax` clears all 64 bits.
2. Writing to `AL` with `mov al, 0xFF` changes only the lowest 8 bits.

Let's go through your actual output line by line.

# 1. Starting GDB

```bash
gdb ./target/c02_02_gpr_sizes
```

This launches GDB and loads your executable.

```text
GNU gdb (Ubuntu 17.1-2ubuntu1) 17.1
```

This tells you the GDB version installed on your Ubuntu system.

```text
This GDB was configured as "x86_64-linux-gnu".
```

This is important. It tells you that GDB was built for the x86-64 Linux platform.

```text
Reading symbols from ./target/c02_02_gpr_sizes...
```

GDB has found debugging information in your executable.

Your assembly was assembled with debugging information, so GDB can associate machine instructions with source lines:

```text
src/main.asm:19
```

Without debugging information, you could still inspect instructions and registers, but source-line information might not be available.

# 2. Configure Intel syntax

```gdb
(gdb) set disassembly-flavor intel
```

This tells GDB to display assembly instructions using Intel syntax.

There are two common x86 assembly syntaxes:

| AT&T syntax | Intel syntax |
|---|---|
| `mov $10, %rax` | `mov rax, 10` |
| `mov %rax, %rbx` | `mov rbx, rax` |
| `add $1, %rax` | `add rax, 1` |

Since your source uses Intel syntax, this makes the disassembly easier to compare with your code.

# 3. Set a breakpoint

```gdb
(gdb) b main
Breakpoint 1 at 0x401110: file src/main.asm, line 19.
```

`b` is short for `break`.

You are telling GDB:

> Stop execution when the CPU reaches the beginning of the `main` function.

GDB responds:

```text
Breakpoint 1 at 0x401110
```

This means:

- Breakpoint number: `1`
- Breakpoint address: `0x401110`
- Source file: `src/main.asm`
- Source line: `19`

The address `0x401110` is the virtual memory address where your `main` function begins.

You can think of a breakpoint as a temporary stop sign for the CPU.

# 4. Start execution

```gdb
(gdb) r
Starting program: /home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/05_Intel_asm_tutorials/999_training_x86_64_assembly/c02_02_gpr_sizes/target/c02_02_gpr_sizes
```

`r` means `run`.

GDB starts your program.

```text
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/x86_64-linux-gnu/libthread_db.so.1".
```

This is normal GDB startup output.

GDB has enabled its Linux thread-debugging support through `libthread_db`.

Even though your assembly program does not create threads, this library can be loaded automatically.

Next:

```text
Breakpoint 1, main () at src/main.asm:19
19          xor     rax, rax
```

Execution has stopped at your breakpoint.

**Important:** The CPU has not executed `xor rax, rax` yet.

The instruction at the current RIP is the next instruction that will execute.

# 5. Display the current instruction and registers

You entered:

```gdb
(gdb) display/i $pc
```

This command tells GDB to automatically display the instruction at the current program counter after each step.

On x86-64, `$pc` refers to the instruction pointer, which is the `RIP` register.

You received:

```text
1: x/i $pc
=> 0x401110 <main>: xor rax,rax
```

Let's break this down:

| Part | Meaning |
|---|---|
| `1:` | GDB display-expression number |
| `x/i` | Examine memory as an instruction |
| `$pc` | Current instruction address |
| `=>` | Instruction currently selected for execution |
| `0x401110` | Address of the instruction |
| `<main>` | Symbol name |
| `xor rax,rax` | Assembly instruction |

Next:

```gdb
(gdb) display/x $rax
(gdb) display/x $eax
(gdb) display/x $ax
(gdb) display/x $al
(gdb) display/x $rdi
```

These commands tell GDB to automatically display the values of these registers after every instruction step.

The `/x` means hexadecimal.

You received:

```text
2: /x $rax = 0x7ffff7e19de8
3: /x $eax = 0xf7e19de8
4: /x $ax  = 0x9de8
5: /x $al  = 0xe8
6: /x $rdi = 0x1
```

## Why does RAX initially contain 0x7ffff7e19de8?

This is an important observation.

You might expect registers to start at zero, but that is not guaranteed.

When your `main` function begins, it is called by the C runtime startup code. The runtime prepares the environment and calls `main`.

Some registers may contain values left over from that startup process.

Your initial RAX value is:

```text
RAX = 0x7ffff7e19de8
```

Let's examine its subregisters.

```text
RAX (64-bit)
┌────────────────────────────────────────────────┐
│ 00007FFF F7E1 9DE8                              │
└────────────────────────────────────────────────┘

EAX (32-bit)
                  ┌──────────────────────────────┐
                  │ F7E1 9DE8                    │
                  └──────────────────────────────┘

AX (16-bit)
                               ┌────────────────┐
                               │ 9DE8           │
                               └────────────────┘

AL (8-bit)
                                    ┌──────────┐
                                    │ E8       │
                                    └──────────┘
```

All four values are different-sized views of the same physical register.

Notice:

```text
RAX = 0x7ffff7e19de8
EAX =          0xf7e19de8
AX  =                0x9de8
AL  =                  0xe8
```

This is precisely why understanding subregisters is important.

Also, your initial RDI is:

```text
RDI = 0x1
```

This is consistent with the System V AMD64 calling convention: the first argument to `main` is `argc`, and its value is 1 when the program is launched without additional command-line arguments.

# 6. First instruction: xor rax, rax

You entered:

```gdb
(gdb) si
```

`si` means **Step Instruction**.

It executes exactly one machine instruction and then stops.

Before execution:

```asm
xor rax, rax
```

After execution:

```text
1: x/i $pc
=> 0x401113 <main+3>: mov al,0xff

2: /x $rax = 0x0
3: /x $eax = 0x0
4: /x $ax  = 0x0
5: /x $al  = 0x0
6: /x $rdi = 0x1
```

Let's understand what happened.

The instruction:

```asm
xor rax, rax
```

performs:

```text
RAX = RAX XOR RAX
```

A value XORed with itself always produces zero.

For example:

```text
  10101010
XOR 10101010
------------
  00000000
```

Because the destination is the 64-bit register RAX, all 64 bits are cleared.

```text
Before:

RAX = 0x7ffff7e19de8

After:

RAX = 0x0000000000000000
```

The other registers are unaffected by this instruction, so RDI remains `0x1`.

### Why did the instruction address change?

Before:

```text
RIP = 0x401110
```

After:

```text
RIP = 0x401113
```

The instruction occupies 3 bytes:

```text
Address     Instruction
--------------------------------
0x401110    xor rax, rax
0x401113    mov al, 0xff
```

Therefore, the next instruction begins at `0x401113`.

This is how the CPU's instruction pointer advances through machine code.

# 7. Second instruction: mov al, 0xFF

You entered another:

```gdb
(gdb) si
```

The output:

```text
1: x/i $pc
=> 0x401115 <main+5>: mov rdi,rax

2: /x $rax = 0xff
3: /x $eax = 0xff
4: /x $ax  = 0xff
5: /x $al  = 0xff
6: /x $rdi = 0x1
```

The instruction that was just executed was:

```asm
mov al, 0xFF
```

This writes `0xFF` into the lowest 8 bits of RAX.

Remember the initial state after the first instruction:

```text
RAX = 0x0000000000000000
```

After the second instruction:

```text
RAX = 0x00000000000000FF
```

Visual representation:

```text
RAX (64 bits)

Before:
┌────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00000000             │
│ 00000000 00000000 00000000 00000000             │
└────────────────────────────────────────────────┘

After mov al, 0xFF:
┌────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00000000             │
│ 00000000 00000000 00000000 11111111             │
└────────────────────────────────────────────────┘
                                             AL
```

The upper 56 bits were not modified.

That is why:

```text
RAX = 0xff
EAX = 0xff
AX  = 0xff
AL  = 0xff
```

All four expressions show the same numerical value, but they represent different register widths.

**Important:** This result is especially clear because you zeroed RAX first. If you had executed `mov al, 0xFF` without clearing RAX, the upper 56 bits would have retained their previous values.

For example:

```asm
mov rax, 0x123456789ABCDEF0
mov al, 0xFF
```

Result:

```text
RAX = 0x123456789ABCDEFF
```

# 8. Third instruction: mov rdi, rax

Your next command:

```gdb
(gdb) si
```

Output:

```text
last () at src/main.asm:26
26          mov     rax, SYS_exit
```

And the register display:

```text
1: x/i $pc
=> 0x401118 <last>: mov rax,0x3c

2: /x $rax = 0xff
3: /x $eax = 0xff
4: /x $ax  = 0xff
5: /x $al  = 0xff
6: /x $rdi = 0xff
```

The instruction just executed was:

```asm
mov rdi, rax
```

It copies the value of RAX into RDI.

Conceptually:

```text
RDI = RAX
```

Before:

```text
RAX = 0x00000000000000FF
RDI = 0x0000000000000001
```

After:

```text
RAX = 0x00000000000000FF
RDI = 0x00000000000000FF
```

Notice that `mov` does not remove the value from RAX. It copies the value.

This is important because your program will use RDI as the exit status.

# 9. Fourth instruction: mov rax, SYS_exit

Your next instruction:

```asm
mov rax, SYS_exit
```

Your GDB output:

```text
=> 0x401118 <last>: mov eax,0x3c
```

There is something interesting here.

Your source says:

```asm
mov rax, SYS_exit
```

But GDB displays:

```asm
mov eax,0x3c
```

Why?

Because NASM and the x86-64 instruction encoding can use a 32-bit immediate-to-register instruction for this value.

`SYS_exit` is 60 decimal:

```text
60 decimal = 0x3C hexadecimal
```

The assembler can encode this as:

```asm
mov eax, 0x3C
```

Writing to EAX in 64-bit mode automatically clears the upper 32 bits of RAX.

For example:

```asm
mov eax, 0x3C
```

Produces:

```text
RAX = 0x000000000000003C
```

The important x86-64 rule:

```text
Write to EAX  -> upper 32 bits of RAX become zero.
Write to AX   -> upper 48 bits remain unchanged.
Write to AL   -> upper 56 bits remain unchanged.
```

You can verify this behavior experimentally later.

You executed:

```gdb
(gdb) si
```

GDB now shows:

```text
1: x/i $pc
=> 0x40111d <last+5>: syscall

2: /x $rax = 0x3c
3: /x $eax = 0x3c
4: /x $ax  = 0x3c
5: /x $al  = 0x3c
6: /x $rdi = 0xff
```

Let's interpret the register values.

```text
RAX = 0x3C = 60 decimal
RDI = 0xFF = 255 decimal
```

For Linux x86-64 system calls:

| Register | Meaning |
|---|---|
| RAX | System call number |
| RDI | First argument |
| RSI | Second argument |
| RDX | Third argument |
| R10 | Fourth argument |
| R8 | Fifth argument |
| R9 | Sixth argument |

Your program is preparing this system call:

```asm
mov rax, 60       ; SYS_exit
mov rdi, 255      ; exit status
syscall
```

Linux system call number `60` is `exit`.

Therefore, the program is asking Linux:

```c
exit(255);
```

Notice that `RAX`, `EAX`, `AX`, and `AL` all show `0x3C`.

That is because the value 60 fits within all these register widths.

# 10. Execute syscall

Finally, you entered:

```gdb
(gdb) si
```

GDB displayed:

```text
[Inferior 1 (process 27096) exited with code 0377]
```

This means your program terminated successfully from GDB's perspective.

Let's examine the output carefully.

### What is Inferior?

In GDB terminology, an **inferior** is a program being debugged.

```text
Inferior 1
```

Means this is the first program GDB is debugging.

```text
process 27096
```

Is the Linux process ID (PID).

### Why does it say 0377 instead of 255?

This is an interesting detail.

GDB displays the exit code in octal in this output.

Let's convert:

```text
Octal:      0377
Decimal:     255
Hexadecimal: 0xFF
Binary:      11111111
```

Therefore, your program exited with status `255`, exactly as expected.

You can verify it outside GDB:

```bash
./target/c02_02_gpr_sizes
echo $?
```

Expected:

```text
255
```

One more detail: Linux process exit statuses are conventionally observed through the low 8 bits. So `255` is the exit status reported by the shell.

# 11. Complete execution trace

Here is your entire program's execution summarized.

| Step | Executed instruction | RAX | EAX | AX | AL | RDI |
|---:|---|---|---|---|---|---|
| Initial | — | `0x7ffff7e19de8` | `0xf7e19de8` | `0x9de8` | `0xe8` | `0x1` |
| 1 | `xor rax, rax` | `0x0` | `0x0` | `0x0` | `0x0` | `0x1` |
| 2 | `mov al, 0xFF` | `0xff` | `0xff` | `0xff` | `0xff` | `0x1` |
| 3 | `mov rdi, rax` | `0xff` | `0xff` | `0xff` | `0xff` | `0xff` |
| 4 | `mov rax, 60` | `0x3c` | `0x3c` | `0x3c` | `0x3c` | `0xff` |
| 5 | `syscall` | Process exits | | | | |

# 12. My recommended next experiment: Compare AL, AX, EAX, and RAX

Now that you understand the GDB session, I recommend testing the four different register widths.

Temporarily replace your instructions with:

```asm
section .text
global main

main:
    mov rax, 0x1122334455667788

    mov al, 0xAA
    ; Inspect RAX

    mov ax, 0xBBBB
    ; Inspect RAX

    mov eax, 0xCCCCCCCC
    ; Inspect RAX

    mov rax, 0xDDDDDDDDDDDDDDDD
    ; Inspect RAX

    xor edi, edi
    mov eax, 60
    syscall
```

Compile and debug it as before.

At each comment, execute:

```gdb
si
p/x $rax
p/x $eax
p/x $ax
p/x $al
```

Here are the results you should observe:

| Instruction | Expected RAX |
|---|---|
| Initial `mov rax, ...` | `0x1122334455667788` |
| `mov al, 0xAA` | `0x11223344556677aa` |
| `mov ax, 0xBBBB` | `0x112233445566bbbb` |
| `mov eax, 0xCCCCCCCC` | `0x00000000cccccccc` |
| `mov rax, 0xDDDD...` | `0xdddddddddddddddd` |

Pay particular attention to the difference between these two instructions:

```asm
mov ax, 0xBBBB
mov eax, 0xCCCCCCCC
```

The first preserves the upper 48 bits.

The second clears the upper 32 bits.

**This is one of the most important rules of x86-64 register programming.** Once you understand it, you'll be much better equipped to read compiler-generated assembly, debug calling conventions, and analyze machine code.
