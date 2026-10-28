# Result


```bash
1
2
3
4
5
6

```


- Here is the Intel syntax equivalent of your AT&T assembly code for x86-64 Linux.

```asm
.intel_syntax noprefix

        .globl  maxofthree

        .text
maxofthree:
        mov     rax, rdi                # result (rax) initially holds x
        cmp     rax, rsi                # is x less than y?
        cmovl   rax, rsi                # if so, set result to y
        cmp     rax, rdx                # is max(x,y) less than z?
        cmovl   rax, rdx                # if so, set result to z
        ret                             # maximum is returned in rax

        # Mark stack as non-executable
        .section .note.GNU-stack,"",@progbits
```

## Key differences between AT&T and Intel syntax

| Operation        | AT&T syntax        | Intel syntax     |
| ---------------- | ------------------ | ---------------- |
| Move             | `mov %rdi, %rax`   | `mov rax, rdi`   |
| Compare          | `cmp %rsi, %rax`   | `cmp rax, rsi`   |
| Conditional move | `cmovl %rsi, %rax` | `cmovl rax, rsi` |
| Return           | `ret`              | `ret`            |

Remember these two rules:

- AT&T: `source, destination` — registers use `%`, and immediate values use `$`.
- Intel: `destination, source` — registers have no `%` prefix, and immediate values have no `$` prefix.

## How `maxofthree` works

Under the x86-64 System V calling convention (Linux):

| Register | Value                |
| -------- | -------------------- |
| `rdi`    | First argument, `x`  |
| `rsi`    | Second argument, `y` |
| `rdx`    | Third argument, `z`  |
| `rax`    | Return value         |

For example, if `x = 10`, `y = 25`, and `z = 15`:

1. `mov rax, rdi` — initialize the result to `10`.
2. `cmp rax, rsi` — compare `10` with `25`.
3. `cmovl rax, rsi` — since `10 < 25`, update the result to `25`.
4. `cmp rax, rdx` — compare `25` with `15`.
5. `cmovl rax, rdx` — since `25 < 15` is false, keep `25`.
6. `ret` — return `25` in `rax`.

Important: `cmovl` performs a signed comparison. This implementation is correct for signed 64-bit integers. If your inputs are unsigned integers, use `cmovb` instead.
