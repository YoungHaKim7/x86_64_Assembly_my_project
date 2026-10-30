; -----------------------------------------------------------------------------
; sub: unsigned borrow (5 - 7 wraps to 254)
;
; Demonstrates: sub with byte operands below zero, borrow flag (CF), jnc
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_40.lst ch07_40_sub_borrow.asm && ld -g -o ch07_40 ch07_40_sub_borrow.o
; Run:    ./ch07_40 ; echo $?        -> exit code: 254
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 5 - 7 cannot be represented as an unsigned byte: the CPU computes
; 5 + two's-complement(-7) = 5 + 0xF9 = 0xFE with a carry out of 0,
; i.e. result 0xFE = 254 and CF = 1 (borrow / unsigned underflow)
    mov     al, 5                         ; al = 5 (minuend)
    sub     al, 7                         ; al = 0xFE = 254, CF = 1 (borrow)
    jnc     noBorrow                      ; CF clear -> result really is >= 0

; borrow path: the wrapped byte value 254 becomes the exit code
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 254
    jmp     last

noBorrow:
    mov     rdi, EXIT_SUCCESS             ; exit code 0: no borrow

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
