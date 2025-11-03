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

# Buffer Overflow 101: Ep 1 - x86 Memory Fundamentals
- flipthebit
  - https://youtu.be/_D8eLCmlrS8?si=hzuV2rsC7zsd9WF0
