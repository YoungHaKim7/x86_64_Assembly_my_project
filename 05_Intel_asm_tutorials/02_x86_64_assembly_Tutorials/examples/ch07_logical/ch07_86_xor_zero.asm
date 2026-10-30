; -----------------------------------------------------------------------------
; XOR a register with itself: the classic way to zero it (fastest, shortest)
;
; Demonstrates: "xor reg,reg" clearing a register in one 3-byte instruction
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_86.lst ch07_86_xor_zero.asm && ld -g -o ch07_86 ch07_86_xor_zero.o
; Run:    ./ch07_86 ; echo $?        -> exit code: 0
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Start with garbage in the registers so the zeroing is visible:
    mov     rax, 0xDEADBEEF             ; rax = 0x00000000DEADBEEF
    mov     rbx, -1                     ; rbx = 0xFFFFFFFFFFFFFFFF

; Any value XORed with itself is 0: every 1^1 and 0^0 collapses to 0.
; Compilers (and the book) prefer this over "mov reg,0" because the
; encoding carries no immediate operand, so it is shorter and faster.
    xor     rax, rax                    ; rax = 0
    xor     rbx, rbx                    ; rbx = 0

; Prove both really are zero: add them and exit with the sum.
    add     rbx, rax                    ; rbx = 0 + 0 = 0

last:
    mov     rdi, rbx                    ; exit status = 0
    mov     rax, SYS_exit               ; call code for exit
    syscall
