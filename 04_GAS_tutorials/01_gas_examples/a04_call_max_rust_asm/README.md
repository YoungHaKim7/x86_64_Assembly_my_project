# Result

```bash
$ cargo run

1
2
3
4
5
6
```

## AI fix

The original `main.rs` used `std::arch::asm!("include_str!(../src/maxofthree.s)")`, which is invalid:
`asm!` cannot appear at module level, requires a string literal (not a macro call), and is for
inline asm inside a function — not for linking an external assembly file.

**Changes made:**

1. **src/main.rs** — replaced with the correct pattern:
   - `global_asm!(include_str!("maxofthree.s"), options(att_syntax))` assembles the GAS file into
     the crate (`global_asm!` is the module-level counterpart of `asm!`; `include_str!` splices the
     file in; `options(att_syntax)` because rustc's integrated assembler defaults to Intel syntax).
   - `unsafe extern "C" { fn maxofthree(x: i64, y: i64, z: i64) -> i64; }` declares the symbol
     (edition 2024 requires `unsafe extern`). Calls are inside `unsafe {}` since it's a foreign fn.

Note: an alternative would be a `build.rs` with the `cc` crate to assemble/link `maxofthree.s`
separately; `global_asm!` keeps the tutorial dependency-free.
