# Result


# AI fix

### Fixed! The issue was that `puts` returns the number of characters printed (12) in `%rax`, and this became the exit code. I added `xor %rax, %rax` before `ret` to explicitly return 0.

**Changes made:**

1. **justfile:36** - Fixed redundant `./` in the path (`{{target_dir}}/./a.out` → `{{target_dir}}/a.out`)

2. **src/main.S:17-18** - Added explicit zero return value and fixed string termination:
   - Changed `.ascii` to `.asciz` (proper null-terminated string)
   - Added `xor %rax, %rax` before `ret` (return 0 instead of puts' character count)

The program now runs successfully with exit code 0.


- ✓ **Fixed!** The warning is now gone.

**What I changed:**
Added the following directive at the end of your assembly file:
```assembly
.section .note.GNU-stack,"",@progbits
```

**Why this matters:**
- The `.note.GNU-stack` section tells the linker whether the program needs an executable stack
- By marking it as empty (`""`), we declare the stack as **non-executable**, which is the secure default
- This enables the NX (No-Execute) bit protection, preventing stack-based code execution attacks
- Modern linkers warn about missing this section because executable stacks are a security vulnerability

Your program now compiles cleanly and is more secure!
