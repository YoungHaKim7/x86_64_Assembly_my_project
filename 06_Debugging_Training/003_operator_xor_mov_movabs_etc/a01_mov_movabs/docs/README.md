```bash
(No debugging symbols found in ./target/main)
(gdb) b main
Breakpoint 1 at 0x401000
(gdb) r
Starting program: /home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/06_Debugging_Training/003_operator_xor_mov_movabs_etc/a01_mov_movabs/target/main

Breakpoint 1, 0x0000000000401000 in main ()
(gdb) display/i $rip
1: x/i $rip
=> 0x401000 <main>:     movabs $0x123456789abcdef0,%rax
(gdb) display/x $rax
2: /x $rax = 0x0
(gdb) display/x $rbx
3: /x $rbx = 0x0
(gdb) display/x $rcx
4: /x $rcx = 0x0
(gdb) display/x $rdx
5: /x $rdx = 0x0
(gdb) si
0x000000000040100a in main ()
1: x/i $rip
=> 0x40100a <main+10>:  mov    $0x11111111,%eax
2: /x $rax = 0x123456789abcdef0
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x000000000040100f in main ()
1: x/i $rip
=> 0x40100f <main+15>:  movabs $0x123456789abcdef0,%rax
2: /x $rax = 0x11111111
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x0000000000401019 in main ()
1: x/i $rip
=> 0x401019 <main+25>:  mov    $0x2222,%ax
2: /x $rax = 0x123456789abcdef0
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x000000000040101d in main ()
1: x/i $rip
=> 0x40101d <main+29>:  mov    $0x33,%al
2: /x $rax = 0x123456789abc2222
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x000000000040101f in main ()
1: x/i $rip
=> 0x40101f <main+31>:  mov    $0x3c,%rax
2: /x $rax = 0x123456789abc2233
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x0000000000401026 in main ()
1: x/i $rip
=> 0x401026 <main+38>:  xor    %rdi,%rdi
2: /x $rax = 0x3c
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
0x0000000000401029 in main ()
1: x/i $rip
=> 0x401029 <main+41>:  syscall
2: /x $rax = 0x3c
3: /x $rbx = 0x0
4: /x $rcx = 0x0
5: /x $rdx = 0x0
(gdb) si
[Inferior 1 (process 23493) exited normally]
(gdb) q
```
