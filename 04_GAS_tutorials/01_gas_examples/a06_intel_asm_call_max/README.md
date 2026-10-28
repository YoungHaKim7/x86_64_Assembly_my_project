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

# Ai fix

- Fixed — clippy passes with `-D warnings`, and `cargo run` still prints the correct `1 2 3 4 5 6`.

What was going on:

- **Root cause**: rustc's `global_asm!` assembles **Intel syntax by default** on x86-64, so the `.intel_syntax noprefix` at the top of `maxofthree.s` was redundant (it's only needed with plain GNU `as`, like the sibling crates' `options(att_syntax)` is needed for AT&T). The clean fix is dropping the directive rather than `#[allow]`ing the lint.
- **Why the earlier attempt didn't work**: the clippy error had been pasted into the `.s` file as comments, and line 1 of that paste contained the literal text `.intel_syntax`. The lint greps for that substring anywhere in the spliced-in file — comments included — so it kept firing. Same trap bit my first fix attempt; the comment now says "syntax-switch directive" instead of naming the directive.

Changes:
- `src/maxofthree.s` — removed the pasted error text and the commented-out directive; left a short comment noting Intel is the default under `global_asm!`.
- `src/main.rs:3-6` — corrected the stale comment (it claimed the file was AT&T and referenced `options(att_syntax)`, copy-pasted from an AT&T sibling crate).
