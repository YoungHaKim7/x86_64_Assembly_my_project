# debugging자료 힌트
- https://stackoverflow.com/questions/72302325/can-i-avoid-debugger-to-stop-in-assembly-code

# sample code(x86_64) assembly
- https://app.x64.halb.it/
```asm
; -----------------------------------------------------------------------------
; Data sizes: db, dw, dd, dq occupy consecutive addresses
;
; Demonstrates: consecutive data declarations, label addresses, sub on addresses
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.2 (Data Storage Sizes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_01_data_sizes.lst ch02_01_data_sizes.asm && ld -g -o ch02_01_data_sizes ch02_01_data_sizes.o
; Run:    ./ch02_01_data_sizes ; echo $?        -> exit code: 8
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db  0x11                    ; byte  variable (1 byte)
    wVar1       dw  0x2222                  ; word  variable (2 bytes, 1 past bVar1)
    dVar1       dd  0x33333333              ; dword variable (4 bytes, 2 past wVar1)
    qVar1       dq  0x4444444444444444      ; qword variable (8 bytes, 4 past dVar1)
qEnd:                                       ; label placed right after the qword

section .text
global _start
_start:

; each size is the distance between the addresses of adjacent declarations
    mov     rcx, wVar1                      ; rcx = address of the word
    mov     rdx, bVar1                      ; rdx = address of the byte
    sub     rcx, rdx                        ; rcx = 1  -> db reserves 1 byte

    mov     r8, dVar1                       ; r8  = address of the dword
    mov     rdx, wVar1                      ; rdx = address of the word
    sub     r8, rdx                         ; r8  = 2  -> dw reserves 2 bytes

    mov     r9, qVar1                       ; r9  = address of the qword
    mov     rdx, dVar1                      ; rdx = address of the dword
    sub     r9, rdx                         ; r9  = 4  -> dd reserves 4 bytes

    mov     rax, qEnd                       ; rax = address just past the qword
    mov     rdx, qVar1                      ; rdx = address of the qword
    sub     rax, rdx                        ; rax = 8  -> dq reserves 8 bytes

last:
    mov     rdi, rax                        ; exit code: qword size (8)
    mov     rax, SYS_exit                   ; call code for exit
    syscall
```

Your program is a very good example for learning x86-64 assembly reverse engineering because it demonstrates three important things:

1. Disassembly — what machine instructions the CPU executes.
2. Registers — the CPU's temporary storage for addresses, numbers, and calculation results.
3. Stack memory — memory used to store function-call information, process startup information, local variables, and other temporary data.

Let's examine your actual program as if we were debugging it in a terminal.

# 1. Understand the memory layout first

Your assembly declares four variables:

```asm
section .data
    bVar1   db  0x11
    wVar1   dw  0x2222
    dVar1   dd  0x33333333
    qVar1   dq  0x4444444444444444
qEnd:
```

These declarations reserve consecutive bytes in memory.

- `db` = Define Byte = 1 byte.
- `dw` = Define Word = 2 bytes.
- `dd` = Define Doubleword = 4 bytes.
- `dq` = Define Quadword = 8 bytes.

Your disassembly reveals that the data section starts at `0x402000`.

Let's reconstruct the memory layout.

```asm
DATA SECTION
Address       Variable      Size       Value
────────────────────────────────────────────────────
0x402000      bVar1         1 byte     0x11
0x402001      wVar1         2 bytes    0x2222
0x402003      dVar1         4 bytes    0x33333333
0x402007      qVar1         8 bytes    0x4444444444444444
0x40200F      qEnd          0 bytes    (end marker)
────────────────────────────────────────────────────
```

Notice something important:

`wVar1` starts at `0x402001`, not `0x402002`.

Why?

Because the assembler places these variables consecutively. It does not automatically insert alignment padding between these declarations.

The address calculations are:

```asm
bVar1 = 0x402000
wVar1 = 0x402001
dVar1 = 0x402003
qVar1 = 0x402007
qEnd  = 0x40200F
```

This is the foundation for understanding the rest of your disassembly.

# 2. Disassembly: What does the CPU execute?

Disassembly translates machine-code bytes into assembly instructions.

For example:

```asm
00401000    48 b90120400000000000
            movabs rcx, 0x402001
```

Let's break this down.

| Part       | Meaning              |
| ---------- | -------------------- |
| `00401000` | Instruction address  |
| `48 b9...` | Machine-code bytes   |
| `movabs`   | Assembly instruction |
| `rcx`      | Destination register |
| `0x402001` | Immediate value      |

The CPU executes this instruction:

```asm
movabs rcx, 0x402001
```

It places the address `0x402001` into `RCX`.

Important: It does not read the contents of `wVar1`.

It copies the address itself.

Think of the difference:

```asm
mov rcx, wVar1       ; Put the address into RCX
mov rcx, [wVar1]     ; Read memory at that address
```

The first operation gets an address. The second reads the value stored at that address.

Your program intentionally uses addresses because it wants to calculate the distance between variables.

## 2.1 Understand the first calculation

Your disassembly:

```asm
00401000    movabs rcx, 0x402001
0040100a    movabs rdx, 0x402000
00401014    sub    rcx, rdx
```

Let's execute this manually.

Before execution:

```asm
RCX = ?
RDX = ?
```

Instruction 1:

```asm
movabs rcx, 0x402001
```

Now:

```asm
RCX = 0x402001
```

Instruction 2:

```asm
movabs rdx, 0x402000
```

Now:

```asm
RCX = 0x402001
RDX = 0x402000
```

Instruction 3:

```asm
sub rcx, rdx
```

The CPU performs:

```asm
RCX = RCX - RDX

RCX = 0x402001 - 0x402000

RCX = 1
```

The result is `1`.

That means `bVar1` occupies one byte.

## 2.2 Understand all four calculations

Let's reconstruct the entire execution.

Calculation 1: Byte

```asm
mov rcx, wVar1
mov rdx, bVar1
sub rcx, rdx
```

```asm
0x402001 - 0x402000 = 1

RCX = 1
```

Calculation 2: Word

```asm
mov r8, dVar1
mov rdx, wVar1
sub r8, rdx
```

```asm
0x402003 - 0x402001 = 2

R8 = 2
```

Calculation 3: Doubleword

```asm
mov r9, qVar1
mov rdx, dVar1
sub r9, rdx
```

```asm
0x402007 - 0x402003 = 4

R9 = 4
```

Calculation 4: Quadword

```asm
mov rax, qEnd
mov rdx, qVar1
sub rax, rdx
```

```asm
0x40200F - 0x402007 = 8

RAX = 8
```

The resulting values:

```
┌─────────────────────────────┐
│       CALCULATION RESULTS   │
├─────────────────────────────┤
│ RCX = 1  (Byte)             │
│ R8  = 2  (Word)             │
│ R9  = 4  (Doubleword)       │
│ RAX = 8  (Quadword)         │
└─────────────────────────────┘
```

This is exactly what your program is demonstrating.

# 3. Registers: What is happening inside the CPU?

Your register dump:

```asm
Registers

rax : 0x00
rbx : 0x00
rcx : 0x00
rdx : 0x4ffffffffff7
rsp : 0x4ffffffffed0
rbp : 0x00
rsi : 0x00
rdi : 0x00
r8  : 0x00
r9  : 0x00
r10 : 0x00
r11 : 0x00
r12 : 0x00
r13 : 0x00
r14 : 0x00
r15 : 0x00
rip : 0x401000

eflags : 0x1202
```

First, understand the purpose of each register.

## 3.1 General-purpose registers

x86-64 has 16 general-purpose registers.

| Register   | Common purpose                             |
| ---------- | ------------------------------------------ |
| `RAX`      | Arithmetic, return values                  |
| `RBX`      | General-purpose storage                    |
| `RCX`      | General-purpose storage, loop counter      |
| `RDX`      | General-purpose storage, arithmetic        |
| `RSI`      | General-purpose storage, function argument |
| `RDI`      | General-purpose storage, function argument |
| `RBP`      | Often used as a stack-frame pointer        |
| `RSP`      | Stack pointer                              |
| `R8`–`R15` | Additional general-purpose registers       |
| `RIP`      | Instruction pointer                        |
| `EFLAGS`   | CPU status and control flags               |

For your program, the important registers are:

```asm
RCX = First calculation result
R8  = Second calculation result
R9  = Third calculation result
RAX = Fourth calculation result
RDX = Temporary register
RDI = Exit status
```

## 3.2 Why are all the registers zero?

You might notice that your register dump shows:

```asm
rax = 0
rcx = 0
r8  = 0
r9  = 0
rip = 0x401000
```

This is because your register snapshot shows the initial execution state.

Look at:

```asm
rip : 0x401000
```

Your first instruction is located at `0x401000`.

```asm
00401000    movabs rcx, 0x402001
```

If the CPU has not executed this instruction yet, `RCX` has not received `0x402001`.

The expected progression is:

```asm
BEFORE EXECUTION
──────────────────────────
RIP = 0x401000
RCX = 0

EXECUTE:
movabs rcx, 0x402001

AFTER EXECUTION
──────────────────────────
RIP = 0x40100a
RCX = 0x402001
```

This is how a debugger works: you can stop execution, inspect the registers, execute one instruction, and inspect them again.

One caveat: your displayed `RDX` value is nonzero even in the initial snapshot. That is an initial emulator register value; it does not change the interpretation of the program. The program overwrites `RDX` before using it.

## 3.3 What is RIP?

`RIP` stands for Instruction Pointer.

It tells you the address of the next instruction to execute.

For example:

```asm
RIP = 0x401000
```

The next instruction is:

```asm
movabs rcx, 0x402001
```

After executing it:

```asm
RIP = 0x40100a
```

Why `0x40100a`?

Because the instruction occupies 10 bytes.

```asm
0x401000 + 10 = 0x40100a
```

This is why instruction addresses in disassembly are different.

```asm
00401000    movabs rcx, ...
0040100a    movabs rdx, ...
00401014    sub rcx, rdx
```

The CPU advances RIP according to the length of each instruction, not by a fixed amount.

## 3.4 What is RSP?

`RSP` is the Stack Pointer.

Your register dump shows:

```asm
rsp = 0x4ffffffffed0
```

This means the stack pointer currently points to address:

```asm
0x4ffffffffed0
```

The stack is a region of memory used for temporary storage.

On x86-64 Linux, the stack generally grows toward lower memory addresses.

For example:

```asm
Higher addresses
       |
       v

0x500000000000
0x4fffffffffe0
0x4fffffffffd8
0x4fffffffffd0
       ...
0x4ffffffffed8
0x4ffffffffed0  <-- RSP
       |
       v

Lower addresses
```

The important instructions for understanding stack movement are:

```asm
push rax
pop rax
```

`push` stores a value on the stack and decreases `RSP` by 8 bytes in 64-bit mode.

`pop` retrieves a value and increases `RSP` by 8 bytes.

Your current program does not use `push` or `pop`, so it doesn't explicitly create any stack variables.

# 4. Stack memory: What are those hexadecimal bytes?

Your emulator displays:

```asm
Stack memory

00004ffffffffed0
00004ffffffffed8
00004ffffffffee0
00004ffffffffee8
00004ffffffffef0
00004ffffffffef8
...
0000500000000000
0000500000000008
...
```

These are memory addresses.

Notice the difference between consecutive addresses:

```
0x4ffffffffed0
0x4ffffffffed8
```

Calculate:

```
0x4ffffffffed8 - 0x4ffffffffed0 = 8
```

Each address is separated by 8 bytes.

This makes sense for an x86-64 environment because a general-purpose register holds 64 bits, or 8 bytes.

## 4.1 What is stored on the stack?

Your stack dump also contains a large hexadecimal block:

```
0100000000000000
d5ffffffff4f0000
...
2f70726f6772616d00
2f70726f6772616d00
...
```

These bytes are not necessarily your program's local variables.

When Linux starts a process, it prepares an initial stack containing information such as:

- Argument count (`argc`).
- Argument pointers (`argv`).
- Environment variable pointers (`envp`).
- Auxiliary vector (`auxv`).
- Argument strings.
- Environment strings.

Your program was launched as:

```bash
./program
```

Therefore, the string:

```
2f70726f6772616d00
```

is particularly interesting.

Let's decode it.

```bash
Hexadecimal:
2f 70 72 6f 67 72 61 6d 00

ASCII:
 /  p  r  o  g  r  a  m \0
```

This is:

```
/program
```

The hexadecimal values represent ASCII characters.

This is an example of how reverse engineers interpret raw memory.

## 4.2 Why is the stack growing downward?

Consider this example:

```asm
push rax
push rbx
push rcx
```

Suppose initially:

```asm
RSP = 0x1000
```

After the first push:

```asm
RSP = 0x0ff8
```

After the second push:

```asm
RSP = 0x0ff0
```

After the third push:

```asm
RSP = 0x0fe8
```

Terminal-style memory layout:

```
Address       Stored value
────────────────────────────
0x1000        Previous stack area
0x0ff8        RAX
0x0ff0        RBX
0x0fe8        RCX  <-- RSP
────────────────────────────
```

This is the downward-growing stack.

# 5. Why does your disassembly contain hundreds of `add [rax], al` instructions?

You have many lines like:

```asm
00401066    0000    add [rax], al
00401068    0000    add [rax], al
0040106a    0000    add [rax], al
```

These are not instructions from your original program.

They appear because your disassembler continues interpreting zero-filled bytes after the end of your actual code.

Look at your program's ending:

```asm
last:
    mov rdi, rax
    mov eax, 0x3c
    syscall
```

The last meaningful instruction is:

```asm
syscall
```

After the syscall, the Linux kernel terminates your process.

But your disassembler continues reading subsequent bytes.

For example:

```asm
Machine code:
00 00

Disassembled:
add BYTE PTR [rax], al
```

Why?

Because `00 /r` is an x86 instruction encoding for an addition involving a memory operand and a register.

The disassembler does not automatically know which zero bytes are unused padding and which bytes are executable instructions.



Important

&#x20;You should not assume every line produced by a disassembler is an instruction that your program actually executes.



You can limit disassembly to the `.text` section:

```bash
objdump -d -Mintel ./program
```

Or inspect the ELF sections:

```bash
readelf -S ./program
```

# 6. Understand the final syscall

Your final instructions are:

```asm
last:
    mov rdi, rax
    mov eax, 0x3c
    syscall
```

Let's examine them.

Linux x86-64 uses syscall number `60` for `exit`.

```asm
mov rdi, rax
```

Your previous calculation produced:

```asm
RAX = 8
```

Therefore:

```asm
RDI = 8
```

Next:

```asm
mov eax, 0x3c
```

This sets:

```asm
RAX = 60
```

Why `EAX` instead of `RAX`?

Writing to a 32-bit register such as `EAX` automatically clears the upper 32 bits of its corresponding 64-bit register.

Finally:

```asm
syscall
```

The Linux kernel receives:

```asm
RAX = 60    syscall number: exit
RDI = 8     exit status
```

The process terminates with exit status `8`.

You can verify it:

```bash
./program
echo $?
```

Expected output:

```
8
```

# 7. How to investigate this program yourself

Here are useful commands for your Linux reverse-engineering practice.

| Command                         | Purpose                        |
| ------------------------------- | ------------------------------ |
| `objdump -d -Mintel ./program`  | Disassemble machine code       |
| `objdump -s -j .data ./program` | Display raw data-section bytes |
| `readelf -S ./program`          | Inspect ELF sections           |
| `readelf -s ./program`          | Inspect symbols and addresses  |
| `nm -n ./program`               | List symbols sorted by address |
| `gdb ./program`                 | Debug execution                |
| `xxd -g 1 ./program`            | Inspect raw binary bytes       |

## Recommended: Debug one instruction at a time

Run:

```bash
gdb ./program
```

Then:

```bash
break _start
run
display/i $pc
display/x $rax
display/x $rcx
display/x $rdx
display/x $r8
display/x $r9
```

Execute one instruction:

```bash
si
```

Inspect registers:

```bash
info registers
```

Inspect memory around the data section:

```bash
x/16xb 0x402000
```

This displays 16 individual bytes in hexadecimal.

You should see something similar to:

```bash
0x402000: 0x11 0x22 0x22 0x33 0x33 0x33 0x33 0x44
0x402008: 0x44 0x44 0x44 0x44 0x44 0x44 0x44 0x44
```

Remember that x86-64 uses little-endian byte ordering.

For example:

```bash
qVar1 = 0x4444444444444444
```

Its eight bytes appear in memory in little-endian order. With your repeated `0x44` pattern, the order happens to look identical.

# 8. Final mental model

When reverse engineering an executable, think about these three layers:

1\. CPU — Registers

Where the CPU stores values while executing instructions.

```bash
RAX = 8
RCX = 1
R8  = 2
R9  = 4
```

2\. Memory — Data and Stack

Where variables, strings, pointers and temporary data reside.

```asm
.data
0x402000  bVar1
0x402001  wVar1
0x402003  dVar1
0x402007  qVar1

Stack
0x4ffffffffed0  <-- RSP
```

3\. Disassembly — Instructions

The machine instructions that manipulate registers and memory.

```asm
mov rax, qEnd
mov rdx, qVar1
sub rax, rdx
```

The most important distinction to remember:

- Disassembly: What instructions will execute?
- Registers: What values is the CPU currently holding?
- Memory: What bytes are stored at each address?

Once you can connect these three layers, you can follow an executable's behavior instruction by instruction, which is the foundation of assembly debugging and reverse engineering.
