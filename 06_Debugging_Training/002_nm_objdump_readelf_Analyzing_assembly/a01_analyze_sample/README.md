
```bash
##
$ nm -n target/main
                 U _start
0000000000401000 T main
0000000000401019 T calculate
0000000000402000 d my_value
0000000000402008 B __bss_start
0000000000402008 b buffer
0000000000402008 D _edata
0000000000402048 B _end

##
$ nm -n -S target/main
                 U _start
0000000000401000 T main
0000000000401019 T calculate
0000000000402000 d my_value
0000000000402008 B __bss_start
0000000000402008 b buffer
0000000000402008 D _edata
0000000000402048 B _end

##
$ objdump -d -M intel target/main

target/main:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:       b8 0a 00 00 00          mov    eax,0xa
  401005:       bb 14 00 00 00          mov    ebx,0x14
  40100a:       e8 0a 00 00 00          call   401019 <calculate>
  40100f:       b8 3c 00 00 00          mov    eax,0x3c
  401014:       48 31 ff                xor    rdi,rdi
  401017:       0f 05                   syscall

0000000000401019 <calculate>:
  401019:       48 01 d8                add    rax,rbx
  40101c:       c3                      ret

## 
$ file ./target/main
./target/main: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped

##
$ readelf -hW target/main
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x401000
  Start of program headers:          64 (bytes into file)
  Start of section headers:          8560 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         3
  Size of section headers:           64 (bytes)
  Number of section headers:         7
  Section header string table index: 6

```

```bash
##
$ readelf -lW target/main

Elf file type is EXEC (Executable file)
Entry point 0x401000
There are 3 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x000000 0x0000000000400000 0x0000000000400000 0x0000e8 0x0000e8 R   0x1000
  LOAD           0x001000 0x0000000000401000 0x0000000000401000 0x00001d 0x00001d R E 0x1000
  LOAD           0x002000 0x0000000000402000 0x0000000000402000 0x000008 0x000048 RW  0x1000

 Section to Segment mapping:
  Segment Sections...
   00
   01     .text
   02     .data .bss

##
$ readelf -SW target/main
There are 7 section headers, starting at offset 0x2170:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000401000 001000 00001d 00  AX  0   0 16
  [ 2] .data             PROGBITS        0000000000402000 002000 000008 00  WA  0   0  4
  [ 3] .bss              NOBITS          0000000000402008 002008 000040 00  WA  0   0  4
  [ 4] .symtab           SYMTAB          0000000000000000 002008 0000f0 18      5   4  8
  [ 5] .strtab           STRTAB          0000000000000000 0020f8 000045 00      0   0  1
  [ 6] .shstrtab         STRTAB          0000000000000000 00213d 00002c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

##
$ readelf -rW target/main

There are no relocations in this file.

##
$ eza -la -TL3
drwxrwxr-x    - gygy 31 Oct 23:28 .
.rw-rw-r--  394 gygy 31 Oct 23:20 ├── .asm-lsp.toml
.rw-rw-r--    8 gygy 31 Oct 23:20 ├── .gitignore
.rw-rw-r--  257 gygy 31 Oct 23:26 ├── justfile
.rw-rw-r--  736 gygy 31 Oct 23:28 ├── README.md
drwxrwxr-x    - gygy 31 Oct 23:24 ├── src
.rw-rw-r--  318 gygy 31 Oct 23:24 │   └── main.asm
drwxrwxr-x    - gygy 31 Oct 23:28 └── target
.rwxrwxr-x 9.0k gygy 31 Oct 23:28     ├── main
.rw-rw-r--  880 gygy 31 Oct 23:28     └── main.o

##
$ nm -n target/main
                 U _start
0000000000401000 T main
0000000000401019 T calculate
0000000000402000 d my_value
0000000000402008 B __bss_start
0000000000402008 b buffer
0000000000402008 D _edata
0000000000402048 B _end

##
$ nm -n -S target/main
                 U _start
0000000000401000 T main
0000000000401019 T calculate
0000000000402000 d my_value
0000000000402008 B __bss_start
0000000000402008 b buffer
0000000000402008 D _edata
0000000000402048 B _end

##
$ nm -C target/main
0000000000402008 B __bss_start
0000000000402008 b buffer
0000000000401019 T calculate
0000000000402008 D _edata
0000000000402048 B _end
0000000000401000 T main
0000000000402000 d my_value
                 U _start

##
$ nm -u target/main.o

##
$ nm -g target/main
0000000000402008 B __bss_start
0000000000401019 T calculate
0000000000402008 D _edata
0000000000402048 B _end
0000000000401000 T main
                 U _start

##
$ nm -D target/main
nm: target/main: no symbols

##
$ objdump -d -M intel target/main

target/main:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:       b8 0a 00 00 00          mov    eax,0xa
  401005:       bb 14 00 00 00          mov    ebx,0x14
  40100a:       e8 0a 00 00 00          call   401019 <calculate>
  40100f:       b8 3c 00 00 00          mov    eax,0x3c
  401014:       48 31 ff                xor    rdi,rdi
  401017:       0f 05                   syscall

0000000000401019 <calculate>:
  401019:       48 01 d8                add    rax,rbx
  40101c:       c3                      ret

##
$ objdump -D -M intel target/main

target/main:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:       b8 0a 00 00 00          mov    eax,0xa
  401005:       bb 14 00 00 00          mov    ebx,0x14
  40100a:       e8 0a 00 00 00          call   401019 <calculate>
  40100f:       b8 3c 00 00 00          mov    eax,0x3c
  401014:       48 31 ff                xor    rdi,rdi
  401017:       0f 05                   syscall

0000000000401019 <calculate>:
  401019:       48 01 d8                add    rax,rbx
  40101c:       c3                      ret

Disassembly of section .data:

0000000000402000 <my_value>:
  402000:       39 30                   cmp    DWORD PTR [rax],esi
  402002:       00 00                   add    BYTE PTR [rax],al
  402004:       00 00                   add    BYTE PTR [rax],al
        ...

##
$ objdump -h intel target/main
objdump: 'intel': No such file

target/main:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000001d  0000000000401000  0000000000401000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000008  0000000000402000  0000000000402000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000040  0000000000402008  0000000000402008  00002008  2**2
                  ALLOC

##
$ objdump -h target/main

target/main:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000001d  0000000000401000  0000000000401000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000008  0000000000402000  0000000000402000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000040  0000000000402008  0000000000402008  00002008  2**2
                  ALLOC

##
$ objdump -t target/main

target/main:     file format elf64-x86-64

SYMBOL TABLE:
0000000000000000 l    df *ABS*  0000000000000000 src/main.asm
0000000000402000 l       .data  0000000000000000 my_value
0000000000402008 l       .bss   0000000000000000 buffer
0000000000401019 g       .text  0000000000000000 calculate
0000000000000000         *UND*  0000000000000000 _start
0000000000402008 g       .bss   0000000000000000 __bss_start
0000000000401000 g       .text  0000000000000000 main
0000000000402008 g       .data  0000000000000000 _edata
0000000000402048 g       .bss   0000000000000000 _end



##
$ objdump -r target/main.o

target/main.o:     file format elf64-x86-64


###
$ objdump -s target/main

target/main:     file format elf64-x86-64

Contents of section .text:
 401000 b80a0000 00bb1400 0000e80a 000000b8  ................
 401010 3c000000 4831ff0f 054801d8 c3        <...H1...H...
Contents of section .data:
 402000 39300000 00000000                    90......

06_Debugging_Training/002_nm_objdump_readelf_Analyzing_assembly/a01_analyze_sample on  main [?]
❯ objdump -s target/main

target/main:     file format elf64-x86-64

Contents of section .text:
 401000 b80a0000 00bb1400 0000e80a 000000b8  ................
 401010 3c000000 4831ff0f 054801d8 c3        <...H1...H...
Contents of section .data:
 402000 39300000 00000000                    90......

##
$ objdump -S -M intel target/main

target/main:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:       b8 0a 00 00 00          mov    eax,0xa
  401005:       bb 14 00 00 00          mov    ebx,0x14
  40100a:       e8 0a 00 00 00          call   401019 <calculate>
  40100f:       b8 3c 00 00 00          mov    eax,0x3c
  401014:       48 31 ff                xor    rdi,rdi
  401017:       0f 05                   syscall

0000000000401019 <calculate>:
  401019:       48 01 d8                add    rax,rbx
  40101c:       c3                      ret

##
$ objdump -f target/main

target/main:     file format elf64-x86-64
architecture: i386:x86-64, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x0000000000401000


##
$ readelf -hW target/main
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x401000
  Start of program headers:          64 (bytes into file)
  Start of section headers:          8560 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         3
  Size of section headers:           64 (bytes)
  Number of section headers:         7
  Section header string table index: 6
```

```bash
##
$ readelf -SW target/main
There are 7 section headers, starting at offset 0x2170:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000401000 001000 00001d 00  AX  0   0 16
  [ 2] .data             PROGBITS        0000000000402000 002000 000008 00  WA  0   0  4
  [ 3] .bss              NOBITS          0000000000402008 002008 000040 00  WA  0   0  4
  [ 4] .symtab           SYMTAB          0000000000000000 002008 0000f0 18      5   4  8
  [ 5] .strtab           STRTAB          0000000000000000 0020f8 000045 00      0   0  1
  [ 6] .shstrtab         STRTAB          0000000000000000 00213d 00002c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

##
$ readelf -lW target/main

Elf file type is EXEC (Executable file)
Entry point 0x401000
There are 3 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x000000 0x0000000000400000 0x0000000000400000 0x0000e8 0x0000e8 R   0x1000
  LOAD           0x001000 0x0000000000401000 0x0000000000401000 0x00001d 0x00001d R E 0x1000
  LOAD           0x002000 0x0000000000402000 0x0000000000402000 0x000008 0x000048 RW  0x1000

 Section to Segment mapping:
  Segment Sections...
   00
   01     .text
   02     .data .bss

##
$ readelf -SW target/main
There are 7 section headers, starting at offset 0x2170:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000401000 001000 00001d 00  AX  0   0 16
  [ 2] .data             PROGBITS        0000000000402000 002000 000008 00  WA  0   0  4
  [ 3] .bss              NOBITS          0000000000402008 002008 000040 00  WA  0   0  4
  [ 4] .symtab           SYMTAB          0000000000000000 002008 0000f0 18      5   4  8
  [ 5] .strtab           STRTAB          0000000000000000 0020f8 000045 00      0   0  1
  [ 6] .shstrtab         STRTAB          0000000000000000 00213d 00002c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

##
$ readelf -rW target/main

There are no relocations in this file.

##
$ readelf -dW target/main

There is no dynamic section in this file.

##
$ readelf -rW target/main.o

There are no relocations in this file.

##
$ readelf -n target/main

##
$ readelf -aW target/main

ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x401000
  Start of program headers:          64 (bytes into file)
  Start of section headers:          8560 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         3
  Size of section headers:           64 (bytes)
  Number of section headers:         7
  Section header string table index: 6

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000401000 001000 00001d 00  AX  0   0 16
  [ 2] .data             PROGBITS        0000000000402000 002000 000008 00  WA  0   0  4
  [ 3] .bss              NOBITS          0000000000402008 002008 000040 00  WA  0   0  4
  [ 4] .symtab           SYMTAB          0000000000000000 002008 0000f0 18      5   4  8
  [ 5] .strtab           STRTAB          0000000000000000 0020f8 000045 00      0   0  1
  [ 6] .shstrtab         STRTAB          0000000000000000 00213d 00002c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x000000 0x0000000000400000 0x0000000000400000 0x0000e8 0x0000e8 R   0x1000
  LOAD           0x001000 0x0000000000401000 0x0000000000401000 0x00001d 0x00001d R E 0x1000
  LOAD           0x002000 0x0000000000402000 0x0000000000402000 0x000008 0x000048 RW  0x1000

 Section to Segment mapping:
  Segment Sections...
   00
   01     .text
   02     .data .bss

There is no dynamic section in this file.

There are no relocations in this file.
No processor specific unwind information to decode

Symbol table '.symtab' contains 10 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS src/main.asm
     2: 0000000000402000     0 NOTYPE  LOCAL  DEFAULT    2 my_value
     3: 0000000000402008     0 NOTYPE  LOCAL  DEFAULT    3 buffer
     4: 0000000000401019     0 NOTYPE  GLOBAL DEFAULT    1 calculate
     5: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _start
     6: 0000000000402008     0 NOTYPE  GLOBAL DEFAULT    3 __bss_start
     7: 0000000000401000     0 NOTYPE  GLOBAL DEFAULT    1 main
     8: 0000000000402008     0 NOTYPE  GLOBAL DEFAULT    2 _edata
     9: 0000000000402048     0 NOTYPE  GLOBAL DEFAULT    3 _end

No version information found in this file.

There is no GOT section in this file.
```

# ai

- Fixed. The linker warning is gone — the build is now clean.

**What was wrong:** It wasn't a build error, just a linker warning: NASM object files don't emit a `.note.GNU-stack` section by default, so `ld` assumes the code wants an **executable stack** (a security hazard, and deprecated behavior that will become an error in future linker versions).

**The fix** (`src/main.asm:53-55`): added

```nasm
section .note.GNU-stack noalloc noexec nowrite progbits
```

This tells the linker the stack doesn't need execute permission, silencing the warning. The alternative would be adding `-z noexecstack` to the `gcc` link line in the justfile, but putting it in the source is the conventional fix since it travels with the file.
