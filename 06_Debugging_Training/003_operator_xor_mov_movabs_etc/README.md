# gdb 기본 패턴
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

# `movabs` in x86-64 assembly

`movabs` is an instruction mnemonic used by GNU assembler and disassemblers to represent a `MOV` instruction that transfers a **64-bit immediate value or a 64-bit memory address**\.

It is particularly useful when working with 64-bit constants and absolute addresses.

One important detail: **`movabs` is not a separate CPU instruction from `mov`\.** It is an assembler mnemonic that makes the 64-bit immediate or displacement form explicit.

## 1\. Why does `movabs` exist?

In x86-64, ordinary `mov` instructions have several encoding forms.

For example\:

```
mov rax, 123
```



This can use a relatively compact encoding because `123` fits into a signed 32-bit immediate.

But consider\:

```
mov rax, 0x123456789ABCDEF0
```



That value cannot fit into 32 bits.

Therefore, the assembler needs an instruction encoding that supports a full 64-bit immediate.

This is where `movabs` comes in\:

```
movabs rax, 0x123456789ABCDEF0
```



The CPU loads the complete 64-bit constant into `RAX`\.

## 2\. Compare `mov` and `movabs`

Consider these examples\:

```
; Small immediate
mov rax, 100

; 32-bit immediate
mov eax, 0x12345678

; Full 64-bit immediate
movabs rax, 0x123456789ABCDEF0
```



The important encoding differences\:

| Instruction | Immediate size | Instruction size |
|--------|--------|--------|
| `mov eax, 100` | 32 bits | 5 bytes |
| `mov rax, 100` | 32 bits, sign-extended | 7 bytes |
| `movabs rax, 0x123456789ABCDEF0` | 64 bits | 10 bytes |

The full 64-bit immediate form uses the `B8+rd` opcode encoding with an eight-byte immediate. [computerinternals.app](https://www.computerinternals.app/en/foundations/endianness)[gnu.googlesource.com](https://gnu.googlesource.com/binutils-gdb/%2B/master/opcodes/i386-opc.tbl)

### Important: 32-bit writes zero the upper half

```
mov eax, 0x12345678
```



Results in\:

```
RAX = 0x0000000012345678
```



But\:

```
movabs rax, 0x123456789ABCDEF0
```



Results in\:

```
RAX = 0x123456789ABCDEF0
```



This distinction is important when analyzing register values in GDB.

## 3\. Situation: Loading a 64-bit memory address

This is especially relevant to your previous `nm` and `objdump` experiments.

Suppose\:

```
my_value = 0x0000000000402000
```



You want to load this address into `RDX`\.

```
movabs rdx, 0x402000
```



After execution\:

```
RDX = 0x0000000000402000
```



Notice something important\:

**This loads the address, not the value stored at that address.**

To access the memory contents\:

```
mov rax, [rdx]
```



Let's visualize it\:

**Before execution**

RDX **0x0000000000000000**

---

**Instruction 1**

```
movabs rdx, 0x402000
```



RDX **0x402000**

---

**Memory**

Address

**0x402000**

Stored value

**12345**

---

**Instruction 2**

```
mov rax, [rdx]
```



RAX **12345**

This is a common pattern in low-level programming.

---

## 4\. Why does `objdump` show `movabs`?

Suppose you execute\:

```
objdump -d -M intel target/main
```



And see\:

```
00401000    movabs rcx, 0x402001
0040100a    movabs rdx, 0x402000
00401014    sub    rcx, rdx
```



Let's understand each instruction\:

```
movabs rcx, 0x402001
```



Loads the constant `0x402001` into `RCX`\.

```
movabs rdx, 0x402000
```



Loads the constant `0x402000` into `RDX`\.

```
sub rcx, rdx
```



Calculates\:

\[
0x402001 - 0x402000 = 1
\]

Final result\:

```
RCX = 1
RDX = 0x402000
```



Why did the compiler or assembler use `movabs` even though the addresses are relatively small?

Because the selected machine-code encoding supports a 64-bit immediate. The assembler or compiler may choose this form depending on relocation requirements and code-generation decisions.

For nearby addresses, another possibility is RIP-relative addressing\:

```
lea rdx, [rip + my_value]
```



This is often preferable for position-independent code. [gitlab.com](https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/low-level-sys-info.tex)[fuchsia.googlesource.com](https://fuchsia.googlesource.com/third_party/binutils-gdb/%2B/46d00b8af141a8ef29f4b9cd49ab70839b6e5ba8/gas/doc/c-i386.texi)


## 5\. Another situation: Absolute memory addressing

There is another less common use of `movabs`\: accessing memory through a 64-bit absolute address.

For example, in GNU AT&amp;T syntax\:

```
movabsq 0x123456789ABCDEF0, %rax
```



This represents loading from the absolute memory address into `RAX`, rather than loading the address itself as an immediate.

The distinction\:

| Instruction | Meaning |
|--------|--------|
| `movabs rax, 0x402000` | Load address constant into RAX |
| `mov rax, [0x402000]` | Load memory contents from address |
| `lea rax, [rip + offset]` | Calculate a RIP-relative address |

The exact absolute memory-offset form has special encoding restrictions; it is not a general replacement for arbitrary memory addressing. [llvm.googlesource.com](https://llvm.googlesource.com/llvm.git/%2B/refs/heads/master/lib/Target/X86/X86InstrInfo.td)[fuchsia.googlesource.com](https://fuchsia.googlesource.com/third_party/binutils-gdb/%2B/46d00b8af141a8ef29f4b9cd49ab70839b6e5ba8/gas/doc/c-i386.texi)

## 6\. Practical experiment

Create `movabs.s`\:

```
.intel_syntax noprefix

.global _start

.section .text

_start:
    mov eax, 100
    mov rbx, 100
    movabs rcx, 0x123456789ABCDEF0

    mov rax, 60
    xor rdi, rdi
    syscall

.section .note.GNU-stack,"",@progbits
```



Compile\:

```
as --64 -o movabs.o movabs.s
ld -o movabs movabs.o
```



Disassemble\:

```
objdump -d -M intel movabs
```



Inspect machine-code bytes\:

```
objdump -d -Mintel --show-raw-insn movabs
```



For the full-width immediate instruction, expect an encoding similar to\:

```
48 b9 f0 de bc 9a 78 56 34 12
```



Breakdown\:

```
48          REX.W prefix
B9          MOV RCX, imm64 opcode
F0 DE BC 9A 78 56 34 12
            64-bit immediate (little-endian)
```



## 7\. Test your understanding with GDB

```
gdb ./movabs
```



Inside GDB\:

```
break _start
run
display/i $rip
si
info registers rax rbx rcx
```



Execute instructions one by one and observe how the registers change.

---

## Key takeaway

## Remember these three instructions

```
mov rax, 100
```



Load a small immediate value.

---

```
movabs rax, 0x123456789ABCDEF0
```



Load a full 64-bit immediate value.

---

```
lea rax, [rip + offset]
```



Calculate an address relative to the instruction pointer.

**My recommendation\:** When studying your Rust x86-64 kernel, pay special attention to `movabs`, RIP-relative addressing, and ELF relocations. Together, they explain how the compiler and linker handle addresses, symbols, and memory locations.

For further reading: [GNU assembler documentation](https://fuchsia.googlesource.com/third_party/binutils-gdb/%2B/46d00b8af141a8ef29f4b9cd49ab70839b6e5ba8/gas/doc/c-i386.texi?utm_source=chatgpt.com) and [x86-64 System V ABI](https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/low-level-sys-info.tex?utm_source=chatgpt.com)\.

# upper half VS lower half

- In x86-64 assembly, **upper half** and **lower half** refer to different portions of a CPU register.

They do not mean upper memory and lower memory. They refer to the bits inside a register.

Let's look at the `RAX` register.

# 1\. Understanding the upper half and lower half

A 64-bit register contains 64 bits\:

```
RAX = 64 bits
```



We can divide it into two 32-bit halves\:

## 64-bit RAX register

# Upper half

## 32 bits

Bits 63–32

# Lower half

## 32 bits

Bits 31–0

Bit 63 Bit 0

Upper = more significant bits. Lower = less significant bits.

The register names are\:

| Register | Size | Portion |
|--------|--------|--------|
| `RAX` | 64-bit | Entire register |
| `EAX` | 32-bit | Lower 32 bits |
| `AX` | 16-bit | Lower 16 bits |
| `AH` | 8-bit | Upper 8 bits of AX |
| `AL` | 8-bit | Lower 8 bits of AX |

Notice that `EAX` is not the upper half. It represents the **lower half of RAX**\.

# 2\. What happens when you write to EAX?

This is an important special rule of x86-64.

Suppose initially\:

```
RAX = 0x123456789ABCDEF0
```



Now execute\:

```
mov eax, 0x11111111
```



The result is\:

```
Before:

RAX = 0x123456789ABCDEF0

After:

RAX = 0x0000000011111111
      └───┬───┘└───┬───┘
       Upper     Lower
        32        32
```



The upper 32 bits are automatically set to zero.

This behavior is called **zero-extension**\.

In other words\:

```
mov eax, 0x11111111
```



Effectively does\:

```
RAX = zero_extend_32_to_64(0x11111111)
```



You don't need to explicitly clear the upper half.

# 3\. What if you write to AX instead?

Consider\:

```
mov rax, 0x123456789ABCDEF0

mov ax, 0x1111
```



Result\:

```
RAX = 0x123456789ABC1111
```



Unlike writing to `EAX`, writing to `AX` does not clear the upper bits.

Similarly\:

```
mov al, 0x22
```



Changes only the lowest 8 bits.

```
Before:
RAX = 0x123456789ABCDEF0

After:
RAX = 0x123456789ABCDE22
```



# 4\. What about allocating to the upper half?

You mentioned allocating to the upper half versus allocating to the bottom.

The correct terminology is generally\:

- **Upper half\:** higher-order bits.
- **Lower half\:** lower-order bits.
- **Zero-extension\:** filling the newly added upper bits with zero.
- **Sign-extension\:** filling the newly added upper bits with copies of the sign bit.

For example\:

**Zero-extension**

```
32-bit:  00000000 11111111 11111111 11111111

64-bit:  00000000 00000000 00000000 00000000
         00000000 11111111 11111111 11111111
```



(Upper bits filled with 0)

---

**Sign-extension**

```
32-bit:  11111111 11111111 11111111 11111111

64-bit:  11111111 11111111 11111111 11111111
         11111111 11111111 11111111 11111111
```



(Upper bits filled with the sign bit)

Sign-extension preserves the signed numerical value when increasing its width.

For example\:

```
mov eax, -1
```



Because writing to `EAX` zeroes the upper half\:

```
RAX = 0x00000000FFFFFFFF
```



But\:

```
movsxd rax, eax
```



Sign-extends the 32-bit value\:

```
RAX = 0xFFFFFFFFFFFFFFFF
```



Both instructions produce different 64-bit results.

# 5\. Try it yourself in GDB

Compile this assembly\:

```
.intel_syntax noprefix

.global _start

.section .text

_start:
    movabs rax, 0x123456789ABCDEF0

    mov eax, 0x11111111

    movabs rax, 0x123456789ABCDEF0

    mov ax, 0x2222

    mov al, 0x33

    mov rax, 60
    xor rdi, rdi
    syscall

.section .note.GNU-stack,"",@progbits
```



Compile\:

```
as --64 -o main.o main.s
ld -o main main.o
gdb ./main
```



Inside GDB\:

```
break _start
run

display/x $rax

si
si
si
si
si
```



Watch how `RAX` changes after each instruction.

---

**The most important rule to remember\:**

| Instruction | What happens to upper bits of RAX? |
|--------|--------|
| `mov rax, ...` | Entire 64-bit register overwritten |
| `mov eax, ...` | Upper 32 bits become zero |
| `mov ax, ...` | Upper 48 bits unchanged |
| `mov al, ...` | Upper 56 bits unchanged |
| `movsxd rax, eax` | Upper 32 bits copy the sign bit |

There is no general concept of allocating data to the upper or lower half here. You are simply choosing which portion of the register an instruction modifies.

# `a01_mov_movabs/`

- The assembler is rejecting the operands in `src/main.asm`. Let me look at the file.

The source itself looks valid, so let me reproduce the error and check the file for hidden characters.

The file is pure ASCII and the source is valid x86-64 assembly. Something is off with `as` itself — let me check what binary it is and test a minimal case.

Found the root cause. GNU `as` defaults to **AT&T syntax**, but the file is written in **Intel syntax** (no `%` on registers, no `$` on immediates). In AT&T syntax `eax` isn't recognized as a register, hence "operand type mismatch" on every instruction. Let me check the justfile to confirm how it builds.

The justfile explains it: recipe `r` uses `nasm` (Intel syntax by default — works), but recipe `gdb` uses `as` (GAS), which defaults to AT&T syntax. Adding `.intel_syntax noprefix` to the source fixes GAS. Now I need to check whether that breaks the `nasm` recipe, and whether a command-line flag alone would do it.

Both assemblers reject this file as-is: `as` fails on syntax mode, and `nasm` fails on the GAS-style directives (`.global`, `.section`) — so the `r` recipe was broken too. The file is written in GAS style, so the coherent fix is GAS for both recipes. Let me check sibling exercises to match conventions.

Conventions confirmed: NASM files in this project use `global`/`section` without dots; this file uses GAS-style directives, so it's meant for `as`. Applying the fix: add `.intel_syntax noprefix` to the source, and switch the `r` recipe from `nasm` (which can't parse this file) to `as` as well.

Now verifying end-to-end — build, link, run, and a non-interactive gdb check:

Builds, links, runs (exit 0), and the disassembly shows every instruction encoded correctly, including both `movabs` with the full 64-bit immediate. Last check — the actual gdb flow in batch mode:

Fixed — `just gdb` now assembles, links, and debugs correctly.

**Root cause:** your `main.asm` is written in Intel syntax (no `%`/`$` prefixes), but GNU `as` defaults to AT&T syntax. In AT&T mode `rax` isn't recognized as a register, so every instruction failed with "operand type mismatch". The fix was one line at the top of [main.asm:1](/home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/06_Debugging_Training/003_operator_xor_mov_movabs_etc/a01_mov_movabs/src/main.asm#L1):

```asm
.intel_syntax noprefix
```

**Also fixed the `r` recipe:** it used `nasm`, which can never assemble this file — the file uses GAS-style directives (`.global`, `.section`, `.note.GNU-stack`) that NASM rejects, so `just r` was broken even before this. Since the file is GAS-flavored, I switched `r` to `as --64` in the [justfile](/home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/06_Debugging_Training/003_operator_xor_mov_movabs_etc/a01_mov_movabs/justfile), matching the `gdb` recipe. Both recipes now build the same source.

**Verified end-to-end:**
- `as` + `ld` succeed; the binary runs and exits 0.
- Disassembly shows correct encodings, including both 10-byte `movabs rax, 0x123456789ABCDEF0` instructions.
- In gdb, after `starti` + 5 steps, `rax = 0x123456789abc2233` — exactly what the exercise demonstrates: the full 64-bit immediate, then `mov eax` zeroing the top half, then the second `movabs` restoring it, then `mov ax, 0x2222` and `mov al, 0x33` overwriting only the low word/byte.

One harmless note: `ld` prints `warning: cannot find entry symbol _start` because your entry is named `main`. It still works (execution starts at `main`, the first symbol in `.text`). If you want to silence it, rename the label to `_start` or add `-e main` to the `ld` lines.
