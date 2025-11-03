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
    <td colspan="2">EAX</td>
    <td></td>
    <td></td>
    <td colspan="2">ECX</td>
    <td></td>
    <td></td>
    <td colspan="2">EDX</td>
    <td></td>
    <td></td>
    <td colspan="2">EBX</td>
    <td></td>
    <td></td>
    <td colspan="2" style="background-color: #6b4ca0;">ESP</td>
    <td></td>
    <td></td>
    <td colspan="2" style="background-color: #6b4ca0;">EBP</td>
    <td></td>
    <td></td>
    <td colspan="2" >ESI</td>
    <td></td>
    <td></td>
    <td colspan="2" >EDI</td>
  </tr>
  <tr style="background-color: #222; color: white;">
    <td>16-bit</td>
    <td></td>
    <td></td>
    <td></td>
    <td>AX</td>
    <td></td>
    <td></td>
    <td></td>
    <td>CX</td>
    <td></td>
    <td></td>
    <td></td>
    <td>DX</td>
    <td></td>
    <td></td>
    <td></td>
    <td>BX</td>
    <td></td>
    <td></td>
    <td></td>
    <td style="background-color: #6b4ca0;">SP</td>
    <td></td>
    <td></td>
    <td></td>
    <td style="background-color: #6b4ca0;">BP</td>
    <td></td>
    <td></td>
    <td></td>
    <td>SI</td>
    <td></td>
    <td></td>
    <td></td>
    <td>DI</td>
  </tr>
</table>

- Accumulator : Used in arithmetic operations
- Counter : Used in loops and shift/rotate instructions
- Data : Used in arithmetic operations and I/O operations
- Stack Pointer : Points to top of stack
- Stack Base Pointer : Points to base of stack
- Source : Points to source in stream operations
- Destination : Points to destination in stream operations

# Buffer Overflow 101: Ep 1 - x86 Memory Fundamentals
- flipthebit
  - https://youtu.be/_D8eLCmlrS8?si=hzuV2rsC7zsd9WF0
