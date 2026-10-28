# debugging

```gdb
Reading symbols from ./target/01_sample_debugging...
(gdb) b main
Breakpoint 1 at 0x401160: file src/main.asm, line 15.
(gdb) r
Starting program: /home/gy/my_projects/Rust_Lang/x86_64_Assembly_my_project/05_Intel_asm_tutorials/01_sample_debugging/target/01_sample_debugging

This GDB supports auto-downloading debuginfo from the following URLs:
  <https://debuginfod.opensuse.org/>
Enable debuginfod for this session? (y or [n]) y
Debuginfod has been enabled.
To make this setting permanent, add 'set debuginfod enabled on' to .gdbinit.
Downloading separate debug info for /lib64/ld-linux-x86-64.so.2
Downloading 6.63 M separate debug info for /lib64/libc.so.6
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

Breakpoint 1, main () at src/main.asm:15
15          push rbx                  ; Save rbx (callee-saved register)
(gdb) list
10      section .data
11          format: db "%ld", 10, 0    ; "%ld\n" format string for printf
12
13      section .text
14      main:
15          push rbx                  ; Save rbx (callee-saved register)
16          push r12                  ; Save r12
17          push r13                  ; Save r13
18
19          mov rcx, 90               ; Loop counter for 90 Fibonacci numbers
(gdb) $pc
Undefined command: "$pc".  Try "help".
(gdb) display/i $pc
1: x/i $pc
=> 0x401160 <main>:     push   %rbx
(gdb) display/d $rax
2: /d $rax = 140737352112168
(gdb) display/d $rbx
3: /d $rbx = 0
(gdb) display/d $rcx
4: /d $rcx = 4210160
(gdb) display/d $rdx
5: /d $rdx = 140737488347272
(gdb) nexti
main () at src/main.asm:16
16          push r12                  ; Save r12
1: x/i $pc
=> 0x401161 <main+1>:   push   %r12
2: /d $rax = 140737352112168
3: /d $rbx = 0
4: /d $rcx = 4210160
5: /d $rdx = 140737488347272
(gdb) nexti
main () at src/main.asm:17
17          push r13                  ; Save r13
1: x/i $pc
=> 0x401163 <main+3>:   push   %r13
2: /d $rax = 140737352112168
3: /d $rbx = 0
4: /d $rcx = 4210160
5: /d $rdx = 140737488347272
(gdb) nexti
main () at src/main.asm:19
19          mov rcx, 90               ; Loop counter for 90 Fibonacci numbers
1: x/i $pc
=> 0x401165 <main+5>:   mov    $0x5a,%ecx
2: /d $rax = 140737352112168
3: /d $rbx = 0
4: /d $rcx = 4210160
5: /d $rdx = 140737488347272
(gdb) nexti
20          xor rax, rax              ; rax = F(n-2) = 0
1: x/i $pc
=> 0x40116a <main+10>:  xor    %rax,%rax
2: /d $rax = 140737352112168
3: /d $rbx = 0
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) nexti
21          xor rbx, rbx              ; rbx = F(n-1) = 0
1: x/i $pc
=> 0x40116d <main+13>:  xor    %rbx,%rbx
2: /d $rax = 0
3: /d $rbx = 0
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) info registers
rax            0x0                 0
rbx            0x0                 0
rcx            0x5a                90
rdx            0x7fffffffe088      140737488347272
rsi            0x7fffffffe078      140737488347256
rdi            0x1                 1
rbp            0x7fffffffe078      0x7fffffffe078
rsp            0x7fffffffdf40      0x7fffffffdf40
r8             0x7ffff7e036c0      140737352054464
r9             0x7ffff7e0b9e0      140737352088032
r10            0x7fffffffdcb0      140737488346288
r11            0x7ffff7ffca90      140737354123920
r12            0x1                 1
r13            0x7ffff7ffd000      140737354125312
r14            0x7fffffffe088      140737488347272
r15            0x403df0            4210160
rip            0x40116d            0x40116d <main+13>
eflags         0x246               [ PF ZF IF ]
cs             0x33                51
ss             0x2b                43
ds             0x0                 0
es             0x0                 0
fs             0x0                 0
gs             0x0                 0
fs_base        0x7ffff7f8a780      140737353656192
gs_base        0x0                 0
(gdb) n
22          inc rbx                   ; rbx = 1 (first Fibonacci number)
1: x/i $pc
=> 0x401170 <main+16>:  inc    %rbx
2: /d $rax = 0
3: /d $rbx = 0
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
print_loop () at src/main.asm:26
26          push rax                  ; Save current rax
1: x/i $pc
=> 0x401173 <print_loop>:       push   %rax
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
print_loop () at src/main.asm:27
27          push rcx                  ; Save rcx (caller-saved)
1: x/i $pc
=> 0x401174 <print_loop+1>:     push   %rcx
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
print_loop () at src/main.asm:29
29          mov rdi, format           ; 1st argument for printf: format string
1: x/i $pc
=> 0x401175 <print_loop+2>:     movabs $0x404018,%rdi
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
30          mov rsi, rax              ; 2nd argument for printf: value to print
1: x/i $pc
=> 0x40117f <print_loop+12>:    mov    %rax,%rsi
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
31          xor rax, rax              ; Clear rax for varargs (printf uses 0 vector registers)
1: x/i $pc
=> 0x401182 <print_loop+15>:    xor    %rax,%rax
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
32          call printf
1: x/i $pc
=> 0x401185 <print_loop+18>:    call   0x401030 <printf@plt>
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 140737488347272
(gdb) n
0
34          pop rcx                   ; Restore rcx
1: x/i $pc
=> 0x40118a <print_loop+23>:    pop    %rcx
2: /d $rax = 2
3: /d $rbx = 1
4: /d $rcx = 0
5: /d $rdx = 0
(gdb) n
print_loop () at src/main.asm:35
35          pop rax                   ; Restore rax
1: x/i $pc
=> 0x40118b <print_loop+24>:    pop    %rax
2: /d $rax = 2
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 0
(gdb) n
print_loop () at src/main.asm:39
39          mov rdx, rbx              ; rdx = F(n-1)
1: x/i $pc
=> 0x40118c <print_loop+25>:    mov    %rbx,%rdx
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 0
(gdb) n
40          add rdx, rax              ; rdx = F(n-1) + F(n-2)
1: x/i $pc
=> 0x40118f <print_loop+28>:    add    %rax,%rdx
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 1
(gdb) n
41          mov rax, rbx              ; Shift F(n-1) into rax
1: x/i $pc
=> 0x401192 <print_loop+31>:    mov    %rbx,%rax
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 1
(gdb) n
42          mov rbx, rdx              ; Shift new sum into rbx
1: x/i $pc
=> 0x401195 <print_loop+34>:    mov    %rdx,%rbx
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 1
(gdb) n
44          dec rcx                   ; Decrement counter
1: x/i $pc
=> 0x401198 <print_loop+37>:    dec    %rcx
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 90
5: /d $rdx = 1
(gdb) n
45          jnz print_loop            ; Repeat until rcx reaches 0
1: x/i $pc
=> 0x40119b <print_loop+40>:    jne    0x401173 <print_loop>
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
26          push rax                  ; Save current rax
1: x/i $pc
=> 0x401173 <print_loop>:       push   %rax
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
print_loop () at src/main.asm:27
27          push rcx                  ; Save rcx (caller-saved)
1: x/i $pc
=> 0x401174 <print_loop+1>:     push   %rcx
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
print_loop () at src/main.asm:29
29          mov rdi, format           ; 1st argument for printf: format string
1: x/i $pc
=> 0x401175 <print_loop+2>:     movabs $0x404018,%rdi
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
30          mov rsi, rax              ; 2nd argument for printf: value to print
1: x/i $pc
=> 0x40117f <print_loop+12>:    mov    %rax,%rsi
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
31          xor rax, rax              ; Clear rax for varargs (printf uses 0 vector registers)
1: x/i $pc
=> 0x401182 <print_loop+15>:    xor    %rax,%rax
2: /d $rax = 1
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
32          call printf
1: x/i $pc
=> 0x401185 <print_loop+18>:    call   0x401030 <printf@plt>
2: /d $rax = 0
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 1
(gdb) n
1
34          pop rcx                   ; Restore rcx
1: x/i $pc
=> 0x40118a <print_loop+23>:    pop    %rcx
2: /d $rax = 2
3: /d $rbx = 1
4: /d $rcx = 0
5: /d $rdx = 0
(gdb) n
print_loop () at src/main.asm:35
35          pop rax                   ; Restore rax
1: x/i $pc
=> 0x40118b <print_loop+24>:    pop    %rax
2: /d $rax = 2
3: /d $rbx = 1
4: /d $rcx = 89
5: /d $rdx = 0
(gdb) q
A debugging session is active.

        Inferior 1 [process 54930] will be killed.

Quit anyway? (y or n) y
```

# ai

- The key idea is that `rax = 0` is an initialization instruction, not a calculation. The program puts the number `0` into a CPU register, puts `1` into another register, and then uses `add` and `mov` to generate the Fibonacci sequence.

Let's walk through it as if we're debugging the assembly directly in a Linux terminal.

## 1. Initialize the CPU registers

Your code:

```
mov rcx, 90
xor rax, rax
xor rbx, rbx
inc rbx
```

What happens inside the CPU?

```
Instruction          Register state
──────────────────────────────────────
mov rcx, 90           rcx = 90
xor rax, rax          rax = 0
xor rbx, rbx          rbx = 0
inc rbx               rbx = 1
```

Why does `xor rax, rax` make `rax` zero?

XOR compares each bit. When both inputs have the same bit, the result is zero.

```
rax before:  1010 1100
rax itself:  1010 1100
             ---------
XOR result:  0000 0000
```

The register is now zero. No Fibonacci calculation has happened yet.

Likewise, `inc rbx` increments the value in `rbx` from `0` to `1`.

After initialization:

```
┌────────────────────────────────────┐
│          CPU REGISTERS             │
├──────────┬─────────────────────────┤
│ rax      │ 0                       │
│ rbx      │ 1                       │
│ rcx      │ 90                      │
└──────────┴─────────────────────────┘

rax = previous Fibonacci value (0)
rbx = current Fibonacci value  (1)
rcx = loop counter              (90)
```

## 2. Watch the first iteration

Your loop begins by printing `rax`, then calculating the next Fibonacci number.

The important instructions are:

```
mov rdx, rbx
add rdx, rax
mov rax, rbx
mov rbx, rdx
```

Let's execute these one by one.

### Before the first iteration

```
rax = 0
rbx = 1
rdx = undefined / previous value
```

The program prints `rax`, so the first output is `0`.

### Instruction 1: `mov rdx, rbx`

```
mov rdx, rbx
```

Copy the value of `rbx` into `rdx`.

```
rax = 0
rbx = 1
rdx = 1
```

`mov` copies a value. It does not remove the original value from `rbx`.

### Instruction 2: `add rdx, rax`

```
add rdx, rax
```

This adds `rax` to `rdx`.

```
rdx = rdx + rax
rdx = 1 + 0
rdx = 1
```

Now the CPU has calculated the next Fibonacci value.

### Instruction 3: `mov rax, rbx`

```
mov rax, rbx
```

Move the current value into the previous-value register.

```
rax = 1
rbx = 1
rdx = 1
```

### Instruction 4: `mov rbx, rdx`

```
mov rbx, rdx
```

Store the newly calculated value in `rbx`.

```
rax = 1
rbx = 1
rdx = 1
```

The register values are now ready for the next iteration.

## 3. See the entire process in a terminal-style trace

This table shows the values immediately before each number is printed, followed by the addition and register updates.

```
$ ./fib90

Iteration   rax (printed)   rbx     Calculation
────────────────────────────────────────────────
    1           0            1      0 + 1 = 1
    2           1            1      1 + 1 = 2
    3           1            2      1 + 2 = 3
    4           2            3      2 + 3 = 5
    5           3            5      3 + 5 = 8
    6           5            8      5 + 8 = 13
    7           8           13      8 + 13 = 21
    8          13           21     13 + 21 = 34
    9          21           34     21 + 34 = 55
   10          34           55     34 + 55 = 89
```

The actual output starts like this:

```
0
1
1
2
3
5
8
13
21
34
55
89
144
233
377
...
```

Notice the distinction: the program prints `rax` before it computes the next value.

## 4. Why are `mov` and `add` enough?

The Fibonacci sequence follows this rule:

\\[ F(n)=F(n-1)+F(n-2) \\]

You only need to remember the previous two values.

Think of the registers as three temporary storage boxes:

```
          BEFORE ADDITION

      ┌─────────────┐
      │ rax = 3     │  Previous value
      └─────────────┘
             +
      ┌─────────────┐
      │ rbx = 5     │  Current value
      └─────────────┘
             │
             ▼
      ┌─────────────┐
      │ rdx = 8     │  New value
      └─────────────┘
```

Then shift the values:

```
rax ← rbx     3 → 5
rbx ← rdx     5 → 8
```

The next iteration therefore starts with `rax = 5` and `rbx = 8`.

No special Fibonacci instruction is needed. Ordinary register moves and integer addition implement the mathematical rule.

## 5. Debug the actual assembly with GDB

If you want to see the real CPU registers change on your machine, use GDB.

First, assemble and link your NASM program with debug symbols:

```
nasm -f elf64 -g -F dwarf fib.asm -o fib.o
gcc -g -no-pie fib.o -o fib90
gdb ./fib90
```

Inside GDB, enter:

```
break main
run
display/i $pc
display/d $rax
display/d $rbx
display/d $rcx
display/d $rdx
```

Now step through the instructions:

```
nexti
nexti
nexti
nexti
```

GDB executes one machine instruction at a time and displays the register values. To inspect all general-purpose registers, use:

```
info registers
```

One important detail: your program calls `printf`, so some registers may change during the function call. Your code saves and restores `rax` and `rcx` around that call, which is why the Fibonacci state remains intact.

In summary, `rax` starts at zero because `xor rax, rax` explicitly initializes it. The Fibonacci sequence begins only after the loop executes `add rdx, rax`, and the `mov` instructions shift the values into place for the next iteration.

# Result

```bash
0
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
1597
2584
4181
6765
10946
17711
28657
46368
75025
121393
196418
317811
514229
832040
1346269
2178309
3524578
5702887
9227465
14930352
24157817
39088169
63245986
102334155
165580141
267914296
433494437
701408733
1134903170
1836311903
2971215073
4807526976
7778742049
12586269025
20365011074
32951280099
53316291173
86267571272
139583862445
225851433717
365435296162
591286729879
956722026041
1548008755920
2504730781961
4052739537881
6557470319842
10610209857723
17167680177565
27777890035288
44945570212853
72723460248141
117669030460994
190392490709135
308061521170129
498454011879264
806515533049393
1304969544928657
2111485077978050
3416454622906707
5527939700884757
8944394323791464
14472334024676221
23416728348467685
37889062373143906
61305790721611591
99194853094755497
160500643816367088
259695496911122585
420196140727489673
679891637638612258
1100087778366101931
1779979416004714189
```

# `inc`
The `inc` instruction in x86-64 Intel assembly means increment by 1. It adds `1` to the destination operand.

## 1. Basic example

```
.intel_syntax noprefix

mov rbx, 0    # rbx = 0
inc rbx       # rbx = rbx + 1
```

Terminal-style execution:

```
$ gdb ./example

Before inc:
rbx = 0
Binary: 0000 0000

Instruction:
inc rbx

After inc:
rbx = 1
Binary: 0000 0001
```

## 2. How `inc` works in your Fibonacci program

Your initialization code is:

```
xor rax, rax    # rax = 0
xor rbx, rbx    # rbx = 0
inc rbx         # rbx = 1
```

The CPU executes each instruction in order:

```
Instruction       rax       rbx
─────────────────────────────────
xor rax, rax        0         ?
xor rbx, rbx        0         0
inc rbx             0         1
```

After initialization:

```
rax = 0    # First Fibonacci number to print
rbx = 1    # Next Fibonacci value
rcx = 90   # Number of iterations
```

The `inc rbx` instruction establishes the initial value `1`, allowing the program to generate the Fibonacci sequence:

```
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
```

## 3. `inc` versus `add`

| Instruction    | Meaning                      | Example           |
| -------------- | ---------------------------- | ----------------- |
| `inc rbx`      | Add 1                        | `rbx = rbx + 1`   |
| `add rbx, 1`   | Add 1                        | `rbx = rbx + 1`   |
| `add rbx, rax` | Add another register's value | `rbx = rbx + rax` |

One technical difference: `inc` updates arithmetic flags except the carry flag (`CF`), while `add` updates the carry flag too.

In short: `inc rbx` is a convenient way to set `rbx` to `1` after clearing it to `0`.




