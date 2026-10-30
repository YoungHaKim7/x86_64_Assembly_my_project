; -----------------------------------------------------------------------------
; Nested loops -- multiplication as repeated addition
;
; Demonstrates: outer/inner loop nesting with separate counters
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_150.lst ch07_150_nested_loops_mul.asm && ld -g -o ch07_150_nested_loops_mul ch07_150_nested_loops_mul.o
; Run:    ./ch07_150_nested_loops_mul ; echo $?        -> exit code: 42
;
; 7 * 6: add 7 to the accumulator six times.  The inner loop body is a
; plain increment, showing how loop overhead itself can be the product.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rbx, 7                     ; multiplicand
    mov     rcx, 6                     ; multiplier (outer count)
    xor     rax, rax                   ; accumulator = 0

outerLoop:
    mov     rdx, rbx                   ; inner counter = multiplicand
innerLoop:
    inc     rax                        ; accumulate one unit
    dec     rdx
    jnz     innerLoop                  ; add 7, one at a time
    dec     rcx
    jnz     outerLoop                  ; ...six times
    ; rax = 7 * 6 = 42

last:
    mov     rdi, rax                   ; exit status = 42
    mov     rax, SYS_exit
    syscall
