# CPU Registers

<table border="1" cellspacing="0" cellpadding="6" style="border-collapse: collapse; text-align: center;">
  <tr style="background-color: #333; color: white;">
    <th></th>
    <th colspan="4">Accum.</th>
    <th colspan="4">Counter</th>
    <th colspan="4">Data</th>
    <th colspan="4">Base</th>
    <th colspan="4" style="background-color: #6b4ca0;">Stack<br>Pointer</th>
    <th colspan="4" style="background-color: #6b4ca0;">Stack Base<br>Pointer</th>
    <th colspan="4" >Source</th>
    <th colspan="4" >Dest.</th>
  </tr>
  <tr style="background-color: #222; color: white;">
    <td>64-bit</td>
    <td colspan="4">RAX</td>
    <td colspan="4">RCX</td>
    <td colspan="4">RDX</td>
    <td colspan="4">RBX</td>
    <td colspan="4" style="background-color: #6b4ca0;">RSP</td>
    <td colspan="4" style="background-color: #6b4ca0;">RBP</td>
    <td colspan="4" >RSI</td>
    <td colspan="4" >RDI</td>
  </tr>
  <tr style="background-color: #222; color: white;">
    <td>32-bit</td>
    <td></td>
    <td></td>
    <td colspan="2">E<br />A<br />X</td>
    <td></td>
    <td></td>
    <td colspan="2">E<br />C<br />X</td>
    <td></td>
    <td></td>
    <td colspan="2">E<br />D<br />X</td>
    <td></td>
    <td></td>
    <td colspan="2">E<br />B<br />X</td>
    <td></td>
    <td></td>
    <td colspan="2" style="background-color: #6b4ca0;">E<br />S<br />P</td>
    <td></td>
    <td></td>
    <td colspan="2" style="background-color: #6b4ca0;">E<br />B<br />P</td>
    <td></td>
    <td></td>
    <td colspan="2" >E<br />S<br />I</td>
    <td></td>
    <td></td>
    <td colspan="2" >E<br />D<br />I</td>
  </tr>
  <tr style="background-color: #222; color: white;">
    <td>16-bit</td>
    <td></td>
    <td></td>
    <td></td>
    <td>A<br />X</td>
    <td></td>
    <td></td>
    <td></td>
    <td>C<br />X</td>
    <td></td>
    <td></td>
    <td></td>
    <td>D<br />X</td>
    <td></td>
    <td></td>
    <td></td>
    <td>B<br />X</td>
    <td></td>
    <td></td>
    <td></td>
    <td style="background-color: #6b4ca0;">S<br />P</td>
    <td></td>
    <td></td>
    <td></td>
    <td style="background-color: #6b4ca0;">B<br />P</td>
    <td></td>
    <td></td>
    <td></td>
    <td>S<br />I</td>
    <td></td>
    <td></td>
    <td></td>
    <td>D<br />I</td>
  </tr>
</table>

- Accumulator : Used in arithmetic operations
- Counter : Used in loops and shift/rotate instructions
- Data : Used in arithmetic operations and I/O operations
- Stack Pointer : Points to top of stack
- Stack Base Pointer : Points to base of stack
- Source : Points to source in stream operations
- Destination : Points to destination in stream operations

# General Purpose Registers (GPRs) 
- A register is a collection of flip-flops. Single bit digital data is stored using flip-flops. By combining many flip-flops, the storage capacity can be extended to accommodate a huge number of bits. We must utilize an n-bit register with n flip flops if we wish to store an n-bit word.
  - General Purpose Registers (GPRs) are essential components within a CPU, serving as temporary storage locations for data that is actively being processed. Unlike special-purpose registers, which are dedicated to specific tasks, GPRs are versatile and can store a wide variety of data, including operands for arithmetic and logic operations, memory addresses, or intermediate results.
- 레지스터는 플립플롭의 모음입니다. 단일 비트 디지털 데이터는 플립플롭을 사용하여 저장됩니다. 여러 플립플롭을 결합하면 저장 용량을 확장하여 많은 비트를 수용할 수 있습니다. n비트 단어를 저장하려면 플립플롭이 n개인 n비트 레지스터를 사용해야 합니다.
  - 범용 레지스터(GPR)는 CPU 내에서 필수적인 구성 요소로, 활발하게 처리되고 있는 데이터의 임시 저장 위치 역할을 합니다. 특정 작업에 전념하는 특수 목적 레지스터와 달리 GPR은 다재다능하며 산술 및 논리 연산의 피연산자, 메모리 주소 또는 중간 결과를 포함한 다양한 데이터를 저장할 수 있습니다.
- https://www.geeksforgeeks.org/computer-organization-architecture/general-purpose-registers/

# Processor register
- https://en.wikipedia.org/wiki/Processor_register

# Buffer Overflow 101: Ep 1 - x86 Memory Fundamentals
- flipthebit
  - https://youtu.be/_D8eLCmlrS8?si=hzuV2rsC7zsd9WF0

Your table is mostly correct as a historical description of the x86 register family, but some descriptions are incomplete or misleading for modern x86-64.

The biggest issue is that names such as Accumulator, Counter, and Data describe the registers' historical purposes. In x86-64, most general-purpose registers can be used for many different purposes.

## 1. Register names and sizes

Your register mapping is correct:

| Historical name    | 64-bit | 32-bit | 16-bit | 8-bit   |
| ------------------ | ------ | ------ | ------ | ------- |
| Accumulator        | RAX    | EAX    | AX     | AL / AH |
| Counter            | RCX    | ECX    | CX     | CL / CH |
| Data               | RDX    | EDX    | DX     | DL / DH |
| Base               | RBX    | EBX    | BX     | BL / BH |
| Stack Pointer      | RSP    | ESP    | SP     | SPL     |
| Stack Base Pointer | RBP    | EBP    | BP     | BPL     |
| Source Index       | RSI    | ESI    | SI     | SIL     |
| Destination Index  | RDI    | EDI    | DI     | DIL     |

Important: The 8-bit registers `AH`, `BH`, `CH`, and `DH` are the upper halves of the 16-bit registers. They are not available in instructions that use a REX prefix. The newer registers `SPL`, `BPL`, `SIL`, and `DIL` are available in 64-bit mode.

Also, writing to a 32-bit register in 64-bit mode zero-extends its value into the corresponding 64-bit register:

```
mov eax, 0x12345678
```

Result:

```
RAX = 0x0000000012345678
       └──────┘└──────┘
       zero    EAX
```

Writing to a 16-bit or 8-bit register does not clear the upper bits.

## 2. Correct descriptions of the registers

Here are more accurate descriptions for your list.

| Register | Traditional purpose | Modern x86-64 usage                                                                   |
| -------- | ------------------- | ------------------------------------------------------------------------------------- |
| RAX      | Accumulator         | General-purpose; also used for arithmetic results, return values, and syscall numbers |
| RCX      | Counter             | General-purpose; used as a loop counter and shift count (`CL`)                        |
| RDX      | Data                | General-purpose; also used in multiplication, division, and I/O                       |
| RBX      | Base                | General-purpose; historically used as a base register                                 |
| RSP      | Stack Pointer       | Points to the current top of the stack                                                |
| RBP      | Stack Base Pointer  | Often used as a stack-frame base pointer, but can be a general-purpose register       |
| RSI      | Source Index        | General-purpose; source pointer for string instructions and an argument register      |
| RDI      | Destination Index   | General-purpose; destination pointer for string instructions and an argument register |

### Important corrections

RSP — Stack Pointer

Your description is correct, but the stack behavior is worth understanding:

```
push rax
```

Conceptually:

```
RSP = RSP - 8
[RSP] = RAX
```

And:

```
pop rax
```

Conceptually:

```
RAX = [RSP]
RSP = RSP + 8
```

In 64-bit mode, a normal `push` or `pop` of a general-purpose register uses 8 bytes.

RBP — Stack Base Pointer

It is commonly used as a frame pointer, but it is not required to be one.

For example:

```
push rbp
mov  rbp, rsp

; Function body

mov  rsp, rbp
pop  rbp
ret
```

Here, RBP provides a stable reference point for accessing local variables and function arguments.

However, modern compilers often omit the frame pointer and use RBP as a general-purpose register.

RSI and RDI — Source and Destination Index

These are particularly important for string instructions:

```
movsb
movsw
movsd
movsq
```

For example:

```
movsb
```

Copies one byte from the memory address in RSI to the memory address in RDI.

Conceptually:

```
[RDI] = [RSI]

RSI = RSI + 1
RDI = RDI + 1
```

The direction of the updates depends on the Direction Flag (DF).

## 3. An important missing detail: x86-64 calling convention

Your table describes traditional register roles, but it does not explain how modern programs use these registers when calling functions.

On Linux x86-64, the System V AMD64 ABI uses these registers for integer and pointer arguments:

| Argument     | Register |
| ------------ | -------- |
| 1st          | RDI      |
| 2nd          | RSI      |
| 3rd          | RDX      |
| 4th          | RCX      |
| 5th          | R8       |
| 6th          | R9       |
| Return value | RAX      |

For example, consider:

```
long add(long a, long b)
{
    return a + b;
}
```

A corresponding assembly implementation could be:

```
global add

section .text
add:
    mov rax, rdi
    add rax, rsi
    ret
```

Register layout:

```
             Function: add(a, b)

        RDI                 RSI
         │                   │
         ▼                   ▼
       ┌─────┐             ┌─────┐
       │  a  │             │  b  │
       └─────┘             └─────┘
           \                 /
            \               /
             ▼             ▼
              add rdi, rsi
                    │
                    ▼
                  RAX
               return value
```

This is why RSI and RDI are not exclusively source and destination registers.

Note: Windows x64 uses a different calling convention: RCX, RDX, R8, and R9 are the first four integer/pointer argument registers.

## 4. What is missing from your table?

Your table only shows the original eight general-purpose registers. Modern x86-64 has sixteen general-purpose registers:

| 64-bit | 32-bit | 16-bit | 8-bit |
| ------ | ------ | ------ | ----- |
| RAX    | EAX    | AX     | AL    |
| RBX    | EBX    | BX     | BL    |
| RCX    | ECX    | CX     | CL    |
| RDX    | EDX    | DX     | DL    |
| RSI    | ESI    | SI     | SIL   |
| RDI    | EDI    | DI     | DIL   |
| RBP    | EBP    | BP     | BPL   |
| RSP    | ESP    | SP     | SPL   |
| R8     | R8D    | R8W    | R8B   |
| R9     | R9D    | R9W    | R9B   |
| R10    | R10D   | R10W   | R10B  |
| R11    | R11D   | R11W   | R11B  |
| R12    | R12D   | R12W   | R12B  |
| R13    | R13D   | R13W   | R13B  |
| R14    | R14D   | R14W   | R14B  |
| R15    | R15D   | R15W   | R15B  |

## Final verdict

Your table's register names and size relationships are correct, but I recommend these changes:

1. Change Stack Base Pointer to Base Pointer (Frame Pointer).
2. Change Source to Source Index.
3. Change Dest. to Destination Index.
4. Explain that traditional register purposes are historical conventions, not restrictions.
5. Add the eight additional registers, R8–R15, to represent the complete x86-64 general-purpose register set.

The most important distinction to remember is:

RAX, RBX, RCX, and RDX are all general-purpose registers in x86-64. Their historical names describe common roles, not what they are exclusively allowed to do.
