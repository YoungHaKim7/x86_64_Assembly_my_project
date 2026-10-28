- The segmentation fault happens because `_start` is not a normal function. The Linux kernel jumps directly to `_start`, so there is no return address on the stack. After `puts` prints the message, `ret` attempts to jump to an invalid address.

Since you're using Linux x86-64 AT&T assembly and `-nostartfiles`, you should terminate the process with the Linux `exit` syscall instead of using `ret`.

## 1. Fixed `src/main.asm`

```asm
        .global _start

        .section .text
_start:
        leaq    message(%rip), %rdi     # Argument 1: message
        call    puts@PLT                # puts(message)

        # Exit the process using Linux x86-64 syscall
        movl    $60, %eax               # SYS_exit = 60
        xorl    %edi, %edi              # Exit status = 0
        syscall                         # exit(0)

        .section .rodata
message:
        .asciz  "Hola, mundo"

        .section .note.GNU-stack,"",@progbits
```

## 2. Fixed `justfile`

```
set shell := ["bash", "-cu"]

r:
    rm -rf target
    mkdir -p target
    as --64 -o target/main.o src/main.asm
    gcc -no-pie -nostartfiles -o target/a01_hola target/main.o
    ./target/a01_hola
```

Run:

```
just r
```

Expected output:

```
Hola, mundo
```

The program should exit with status `0`.

## 3. How execution works

|Linux kernel<br /> Starts execution at `_start`<br />|
|-|
| ⬇ |
| `call puts@PLT`<br /> Prints `Hola, mundo`|
| ⬇ |
| `movl $60, %eax` <br /> Selects the Linux `exit` syscall|
| ⬇ |
|`syscall`<br /> Terminates the process with status 0|

### Important distinction

- `ret` returns to a caller using a return address on the stack.
- `syscall` invokes a Linux kernel service.
- `_start` has no ordinary caller, so it must not return.

One subtlety: `puts` is a libc function, so this program still uses the C library even though it omits the C runtime startup files. If you want a completely libc-free assembly program, use Linux `write` (syscall `1`) to print the message and `exit` (syscall `60`) to terminate.

<hr />

The segmentation fault occurs because you're linking with `-nostartfiles`, which removes the C runtime startup code. Your assembly calls `puts` successfully, but after `main` returns, there is no valid startup routine to return to. The linker warning confirms that `_start` is missing.

The simplest fix is to let GCC link the normal C runtime and keep your assembly function named `main`.

## 1. Fixed `src/main.asm`

Your AT&T syntax is already correct. Keep the assembly code and add `.section .note.GNU-stack` to mark the stack as non-executable.

```asm
        .global main

        .section .text
main:
        leaq    message(%rip), %rdi     # First argument: message
        call    puts@PLT                # puts(message)
        xorl    %eax, %eax              # Return 0 from main
        ret

        .section .rodata
message:
        .asciz  "Hola, mundo"

        .section .note.GNU-stack,"",@progbits
```

### Important changes

- `leaq message(%rip), %rdi`: uses RIP-relative addressing to obtain the string address.
- `call puts@PLT`: calls the C library function through the Procedure Linkage Table.
- `xorl %eax, %eax`: returns `0` from `main`, indicating success.
- `.section .rodata`: stores the string in read-only data.
- `.note.GNU-stack`: marks the object as not requiring an executable stack.

## 2. Fixed `justfile`

Remove `-nostartfiles` from the GCC command.

```justfile
set shell := ["bash", "-cu"]

r:
    rm -rf target
    mkdir -p target
    as --64 -o target/main.o src/main.asm
    gcc -no-pie target/main.o -o target/a01_hola
    ./target/a01_hola
```

## 3. Run it

```bash
just r
```

Expected output:

```
Hola, mundo
```

The program should exit with status `0`, without a segmentation fault.

## 4. Why your original program crashed

Your original command was:

```bash
gcc -no-pie -nostartfiles target/main.o -o target/a01_hola
```

- The normal execution flow is:

| C runtime startup (`_start`)|
|-|
| ⬇ |
|`main()`|
| ⬇ |
|`puts("Hola, mundo")`|
| ⬇ |
|`return 0`|
| ⬇ |
|C runtime exits the process|


With `-nostartfiles`, GCC omits the runtime startup code. The linker therefore reports that `_start` is missing, and the executable begins at a fallback address rather than through the normal C runtime. When `main` executes `ret`, it has no valid return address, causing the segmentation fault.

Alternative: If your goal is to write a true standalone assembly program without the C runtime, use `_start` as the entry point and terminate with the Linux `exit` syscall instead of returning from `main`.
