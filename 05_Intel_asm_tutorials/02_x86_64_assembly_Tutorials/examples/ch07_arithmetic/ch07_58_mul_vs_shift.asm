; -----------------------------------------------------------------------------
; Multiply vs shift: 7 * 8 by mul equals 7 shl 3 (both give 56)
;
; Demonstrates: multiplying by powers of two with shl as a faster substitute
;               for mul
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_58.lst ch07_58_mul_vs_shift.asm && ld -g -o ch07_58 ch07_58_mul_vs_shift.o
; Run:    ./ch07_58 ; echo $?        -> exit code: 56
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Method 1 -- an ordinary unsigned multiply by 8:
    mov     rax, 7                      ; rax = 7 (multiplicand)
    mov     rbx, 8                      ; rbx = 8 = 2^3 (multiplier)
    mul     rbx                         ; rax = 7 * 8 = 56

; Method 2 -- the same product by shifting left 3 bits (7 << 3 == 7 * 2^3).
; Shifting is the classic strength reduction for multiplies by powers of 2.
    mov     rcx, 7                      ; rcx = 7
    shl     rcx, 3                      ; rcx = 7 shl 3 = 56

; Both methods must agree: exit with the common value only if they match.
    mov     edi, EXIT_SUCCESS           ; status 0 if the results differ
    cmp     rax, rcx                    ; mul result vs shl result
    jne     last                        ; mismatch (never taken here)

    movzx   edi, al                     ; agree: exit with 56

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (56)
