# Analyzing assembly with `nm`, `objdump`, and `readelf`

These three Linux command-line tools are essential for understanding how a compiler, assembler, linker, and loader turn source code into an executable program.

If you're learning x86-64 assembly, Rust `no_std`, and bare-metal kernel development, I recommend learning all three together because they reveal different layers of an ELF binary.

## Three tools, three perspectives

**`nm` — Symbol analysis**

Find functions, global variables, undefined symbols, and symbol addresses.

What symbols exist?

---

**`objdump` — Machine-code analysis**

Disassemble instructions, inspect sections, and examine relocations.

What instructions were generated?

---

**`readelf` — ELF structure analysis**

Inspect ELF headers, sections, segments, symbols, and relocation entries.

How is the executable structured?

Let's use a practical x86-64 Linux example and examine it from beginning to end.

---

# 1\. Prepare a sample assembly program

Create `main.s`\:

```asm
.intel_syntax noprefix

.global _start
.global calculate

.section .text

_start:
    mov rax, 10
    mov rbx, 20

    call calculate

    mov rax, 60
    xor rdi, rdi
    syscall

calculate:
    add rax, rbx
    ret

.section .data

my_value:
    .quad 12345

.section .bss

buffer:
    .skip 64

.section .note.GNU-stack,"",@progbits
```



Assemble and link\:

```bash
as --64 -o main.o main.s

ld -o main main.o
```



You now have two ELF files\:

| File | Description |
|--------|--------|
| `main.o` | Relocatable ELF object file |
| `main` | Executable ELF file |

Run it\:

```bash
./main
echo $?
```



Expected exit status\:

```
0
```



We will inspect both files because the differences between an object file and an executable are important.

# 2\. `nm` — Analyze symbols

`nm` displays the symbol table of an object file or executable.

A symbol is a named entity that the assembler or linker knows about, such as\:

- Functions
- Global variables
- Static data
- Undefined external functions
- Linker-defined addresses

## 2.1 Basic usage

```bash
nm main.o
```



Example output\:

```bash
0000000000000000 T _start
0000000000000018 T calculate
0000000000000000 D my_value
0000000000000000 B buffer
```



The general format is\:

```bash
address  type  symbol_name
```



For example\:

```
0000000000000018 T calculate
```



Means\:

- `0000000000000018`\: symbol offset/address
- `T`\: symbol is in the text section (code)
- `calculate`\: symbol name

Note that addresses in a relocatable `.o` file are section-relative offsets, not necessarily final runtime addresses.

## 2.2 Understand symbol types

This is one of the most important things to learn about `nm`\.

| Letter | Meaning |
|--------|--------|
| `T` | Global symbol in text section |
| `t` | Local symbol in text section |
| `D` | Global initialized data |
| `d` | Local initialized data |
| `B` | Global uninitialized data (BSS) |
| `b` | Local uninitialized data (BSS) |
| `R` | Global read-only data |
| `r` | Local read-only data |
| `U` | Undefined symbol |
| `A` | Absolute symbol |
| `W` | Weak symbol |
| `V` | Weak object symbol |
| `C` | Common symbol |

Uppercase generally indicates a global symbol; lowercase generally indicates a local symbol. There are some special cases.

## 2.3 Useful `nm` options

### `-n`\: Sort by address

```bash
nm -n main
```



Sorts symbols by their numerical address.

Useful when studying\:

- Function layout
- Memory layout
- Linker placement
- Symbol address relationships

### `-S`\: Show symbol sizes

```bash
nm -S main
```



Example\:

```bash
0000000000401000 0000000000000018 T _start
0000000000401018 0000000000000004 T calculate
```



The second column represents the symbol size in bytes.

This is useful for estimating function sizes.

### `-C`\: Demangle C++ and Rust symbols

```bash
nm -C program
```



Rust example\:

```bash
nm -C target/debug/my_program
```



Without demangling, Rust symbols can look like\:

```bash
_ZN...
```



With demangling, they become more readable.

### `-u`\: Show undefined symbols

```bash
nm -u main.o
```



This shows symbols referenced by the object file but not defined there.

For example, if your assembly contains\:

```asm
.extern printf

call printf
```



You should see\:

```
                 U printf
```



This tells you that the linker must resolve `printf`\.

### `-g`\: Show external symbols only

```bash
nm -g main.o
```



Useful for distinguishing externally visible symbols from local symbols.

### `-a`\: Show all symbols

```bash
nm -a main.o
```



Includes debugging and other special symbols where available.

### `-A`\: Show the input filename

```bash
nm -A *.o
```



Useful when inspecting multiple object files.

### `-l`\: Show source filename and line number

```bash
nm -l main
```



Works best when debug information is present.

### `-D`\: Dynamic symbols

```bash
nm -D /bin/ls
```



Displays the dynamic symbol table rather than the ordinary symbol table.

This is especially useful for dynamically linked executables and shared libraries.

## 2.4 Practical symbol-analysis commands

Try these\:

```bash
# All symbols sorted by address
nm -n main

# Symbol addresses and sizes
nm -n -S main

# Only global symbols
nm -g main

# Only undefined symbols
nm -u main.o

# Demangle Rust symbols
nm -C target/debug/my_program

# Dynamic symbols
nm -D /lib/x86_64-linux-gnu/libc.so.6
```



**Important\:** `nm` tells you where symbols are, but it does not show you the actual machine instructions.

That's where `objdump` comes in.

---

# 3\. `objdump` — Disassemble machine code

`objdump` is probably the most important of these three tools when your goal is understanding assembly instructions generated by a compiler.

It can\:

- Disassemble executable code.
- Display section information.
- Show relocations.
- Display symbols.
- Inspect raw section contents.
- Display instruction addresses and machine-code bytes.

## 3.1 Basic disassembly

```bash
objdump -d main
```



Example\:

```bash
0000000000401000 <_start>:
  401000: 48 c7 c0 0a 00 00 00    mov    $0xa,%rax
  401007: 48 c7 c3 14 00 00 00    mov    $0x14,%rbx
  40100e: e8 05 00 00 00          call   401018 <calculate>
  401013: 48 c7 c0 3c 00 00 00    mov    $0x3c,%rax
  40101a: 48 31 ff                xor    %rdi,%rdi
  40101d: 0f 05                   syscall

000000000040101f <calculate>:
  40101f: 48 01 d8                add    %rbx,%rax
  401022: c3                      ret
```



The exact addresses and encodings can vary depending on your source and linker output.

Let's understand the output format\:

```txt
address: machine_code_bytes    assembly_instruction
```



For example\:

```bash
40101f: 48 01 d8    add %rbx,%rax
```



- `40101f`\: instruction address
- `48 01 d8`\: machine-code bytes
- `add %rbx,%rax`\: assembly instruction

This is useful when learning how x86-64 instructions are encoded.

## 3.2 `-M intel`\: Use Intel syntax

By default, GNU `objdump` generally displays AT&amp;T syntax on x86.

You can switch to Intel syntax\:

```bash
objdump -d -M intel main
```



AT&amp;T\:

```asm
mov $0xa, %rax
add %rbx, %rax
```



Intel\:

```asm
mov rax, 0xa
add rax, rbx
```



Since you've been studying both Intel and AT&amp;T assembly, I recommend using\:

```bash
objdump -d -M intel main
```



You can also specify additional disassembly options\:

```bash
objdump -d -M intel,addr64,data64 main
```



## 3.3 `-D`\: Disassemble all sections

```bash
objdump -D -M intel main
```



Difference\:

| Option | Behavior |
|--------|--------|
| `-d` | Disassemble sections expected to contain instructions |
| `-D` | Disassemble all non-empty sections |

Be careful: `-D` can interpret data as instructions. Not every instruction-looking output is actually executable code.

## 3.4 `-j`\: Disassemble a specific section

```bash
objdump -d -j .text -M intel main
```



Only disassembles `.text`\.

Other useful sections\:

```bash
objdump -s -j .data main
objdump -s -j .rodata main
objdump -s -j .bss main
```



Note that `.bss` is normally `NOBITS`, so it has no initialized bytes to dump.

## 3.5 `-h`\: Display section headers

```bash
objdump -h main
```



Example\:

```bash
Idx Name          Size      VMA       LMA       File off
  0 .text         00000026  00401000  00401000  00001000
  1 .data         00000008  00402000  00402000  00002000
  2 .bss          00000040  00402008  00402008  00002008
```



Important columns\:

| Column | Meaning |
|--------|--------|
| Name | Section name |
| Size | Section size |
| VMA | Virtual memory address |
| LMA | Load memory address |
| File off | Offset inside the ELF file |

This is particularly useful when debugging your bare-metal kernel and linker scripts.

## 3.6 `-r`\: Display relocation information

```bash
objdump -r main.o
```



Suppose you have\:

```asm
.extern external_function

.global _start

.text
_start:
    call external_function
```



The assembler cannot know the final address of `external_function`\.

It generates a relocation entry.

Example\:

```bash
RELOCATION RECORDS FOR [.text]:
OFFSET           TYPE                 VALUE
0000000000000001 R_X86_64_PLT32       external_function-0x4
```



This tells the linker where and how to patch the machine code.

Try\:

```bash
objdump -r main.o
```



Then compare\:

```bash
objdump -r main
```



The linked executable usually has fewer ordinary static relocations because the linker has already resolved them.

## 3.7 `-t`\: Display the symbol table

```bash
objdump -t main
```



This is another way to inspect symbols, similar to `nm`\.

## 3.8 `-s`\: Display raw section contents

```bash
objdump -s main
```



This displays hexadecimal bytes and their ASCII representation where applicable.

To inspect just `.data`\:

```bash
objdump -s -j .data main
```



Useful for understanding\:

- Integer representation
- String storage
- Endianness
- Initialized global variables
- Raw machine-code bytes

## 3.9 `-f`\: Display file header

```bash
objdump -f main
```



Shows information such as\:

- File format
- Architecture
- Object format
- Start address

## 3.10 `-S`\: Mix source code and assembly

```bash
objdump -S -M intel main
```



For source-level correlation, compile with debug information\:

```bash
gcc -g -O0 -no-pie -o program program.c

objdump -S -M intel program
```



This is particularly useful when studying how C or Rust code becomes machine instructions.

For Rust\:

```bash
cargo build
objdump -S -M intel target/debug/my_program
```



You need usable debug information and matching source files for meaningful source annotations.

---

# 4\. `readelf` — Analyze ELF binary structure

`readelf` is specifically designed to inspect ELF (Executable and Linkable Format) files.

Unlike `objdump`, it focuses heavily on ELF metadata and structure rather than disassembling instructions.

This is especially important for your x86-64 kernel project because it helps you understand\:

- ELF headers
- Section headers
- Program headers
- Memory segments
- Entry points
- Symbol tables
- Relocation entries
- Dynamic linking

## 4.1 `-h`\: ELF header

```bash
readelf -h main
```



Example\:

```bash
ELF Header:
  Magic:   7f 45 4c 46
  Class:                             ELF64
  Data:                              2's complement, little endian
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Entry point address:               0x401000
  Start of program headers:          64
  Start of section headers:          ...
```



Important fields\:

| Field | Meaning |
|--------|--------|
| Magic | ELF identification bytes |
| Class | ELF32 or ELF64 |
| Data | Endianness |
| Type | Object, executable, shared library, etc. |
| Machine | Target architecture |
| Entry point | Initial execution address |
| Program headers | Offset of program header table |
| Section headers | Offset of section header table |

One particularly important field is\:

```
Entry point address: 0x401000
```



This tells you where execution begins.

For a bare-metal kernel, this is especially important when examining your linker script and bootloader.

## 4.2 `-S`\: Section headers

```bash
readelf -S main
```



Example\:

```
[Nr] Name       Type      Address           Offset
[ 1] .text      PROGBITS  0000000000401000  001000
[ 2] .data      PROGBITS  0000000000402000  002000
[ 3] .bss       NOBITS    0000000000402008  002008
```



Important ELF section types\:

| Section | Purpose |
|--------|--------|
| `.text` | Machine instructions |
| `.data` | Initialized global data |
| `.bss` | Uninitialized global data |
| `.rodata` | Read-only data |
| `.symtab` | Full symbol table |
| `.strtab` | Symbol names |
| `.shstrtab` | Section names |
| `.rela.text` | Relocations for `.text` |
| `.debug_info` | Debugging information |

To see the complete section header information\:

```bash
readelf -SW main
```



`-W` means wide output, preventing many fields from being truncated.

## 4.3 `-l`\: Program headers

```
readelf -l main
```



This is one of the most important commands for operating-system development.

Example\:

```bash
Program Headers:
  Type   Offset   VirtAddr           FileSiz  MemSiz   Flags
  LOAD   0x001000 0x0000000000401000 0x000026 0x000026 R E
  LOAD   0x002000 0x0000000000402000 0x000008 0x000048 RW
```



Understand the difference\:

**Section headers** describe the logical organization of an ELF file.

**Program headers** describe how the executable is mapped into memory.

For example\:

```bash
LOAD  R E
```



Means\:

- `LOAD`\: Loadable segment.
- `R`\: Read permission.
- `E`\: Execute permission.

Another example\:

```bash
LOAD  RW
```



Means\:

- Readable.
- Writable.
- Not executable.

This distinction is fundamental to understanding memory protection.

## 4.4 `-s`\: Display symbol tables

```bash
readelf -s main
```



Example\:

```bash
Num: Value             Size Type    Bind   Vis      Ndx Name
  1: 0000000000401000    35 FUNC    GLOBAL DEFAULT    1 _start
  2: 000000000040101f     4 FUNC    GLOBAL DEFAULT    1 calculate
  3: 0000000000402000     8 OBJECT  GLOBAL DEFAULT    2 my_value
```



Important columns\:

| Column | Meaning |
|--------|--------|
| Value | Symbol address or section-relative value |
| Size | Symbol size |
| Type | Function, object, etc. |
| Bind | LOCAL, GLOBAL, WEAK |
| Vis | Symbol visibility |
| Ndx | Section index |
| Name | Symbol name |

You can also use\:

```bash
readelf --symbols main
```



## 4.5 `-r`\: Display relocations

```bash
readelf -r main.o
```



Example\:

```bash
Relocation section '.rela.text' contains 1 entry:
  Offset          Info           Type              Symbol
  000000000001    ...            R_X86_64_PLT32    external_function
```



ELF relocation types are extremely useful when studying how the linker resolves symbols.

Some common x86-64 relocation types\:

| Relocation | Meaning |
|--------|--------|
| `R_X86_64_64` | 64-bit absolute address |
| `R_X86_64_PC32` | 32-bit PC-relative reference |
| `R_X86_64_PLT32` | PC-relative reference through PLT |
| `R_X86_64_32` | 32-bit absolute address |
| `R_X86_64_32S` | Signed 32-bit absolute address |
| `R_X86_64_RELATIVE` | Base-relative dynamic relocation |
| `R_X86_64_GLOB_DAT` | Dynamic symbol address relocation |
| `R_X86_64_JUMP_SLOT` | Dynamic function-call relocation |

## 4.6 `-d`\: Display dynamic section

```bash
readelf -d /bin/ls
```



Displays dynamic linking information.

You might see\:

```bash
NEEDED Shared library: [libc.so.6]
NEEDED Shared library: [libselinux.so.1]
```



This indicates that the executable requires shared libraries.

Useful when analyzing\:

- Dynamic linking
- Shared libraries
- Runtime dependencies
- Dynamic linker behavior

## 4.7 `-n`\: Display notes

```bash
readelf -n main
```



Displays ELF notes, which can contain information about\:

- GNU build IDs
- ABI information
- Architecture properties
- Security-related properties

## 4.8 `-a`\: Display everything

```bash
readelf -a main
```



This prints most ELF metadata in one command.

It can produce a lot of output, so I recommend inspecting individual components first.

## 4.9 More useful commands

```bash
# ELF header
readelf -h main

# Section headers
readelf -SW main

# Program headers
readelf -lW main

# Symbol tables
readelf -sW main

# Relocations
readelf -rW main

# Dynamic linking information
readelf -dW main

# Notes
readelf -n main

# Full ELF inspection
readelf -aW main
```



---

# 5\. Compare the three tools

Let's compare how each tool answers the same questions.

| What you want to know | Command |
|--------|--------|
| What functions exist? | `nm main` |
| What are their addresses? | `nm -n main` |
| What are their sizes? | `nm -S main` |
| What machine instructions were generated? | `objdump -d main` |
| Show Intel assembly syntax | `objdump -d -M intel main` |
| Show raw machine-code bytes | `objdump -s main` |
| What sections exist? | `readelf -S main` |
| What segments are loaded? | `readelf -l main` |
| Where does execution begin? | `readelf -h main` |
| What symbols are defined? | `readelf -s main` |
| What relocations exist? | `readelf -r main.o` |
| What shared libraries are required? | `readelf -d main` |

The most important distinction\:

```bash
nm
 |
 +-- Symbol names and addresses

objdump
 |
 +-- Instructions and machine-code bytes

readelf
 |
 +-- ELF structure and metadata
```



---

# 6\. Practical exercise: Investigate a function address

Let's connect the three tools to something you've already been studying: finding function addresses in assembly.

Suppose your disassembly shows\:

```
00401000 <_start>:
  401000: mov rax, 10
  401007: mov rbx, 20
  40100e: call 40101f <calculate>

0040101f <calculate>:
  40101f: add rax, rbx
  401022: ret
```



How can we find the address of `calculate`?

**Step 1 — Use `nm`\:**

```bash
nm -n main
```



Output\:

```
0000000000401000 T _start
000000000040101f T calculate
```



**Step 2 — Use `objdump`\:**

```bash
objdump -d -M intel main
```



Find\:

```
40101f <calculate>:
```



**Step 3 — Use `readelf`\:**

```bash
readelf -sW main | grep calculate
```



Output\:

```
2: 000000000040101f 4 FUNC GLOBAL DEFAULT 1 calculate
```



All three tools confirm the address\:

```
calculate = 0x40101f
```



## Understanding a CALL instruction

Consider\:

```
40100e: e8 05 00 00 00    call 40101f
```



The instruction is five bytes long.

On x86-64, a near relative `call` uses a signed 32-bit displacement.

The CPU calculates\:

$$
\text{Target} = \text{Next RIP} + \text{Displacement}
$$

Therefore\:

$$
0x401013 + 0x05 = 0x401018
$$

The actual target must match the address shown by your disassembler. In the example above, the correct displacement from `0x401013` to `0x40101f` is `0x0c`, not `0x05`\.

This is a useful example of why you should verify machine-code bytes against instruction addresses rather than trusting a manually transcribed disassembly.

# 7\. Advanced workflow: Analyze an object file before linking

This is particularly useful when writing assembly manually or investigating Rust compiler output.

Let's create another example.

`external.s`\:

```asm
.intel_syntax noprefix

.global _start
.extern calculate

.section .text

_start:
    mov rdi, 10
    mov rsi, 20
    call calculate

.section .note.GNU-stack,"",@progbits
```



Assemble\:

```
as --64 -o external.o external.s
```



Now inspect it before linking.

**1\. Inspect symbols**

```bash
nm external.o
```



You should find\:

```
                 U calculate
0000000000000000 T _start
```



**2\. Inspect machine instructions**

```bash
objdump -d -M intel external.o
```



**3\. Inspect relocation entries**

```bash
objdump -r external.o
```



Or\:

```bash
readelf -rW external.o
```



You will find a relocation referencing `calculate`\.

**4\. Inspect the ELF structure**

```bash
readelf -h external.o
readelf -SW external.o
readelf -sW external.o
```



Notice that `external.o` is a relocatable object file, not a standalone executable.

This is exactly the process that happens when you compile Rust code into `.o` files and eventually link them into your kernel.

---

# 8\. My recommended command collection

I recommend saving these commands as your assembly-analysis cheat sheet.

## Assembly analysis CLI cheat sheet

**Symbol inspection — nm**

```bash
nm -n program
nm -n -S program
nm -C program
nm -u program.o
nm -g program
nm -D program
```



---

**Disassembly — objdump**

```bash
objdump -d -M intel program
objdump -D -M intel program
objdump -h program
objdump -t program
objdump -r program.o
objdump -s program
objdump -S -M intel program
objdump -f program
```



---

**ELF inspection — readelf**

```bash
readelf -hW program
readelf -SW program
readelf -lW program
readelf -sW program
readelf -rW program.o
readelf -dW program
readelf -n program
readelf -aW program
```



[Copy commands]

# 9\. Apply this to your Rust x86-64 kernel

For your `x86_64-unknown-none` target, these commands are particularly useful.

Assuming your kernel executable is\:

```bash
target/x86_64-unknown-none/debug/kernel
```



Run\:

```bash
# 1. Find kernel entry points
nm -n target/x86_64-unknown-none/debug/kernel

# 2. Find function sizes
nm -n -S target/x86_64-unknown-none/debug/kernel

# 3. Disassemble kernel instructions
objdump -d -M intel target/x86_64-unknown-none/debug/kernel

# 4. Inspect ELF entry point
readelf -hW target/x86_64-unknown-none/debug/kernel

# 5. Inspect memory segments
readelf -lW target/x86_64-unknown-none/debug/kernel

# 6. Inspect section layout
readelf -SW target/x86_64-unknown-none/debug/kernel

# 7. Inspect relocations
readelf -rW target/x86_64-unknown-none/debug/kernel
```



For your bootloader and linker-script investigations, pay special attention to these relationships\:

**ELF loading and execution**

**ELF Header**

readelf -h

Entry point and architecture

**Program Headers**

readelf -l

Loadable memory segments

**Section Headers**

readelf -S

\.text, .data, .bss, .rodata

**Symbol Table**

nm / readelf -s

\_start, rust\_main, kernel\_main

**Machine Instructions**

objdump -d

Actual CPU instructions

One important distinction for your OS project: ELF sections and ELF segments are not interchangeable. A bootloader normally uses program headers to determine which parts of an ELF executable to load. Your linker script determines how sections are arranged into those segments.

---

# 10\. What I recommend learning next

There are four natural next steps\:

1. **ELF internals\:** Understand ELF headers, section headers, program headers, and how the linker creates segments.
2. **Relocation internals\:** Understand `R_X86_64_PC32`, `R_X86_64_PLT32`, and how `call` instructions get patched by the linker.
3. **GDB integration\:** Use `nm` to locate a function, `objdump` to inspect it, and GDB to set breakpoints and examine registers.
4. **Rust compiler analysis\:** Compare `cargo rustc -- --emit=asm,obj` output with the final linked executable.

I would recommend starting with **relocation internals**, because understanding how a symbolic instruction such as `call calculate` becomes a real machine-code address is one of the most important steps toward understanding assemblers, linkers, and operating-system boot processes.
