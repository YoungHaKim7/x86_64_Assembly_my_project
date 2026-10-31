# Detailed ELF and Assembly Analysis: `nm`, `objdump`, `file`, and `readelf`

Your output is a very good example of how an x86-64 assembly program becomes an ELF executable.

We'll analyze it from four perspectives:

1. **`nm`** — Symbol table: Where are functions and variables located?
2. **`objdump`** — Disassembly: What machine instructions did NASM generate?
3. **`file`** — Executable identification: What kind of binary did we build?
4. **`readelf`** — ELF structure: How is the executable organized internally?

I'll also connect the output to the actual memory layout and execution flow.

---

# 1. Understanding the program first

Before analyzing the commands, let's recall your assembly:

```asm
global main
global calculate

section .text

main:
    mov rax, 10
    mov rbx, 20

    call calculate

    mov rax, 60
    xor rdi, rdi
    syscall

calculate:
    add rax, rbx
    ret


section .data

my_value:
    dq 12345


section .bss

buffer:
    resb 64
```

Your program has three ELF sections:

| Section | Purpose | Contents |
|---|---|---|
| `.text` | Executable code | `main`, `calculate` |
| `.data` | Initialized data | `my_value` |
| `.bss` | Uninitialized data | `buffer` |

The execution flow is:

```text
                  PROGRAM START
                       |
                       v
                 main (0x401000)
                       |
                       v
                 mov rax, 10
                       |
                       v
                 mov rbx, 20
                       |
                       v
                 call calculate
                       |
                       v
               calculate (0x401019)
                       |
                       v
                 add rax, rbx
                       |
                       v
                    ret
                       |
                       v
                RAX = 30
                       |
                       v
                 mov rax, 60
                       |
                       v
                 xor rdi, rdi
                       |
                       v
                    syscall
                       |
                       v
                 EXIT(0)
```

Notice that the program calculates `10 + 20`, but does not print the result.

---

# 2. Analyzing `nm`

Your command:

```bash
nm -n target/main
```

`nm` displays the symbols contained in an executable or object file.

A symbol can represent:

- A function
- A global variable
- A local variable with symbol information
- A linker-generated symbol
- An undefined external reference

## 2.1 Understanding the output format

Generally, `nm` displays:

```text
ADDRESS       TYPE    SYMBOL_NAME
```

For example:

```text
0000000000401000 T main
```

Breakdown:

| Component | Value | Meaning |
|---|---|---|
| Address | `0000000000401000` | Symbol address |
| Type | `T` | Symbol is in the text section |
| Name | `main` | Symbol name |

Now let's examine each line.

## 2.2 Line-by-line analysis

### 1. Undefined `_start`

```text
                 U _start
```

`U` means **Undefined symbol**.

This means the executable's symbol table contains a reference to `_start`, but no definition of `_start` exists in the executable.

Why?

You linked your program using:

```bash
ld -o target/main target/main.o
```

When using GNU `ld` directly, without the standard C runtime startup files, the linker may still use its default linker script.

That default script can introduce an entry-point reference to `_start`.

However, your assembly defines:

```asm
global main
```

It does not define:

```asm
global _start
```

This is why `_start` appears as undefined.

**Important distinction:**

Your ELF header says:

```text
Entry point address: 0x401000
```

And `nm` says:

```text
0000000000401000 T main
```

Therefore, your actual entry point is `main`, despite the undefined `_start` symbol.

The linker selected `main` as the entry point in this particular build, probably because of the default entry-point fallback behavior.

You can verify the linker configuration with:

```bash
ld --verbose
```

For a cleaner bare-metal-style Linux assembly executable, explicitly define `_start`.

I'll show this later.

### 2. `main`

```text
0000000000401000 T main
```

Breakdown:

```text
0x401000    T    main
```

- `0x401000`: Virtual address of `main`.
- `T`: Global symbol located in the `.text` section.
- `main`: Function name.

`T` comes from the word **Text**.

Your assembly:

```asm
main:
    mov rax, 10
```

The CPU begins executing this function at:

```text
0x401000
```

### 3. `calculate`

```text
0000000000401019 T calculate
```

This is your second function.

Its address is:

```text
0x401019
```

Let's calculate the relationship between the functions.

Your disassembly shows:

```asm
401000: mov eax, 0xa
401005: mov ebx, 0x14
40100a: call 401019 <calculate>
```

The `call` instruction is at:

```text
0x40100a
```

The next instruction is at:

```text
0x40100f
```

The target function is at:

```text
0x401019
```

The relative displacement is:

```text
0x401019 - 0x40100f = 0x0a
```

Therefore, the machine code contains:

```text
e8 0a 00 00 00
```

This is a relative `CALL` instruction.

### 4. `my_value`

```text
0000000000402000 d my_value
```

Breakdown:

| Component | Value | Meaning |
|---|---|---|
| Address | `0x402000` | Variable address |
| Type | `d` | Local symbol in initialized data |
| Name | `my_value` | Variable name |

Your assembly:

```asm
section .data

my_value:
    dq 12345
```

`dq` means **Define Quadword**.

A quadword occupies 8 bytes.

The decimal value:

```text
12345
```

In hexadecimal:

```text
0x3039
```

Because x86-64 uses little-endian byte ordering, the bytes are:

```text
Address       Byte
------------------
0x402000      39
0x402001      30
0x402002      00
0x402003      00
0x402004      00
0x402005      00
0x402006      00
0x402007      00
```

Memory representation:

```text
my_value = 12345

0x402000
   |
   v
+------+------+------+------+------+------+------+------+
| 39   | 30   | 00   | 00   | 00   | 00   | 00   | 00   |
+------+------+------+------+------+------+------+------+
   1      2      3      4      5      6      7      8
```

The lowercase `d` indicates a local symbol in the initialized data section.

### 5. `__bss_start`

```text
0000000000402008 B __bss_start
```

`B` means the symbol is located in the BSS section.

`__bss_start` is a linker-generated symbol.

It identifies the beginning of the BSS region.

Your `.data` section contains 8 bytes:

```text
0x402000 - 0x402007
```

Therefore, the next address is:

```text
0x402008
```

This is where BSS begins.

### 6. `buffer`

```text
0000000000402008 b buffer
```

Your assembly:

```asm
section .bss

buffer:
    resb 64
```

`resb 64` reserves 64 bytes.

The starting address is:

```text
0x402008
```

The ending address is:

```text
0x402047
```

Calculation:

```text
0x402008 + 64 = 0x402048
```

Therefore:

```text
buffer size = 64 bytes
buffer start = 0x402008
buffer end   = 0x402047
```

Why lowercase `b` instead of uppercase `B`?

- `B`: Global BSS symbol.
- `b`: Local BSS symbol.

You declared `buffer` without `global`, so it is local.

### 7. `_edata`

```text
0000000000402008 D _edata
```

`_edata` is a linker-generated symbol.

It traditionally marks the end of initialized data.

In your executable:

```text
.data starts = 0x402000
.data size   = 8 bytes
.data ends   = 0x402008
```

Therefore:

```text
_edata = 0x402008
```

Notice that `_edata` and `__bss_start` have the same address.

This is perfectly normal.

The initialized data ends exactly where BSS begins.

### 8. `_end`

```text
0000000000402048 B _end
```

`_end` identifies the end of the program's statically allocated data/BSS region.

Your BSS:

```text
Start = 0x402008
Size  = 64 bytes
End   = 0x402048
```

Therefore:

```text
_end = 0x402048
```

This is the first address after your buffer.

---

## 2.3 Understanding `nm -n -S`

Your second command:

```bash
nm -n -S target/main
```

You noticed that the output is identical.

Why?

Let's examine the options:

| Option | Meaning |
|---|---|
| `-n` | Sort symbols by address |
| `-S` | Display symbol sizes |

Normally, `-S` adds a size column.

However, your output doesn't show symbol sizes because the executable's symbol table does not provide the sizes needed by `nm` for these symbols.

For example, your symbol table contains:

```text
0000000000401000 T main
```

But it doesn't provide the size of `main`.

You can inspect symbol sizes using:

```bash
nm -S --size-sort target/main
```

For more detailed information, use:

```bash
readelf -sW target/main
```

There you can inspect:

- Symbol value
- Symbol size
- Symbol type
- Binding
- Visibility
- Section index

---

# 3. Analyzing `objdump`

Your command:

```bash
objdump -d -M intel target/main
```

This is one of the most useful commands when reverse-engineering an executable.

It converts machine-code bytes back into human-readable assembly instructions.

## 3.1 Understanding the options

```bash
objdump -d -M intel target/main
```

| Option | Meaning |
|---|---|
| `-d` | Disassemble executable sections |
| `-M intel` | Display instructions using Intel syntax |
| `target/main` | Input executable |

Without `-M intel`, GNU `objdump` normally displays AT&T syntax.

For example:

```asm
# Intel
mov eax, 10

# AT&T
mov $10, %eax
```

## 3.2 Understanding the disassembly header

```text
target/main:     file format elf64-x86-64
```

This tells us:

| Component | Meaning |
|---|---|
| `target/main` | Executable filename |
| `elf64` | 64-bit ELF format |
| `x86-64` | Target architecture |

Next:

```text
Disassembly of section .text:
```

This means `objdump` is displaying the machine instructions stored in the `.text` section.

Remember:

```text
.text = executable machine code
.data = initialized variables
.bss  = uninitialized variables
```

## 3.3 Understanding each instruction

Your first instruction:

```text
0000000000401000 <main>:
```

This is a function label.

- Address: `0x401000`
- Symbol: `main`

The following lines are the instructions belonging to that function.

### Instruction 1

```text
401000: b8 0a 00 00 00    mov eax,0xa
```

Breakdown:

| Component | Meaning |
|---|---|
| `401000` | Instruction address |
| `b8 0a 00 00 00` | Machine-code bytes |
| `mov` | Instruction mnemonic |
| `eax` | Destination register |
| `0xa` | Immediate value (10 decimal) |

Your original NASM code:

```asm
mov rax, 10
```

Why does `objdump` show `eax` instead of `rax`?

Because the assembler optimized the instruction encoding.

In x86-64:

```asm
mov eax, 10
```

automatically zero-extends the result into the full 64-bit register.

Conceptually:

```text
RAX = 00000000 0000000A
```

Therefore, writing `eax` is sufficient to set the entire `rax` register to 10.

Machine-code breakdown:

```text
B8          = MOV EAX, immediate
0A 00 00 00 = 10 (little-endian)
```

Instruction size:

```text
1 + 4 = 5 bytes
```

The next instruction starts at:

```text
0x401000 + 5 = 0x401005
```

### Instruction 2

```text
401005: bb 14 00 00 00    mov ebx,0x14
```

Original code:

```asm
mov rbx, 20
```

Breakdown:

```text
BB          = MOV EBX, immediate
14 00 00 00 = 20 (decimal)
```

Why `0x14`?

```text
20 decimal = 0x14 hexadecimal
```

Again, writing to `ebx` zero-extends into `rbx`.

Result:

```text
RBX = 20
```

Instruction size:

```text
5 bytes
```

Next address:

```text
0x401005 + 5 = 0x40100A
```

### Instruction 3: CALL

```text
40100a: e8 0a 00 00 00    call 401019 <calculate>
```

Original code:

```asm
call calculate
```

This is particularly important for understanding x86-64 assembly.

The `call` instruction does two things:

1. Pushes the return address onto the stack.
2. Transfers execution to the target function.

The machine code:

```text
E8 0A 00 00 00
```

Here:

```text
E8 = CALL rel32
```

`rel32` means a signed 32-bit relative displacement.

Let's calculate the destination.

**Step 1: Find the address after CALL.**

```text
CALL address = 0x40100A
CALL size    = 5 bytes

Next address = 0x40100F
```

**Step 2: Calculate the relative displacement.**

```text
Target address = 0x401019
Next address   = 0x40100F

Displacement = 0x401019 - 0x40100F
             = 0x0A
```

**Step 3: Encode the displacement.**

```text
0x0000000A
```

Little-endian:

```text
0A 00 00 00
```

Complete instruction:

```text
E8 0A 00 00 00
```

This is how the CPU knows where `calculate` is located.

**What happens to the stack?**

Suppose:

```text
Before CALL:

RSP = 0x7FFFFFFFE000
```

After executing `call calculate`:

```text
RSP = 0x7FFFFFFFDFF8

[0x7FFFFFFFDFF8] = 0x40100F
```

The CPU saves the return address:

```text
0x40100F
```

This is where execution continues after `calculate` returns.

### Instruction 4

```text
40100f: b8 3c 00 00 00    mov eax,0x3c
```

Original code:

```asm
mov rax, 60
```

Why 60?

Because Linux x86-64 uses syscall number 60 for:

```c
exit(0);
```

The syscall number is passed through `RAX`.

```text
RAX = 60
```

Hexadecimal:

```text
60 decimal = 0x3C
```

Machine code:

```text
B8 3C 00 00 00
```

### Instruction 5

```text
401014: 48 31 ff    xor rdi,rdi
```

Original code:

```asm
xor rdi, rdi
```

This clears the `RDI` register.

```text
RDI = 0
```

Why use `xor` instead of:

```asm
mov rdi, 0
```

Because XOR with the same register produces zero:

```text
X XOR X = 0
```

It is also a common efficient zeroing idiom.

Machine-code breakdown:

```text
48 = REX.W prefix (64-bit operand)
31 = XOR instruction opcode
FF = ModRM byte
```

The resulting operation is:

```asm
xor rdi, rdi
```

### Instruction 6

```text
401017: 0f 05    syscall
```

Original code:

```asm
syscall
```

This instruction transfers control from user mode into the Linux kernel through the system-call mechanism.

At this point:

```text
RAX = 60
RDI = 0
```

Linux interprets this as:

```c
exit(0);
```

The process terminates with exit status zero.

---

## 3.4 Analyzing the `calculate` function

Your disassembly:

```text
0000000000401019 <calculate>:
  401019: 48 01 d8    add rax,rbx
  40101c: c3          ret
```

### Instruction 1: ADD

```text
401019: 48 01 d8    add rax,rbx
```

Original code:

```asm
add rax, rbx
```

Breakdown:

| Bytes | Meaning |
|---|---|
| `48` | REX.W prefix |
| `01` | ADD opcode |
| `D8` | ModRM byte |

The operation:

```text
RAX = RAX + RBX
```

Before:

```text
RAX = 10
RBX = 20
```

After:

```text
RAX = 30
RBX = 20
```

### Instruction 2: RET

```text
40101c: c3    ret
```

Original code:

```asm
ret
```

`RET` returns execution to the address saved by `CALL`.

Remember:

```asm
call calculate
```

Pushed:

```text
0x40100F
```

Then:

```asm
ret
```

Pops that address from the stack and transfers execution back to:

```text
0x40100F
```

### Complete machine-code mapping

This table connects your original assembly with the actual machine code.

| Address | Machine code | Assembly |
|---|---|---|
| `401000` | `b8 0a 00 00 00` | `mov eax, 10` |
| `401005` | `bb 14 00 00 00` | `mov ebx, 20` |
| `40100a` | `e8 0a 00 00 00` | `call calculate` |
| `40100f` | `b8 3c 00 00 00` | `mov eax, 60` |
| `401014` | `48 31 ff` | `xor rdi, rdi` |
| `401017` | `0f 05` | `syscall` |
| `401019` | `48 01 d8` | `add rax, rbx` |
| `40101c` | `c3` | `ret` |

One important observation:

Your `.text` section occupies:

```text
0x401000 - 0x40101C
```

Its total size is:

```text
0x40101D - 0x401000 = 29 bytes
```

---

# 4. Analyzing `file`

Your command:

```bash
file ./target/main
```

Output:

```text
./target/main: ELF 64-bit LSB executable,
x86-64, version 1 (SYSV),
statically linked, not stripped
```

Let's examine each component.

### `ELF`

ELF stands for:

**Executable and Linkable Format**

It is the standard executable and object-file format used by Linux and many Unix-like operating systems.

ELF files can represent:

- Executables
- Object files
- Shared libraries
- Core dumps

### `64-bit`

The executable uses the ELF64 format.

This means its ELF structures and address fields use the 64-bit format.

It does not mean every instruction must use 64-bit operands. For example, your executable contains:

```asm
mov eax, 10
```

which uses a 32-bit destination register.

### `LSB`

LSB means:

**Least Significant Byte first.**

This is little-endian byte ordering.

For example:

```text
Value = 0x12345678
```

Memory representation:

```text
Address     Byte
----------------
0x1000      78
0x1001      56
0x1002      34
0x1003      12
```

This is the native byte ordering of x86-64.

### `executable`

This is an executable ELF file rather than a relocatable object file.

The ELF header has:

```text
Type: EXEC
```

### `x86-64`

The target CPU architecture is x86-64.

### `version 1 (SYSV)`

The ELF identification version is version 1.

`SYSV` refers to the System V ABI identification.

The ABI specifies conventions for things such as:

- Function calling conventions
- Register usage
- Stack alignment
- Object-file conventions
- System interfaces

### `statically linked`

Your executable does not depend on a dynamically linked runtime loader.

For example, a dynamically linked executable commonly contains an ELF interpreter such as:

```text
/lib64/ld-linux-x86-64.so.2
```

Your executable was linked directly with:

```bash
ld -o target/main target/main.o
```

Without shared-library dependencies.

Note that statically linked does not mean the executable has no external dependencies of any kind. It still relies on the Linux kernel for system calls.

### `not stripped`

This means the executable retains its symbol information.

For example, you can still see:

```text
main
calculate
my_value
buffer
```

using:

```bash
nm target/main
```

If you run:

```bash
strip target/main
```

many symbol-table entries will be removed.

Then:

```bash
nm target/main
```

may report:

```text
nm: target/main: no symbols
```

The machine instructions themselves remain executable.

---

# 5. Analyzing `readelf -hW`

This is probably the most important command for understanding the ELF executable format.

Your command:

```bash
readelf -hW target/main
```

Options:

| Option | Meaning |
|---|---|
| `-h` | Display ELF header |
| `-W` | Display output without line wrapping |
| `target/main` | Input executable |

The ELF header is the first major structure in an ELF file.

It describes the file's architecture, entry point, and the locations of other ELF structures.

## 5.1 ELF Header

Your output:

```text
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
```

The magic number identifies the file as ELF.

The first four bytes are:

```text
7F 45 4C 46
```

ASCII representation:

```text
7F = DEL
45 = E
4C = L
46 = F
```

Together:

```text
ELF
```

The remaining bytes identify the ELF class, byte ordering, version, ABI, and padding.

Let's break down the important bytes:

| Offset | Value | Meaning |
|---|---|---|
| `0x00` | `7F` | ELF magic |
| `0x01` | `45` | E |
| `0x02` | `4C` | L |
| `0x03` | `46` | F |
| `0x04` | `02` | ELF64 |
| `0x05` | `01` | Little-endian |
| `0x06` | `01` | ELF version 1 |
| `0x07` | `00` | System V ABI |
| `0x08` | `00` | ABI version |

The remaining bytes are padding.

### `Class`

```text
Class: ELF64
```

The ELF file uses 64-bit ELF structures.

### `Data`

```text
Data: 2's complement, little endian
```

This describes how multi-byte values are represented.

Little-endian means the least significant byte comes first.

### `Version`

```text
Version: 1 (current)
```

ELF format version 1.

### `OS/ABI`

```text
OS/ABI: UNIX - System V
```

Identifies the ABI family.

### `ABI Version`

```text
ABI Version: 0
```

The ABI version field is zero.

### `Type`

```text
Type: EXEC (Executable file)
```

This is important.

ELF defines several file types:

| Type | Meaning |
|---|---|
| `REL` | Relocatable object file |
| `EXEC` | Executable file |
| `DYN` | Shared object or PIE executable |
| `CORE` | Core dump |

Your executable is:

```text
EXEC
```

That means the linker has produced a conventional executable with fixed virtual addresses.

### `Machine`

```text
Machine: Advanced Micro Devices X86-64
```

This identifies the architecture.

Despite the name, this is the standard ELF machine identifier for x86-64 processors, including Intel and AMD CPUs.

### `Flags`

```text
Flags: 0x0
```

Architecture-specific ELF flags.

For this executable, no additional flags are set.

---

## 5.2 Entry point address

```text
Entry point address: 0x401000
```

This is one of the most important lines.

It tells the operating system where execution should begin when the executable is loaded.

Your entry point:

```text
0x401000
```

Your symbol table:

```text
0000000000401000 T main
```

Therefore:

```text
Entry point = main
```

However, there is an important distinction.

Linux does not automatically search for a function named `main`.

The kernel starts execution at the ELF entry-point address.

In your particular executable, that address happens to be the beginning of `main`.

This also explains why your program runs despite not defining `_start`.

---

## 5.3 Program header location

```text
Start of program headers: 64 (bytes into file)
```

Program headers describe how the executable should be loaded into memory.

The first program header starts at file offset:

```text
0x40
```

Why 64?

Because an ELF64 header occupies exactly 64 bytes.

```text
ELF file layout:

Offset 0
   |
   v
+----------------------+
| ELF Header           |
| 64 bytes             |
+----------------------+
| Program Headers      | <-- Offset 64
|                      |
+----------------------+
| Program Segments     |
|                      |
+----------------------+
| Section Data         |
|                      |
+----------------------+
| Section Headers      |
|                      |
+----------------------+
```

The program headers are important to the Linux loader.

For example, they describe which parts of the executable should be mapped into memory.

---

## 5.4 Section header location

```text
Start of section headers: 8560 (bytes into file)
```

This means the section header table begins at file offset:

```text
8560 decimal = 0x2170
```

Section headers describe the individual sections of the ELF file.

For example:

```text
.text
.data
.bss
.symtab
.strtab
.shstrtab
```

These sections describe how the executable is organized.

**Important distinction:**

- Program headers describe how an executable is loaded.
- Section headers describe how the ELF file is organized.

This distinction is essential when studying ELF internals and reverse engineering.

---

## 5.5 ELF flags

```text
Flags: 0x0
```

As discussed earlier, this is the architecture-specific flags field.

For your x86-64 executable, zero is normal.

---

## 5.6 ELF header size

```text
Size of this header: 64 (bytes)
```

An ELF64 header is 64 bytes.

You can think of it as the ELF file's main metadata structure.

---

## 5.7 Program header entry size

```text
Size of program headers: 56 (bytes)
```

Each ELF64 program header occupies 56 bytes.

Your executable contains:

```text
Number of program headers: 3
```

Therefore, the complete program header table occupies:

```text
56 × 3 = 168 bytes
```

In hexadecimal:

```text
168 = 0xA8
```

---

## 5.8 Number of program headers

```text
Number of program headers: 3
```

Your executable contains three program header entries.

These describe memory-loading information.

Common program header types include:

| Type | Meaning |
|---|---|
| `LOAD` | Loadable segment |
| `DYNAMIC` | Dynamic linking information |
| `INTERP` | Dynamic linker path |
| `NOTE` | Auxiliary information |
| `GNU_STACK` | Stack permissions |
| `GNU_RELRO` | Read-only relocation region |

Your executable is statically linked, so it does not require a dynamic interpreter.

To see your actual three entries, execute:

```bash
readelf -lW target/main
```

This is an important next step.

---

## 5.9 Section header entry size

```text
Size of section headers: 64 (bytes)
```

Each ELF64 section header occupies 64 bytes.

Your executable contains seven section headers.

Therefore:

```text
64 × 7 = 448 bytes
```

The section header table occupies 448 bytes.

---

## 5.10 Number of section headers

```text
Number of section headers: 7
```

There are seven section header entries.

Your likely section layout is:

| Index | Section | Purpose |
|---:|---|---|
| 0 | NULL | Mandatory empty section |
| 1 | `.text` | Machine instructions |
| 2 | `.data` | Initialized variables |
| 3 | `.bss` | Uninitialized variables |
| 4 | `.symtab` | Symbol table |
| 5 | `.strtab` | Symbol-name strings |
| 6 | `.shstrtab` | Section-name strings |

This is consistent with your output, although you should verify the exact names and indexes using:

```bash
readelf -SW target/main
```

Let's understand the last three sections:

**`.symtab`**

Contains symbol information such as:

```text
main
calculate
my_value
buffer
```

**`.strtab`**

Contains strings referenced by the symbol table.

For example:

```text
main\0calculate\0my_value\0buffer\0
```

**`.shstrtab`**

Contains section names:

```text
.text
.data
.bss
.symtab
.strtab
.shstrtab
```

---

## 5.11 Section header string table index

```text
Section header string table index: 6
```

This tells us that section index 6 contains the section-name string table.

Based on the likely layout above:

```text
Index 6 = .shstrtab
```

The ELF loader and analysis tools use this table to resolve section names.

---

# 6. Understanding the complete ELF memory layout

Now let's combine the information from all four commands.

Based on your output, the executable has the following virtual address layout:

```text
              ELF VIRTUAL MEMORY LAYOUT
              =========================

        0x401000
            |
            v
    +-----------------------+
    |       .text           |
    |-----------------------|
    | main                  |
    |                       |
    | 401000 mov eax, 10    |
    | 401005 mov ebx, 20    |
    | 40100a call calculate |
    | 40100f mov eax, 60    |
    | 401014 xor rdi, rdi   |
    | 401017 syscall        |
    |                       |
    | calculate             |
    | 401019 add rax, rbx   |
    | 40101c ret            |
    +-----------------------+
            |
            | Alignment gap
            |
        0x402000
            |
            v
    +-----------------------+
    |       .data           |
    |-----------------------|
    | my_value              |
    | 8 bytes               |
    |                       |
    | Value = 12345         |
    +-----------------------+
            |
        0x402008
            |
            v
    +-----------------------+
    |        .bss           |
    |-----------------------|
    | buffer                |
    |                       |
    | 64 bytes              |
    +-----------------------+
            |
        0x402048
            |
            v
          _end
```

A few important observations:

1. `.text` and `.data` have different virtual addresses.
2. `.data` contains actual initialized bytes in the executable.
3. `.bss` reserves memory but generally does not occupy corresponding initialized bytes in the executable file.
4. The linker generates symbols such as `__bss_start`, `_edata`, and `_end`.

**Remember:** These are virtual addresses, not necessarily physical RAM addresses.

Linux maps the executable into the process's virtual address space.

---

# 7. Important: Sections versus Segments

This is one of the most important ELF concepts.

You have already seen:

```text
.text
.data
.bss
```

These are sections.

However, Linux loads an ELF executable using its **program headers**, which describe segments.

Consider:

```text
ELF SECTIONS                  ELF SEGMENTS
=============                 ============

.text       --------+
                    |
.data       --------+-------> LOAD segment
                    |
.bss        --------+
```

Multiple sections can belong to one segment.

For example, a typical ELF executable might contain:

```text
LOAD:
    .text

LOAD:
    .data
    .bss
```

The actual arrangement depends on the linker script.

To inspect this:

```bash
readelf -lW target/main
```

To inspect sections:

```bash
readelf -SW target/main
```

These two commands are essential when studying ELF internals.

---

# 8. Additional commands for deeper reverse engineering

I recommend experimenting with these commands using your current executable.

## 8.1 Inspect all ELF sections

```bash
readelf -SW target/main
```

Shows:

- Section names
- Section addresses
- File offsets
- Section sizes
- Section flags
- Alignment

Pay particular attention to:

```text
.text
.data
.bss
.symtab
.strtab
.shstrtab
```

## 8.2 Inspect all symbols

```bash
readelf -sW target/main
```

Shows the ELF symbol table.

You can inspect:

```text
Symbol value
Symbol size
Symbol type
Symbol binding
Symbol visibility
Section index
```

This is more detailed than `nm`.

## 8.3 Inspect program headers

```bash
readelf -lW target/main
```

Shows the segments used when loading the executable.

Pay attention to:

```text
LOAD
GNU_STACK
GNU_RELRO
```

## 8.4 Display all disassembly

```bash
objdump -D -M intel target/main
```

Difference:

| Command | Description |
|---|---|
| `objdump -d` | Disassembles sections expected to contain executable instructions |
| `objdump -D` | Disassembles all non-empty sections, including data sections |

Be careful: `-D` can interpret data bytes as instructions.

## 8.5 Display section headers

```bash
objdump -h target/main
```

This provides another way to inspect section sizes, addresses, and offsets.

## 8.6 Display machine code in hexadecimal

```bash
objdump -s target/main
```

Displays section contents in hexadecimal and ASCII.

Useful for examining `.data` and other binary contents.

## 8.7 Display relocation information

```bash
readelf -rW target/main
```

Displays relocation entries.

Your current executable may have no relocation entries because the linker has already resolved the relevant addresses.

---

# 9. One issue I recommend fixing: `_start`

Your original output contains:

```text
U _start
```

Although your program runs, this is worth cleaning up.

Your current executable uses:

```text
Entry point address: 0x401000
```

which happens to point to `main`.

But Linux does not require a function called `main`. It requires a valid ELF entry point.

For a standalone Linux assembly program, I recommend explicitly defining `_start`.

Change your code to:

```asm
global _start
global calculate

section .text

_start:
    mov rax, 10
    mov rbx, 20

    call calculate

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall


calculate:
    add rax, rbx
    ret


section .data

my_value:
    dq 12345


section .bss

buffer:
    resb 64


section .note.GNU-stack noalloc noexec nowrite progbits
```

Build:

```bash
nasm -f elf64 src/main.asm -o target/main.o

ld -e _start -o target/main target/main.o
```

Now inspect:

```bash
nm -n target/main
readelf -hW target/main
objdump -d -M intel target/main
```

You should see:

```text
Entry point address: 0x401000
```

And:

```text
0000000000401000 T _start
```

The undefined `_start` symbol should disappear.

The `.note.GNU-stack` section also explicitly indicates that the object does not require an executable stack.

---

# 10. My recommended ELF reverse-engineering workflow

For your Rust OS and x86-64 assembly learning, I recommend getting comfortable with this sequence:

| Step | Command | What you investigate |
|---|---|---|
| 1 | `file target/main` | Binary format and architecture |
| 2 | `nm -n target/main` | Symbol addresses |
| 3 | `nm -n -S target/main` | Symbol addresses and sizes |
| 4 | `objdump -d -M intel target/main` | Assembly instructions |
| 5 | `objdump -h target/main` | Section information |
| 6 | `objdump -s target/main` | Raw binary contents |
| 7 | `readelf -hW target/main` | ELF header |
| 8 | `readelf -SW target/main` | ELF sections |
| 9 | `readelf -lW target/main` | ELF segments |
| 10 | `readelf -sW target/main` | ELF symbol table |
| 11 | `readelf -rW target/main` | Relocation information |

### Bonus: Combine these tools with GDB

You can investigate the actual execution rather than just analyzing the static executable.

```bash
gdb ./target/main
```

Inside GDB:

```gdb
# Disassemble main
disassemble main

# Disassemble calculate
disassemble calculate

# Set breakpoint
break calculate

# Start execution
starti

# Execute one instruction
si

# Inspect registers
info registers

# Inspect instruction pointer
p/x $rip

# Inspect stack pointer
p/x $rsp

# Inspect 10 instructions
x/10i $rip

# Inspect 32 bytes of memory
x/32xb 0x402000
```

For example, after executing:

```asm
add rax, rbx
```

you can inspect:

```gdb
info registers rax rbx
```

Expected:

```text
rax    0x1e    30
rbx    0x14    20
```

---

## Final takeaway

Think of these four tools as four different windows into the same executable:

```text
                  target/main
                       |
          +------------+------------+
          |            |            |
          v            v            v
         nm         objdump       file
          |            |            |
          v            v            v
       Symbols      Assembly     File type
       Addresses    Instructions Architecture
          |
          |
          +--------------------------+
                                     |
                                     v
                                  readelf
                                     |
                                     v
                              ELF Internals
                                     |
                      +--------------+--------------+
                      |              |              |
                      v              v              v
                   Header         Sections       Segments
```

**My recommendation:** Your next important topic should be understanding the relationship between ELF file offsets, virtual addresses, sections, and program segments. Once you understand those four concepts, you'll have a much stronger foundation for analyzing Linux executables, debugging assembly, and eventually understanding how your own Rust x86-64 kernel is loaded into memory.
