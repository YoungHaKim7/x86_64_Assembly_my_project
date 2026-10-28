# Result

```bash
1
2
3
4
5
6
```
# fix
Fixed and verified — clean build, correct output (`1 2 3 4 5 6`).

## Root cause

`CMakeLists.txt:10` declared `project(... LANGUAGES C)`. Without `ASM` in the languages list, CMake has no rule for `.s` files and silently drops `src/maxofthree.s` from the target — which is why ninja only compiled `main.c.o` and the link failed with `undefined reference to 'maxofthree'`.

## Changes

**`CMakeLists.txt`**
- `LANGUAGES C` → `LANGUAGES C ASM` — CMake now detects clang as the assembler and compiles/links `maxofthree.s`
- Removed `-lm` from `add_compile_options` (it's a linker flag and caused the `linker input unused` warning; it was already correctly in `target_link_options`)
- Scoped `-pedantic`, `-pedantic-errors`, `-Wall`, `-Wextra` to C only via `$<$<COMPILE_LANGUAGE:C>:...>` generator expressions, so they don't leak into ASM compiles

**`src/maxofthree.s`**
- Added `.section .note.GNU-stack,"",@progbits` (matching your other examples) — silences the `missing .note.GNU-stack section implies executable stack` linker warning

One note: the remaining `-MD/-MT/-MF` warnings on the ASM step are injected by CMake's own depfile handling when using clang as the assembler — they're benign and can't be removed via flags. The link and exec-stack warnings are gone.
