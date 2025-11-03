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
