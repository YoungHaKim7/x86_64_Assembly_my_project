; -----------------------------------------------------------------------------
; TEST a register against itself: rbx = 0 -> ZF set -> jz taken
;
; Demonstrates: test instruction (AND that sets flags only) as the
;               idiomatic "is this register zero?" check
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_89.lst ch07_89_test_zero.asm && ld -g -o ch07_89 ch07_89_test_zero.o
; Run:    ./ch07_89 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; "test rbx,rbx" ANDs rbx with itself: the value never changes, but the
; flags are set exactly as a real AND would set them.  A zero operand
; produces a zero result, so ZF=1 -- "cmp rbx,0" without an immediate.
    xor     rbx, rbx                    ; rbx = 0 (value under test)
    mov     edi, 0                      ; assume "non-zero" answer
    test    rbx, rbx                    ; rbx AND rbx -> 0, ZF = 1
    jnz     last                        ; not taken (result was zero)
    mov     edi, 1                      ; ZF was set: rbx is zero

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
