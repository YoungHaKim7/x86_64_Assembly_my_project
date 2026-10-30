; -----------------------------------------------------------------------------
; rflags carry bit: read CF as bit 0 of the pushed rflags image
;
; Demonstrates: pushfq, pop rax, testing a single flag bit with and
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_14_rflags_carry_bit.lst ch09_14_rflags_carry_bit.asm && ld -g -o ch09_14_rflags_carry_bit ch09_14_rflags_carry_bit.o
; Run:    ./ch09_14_rflags_carry_bit ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 200 + 100 = 300 does not fit in a byte: al keeps 300-256 = 44 and the
; CPU records the lost 256 in the carry flag.
    mov     al, 200                        ; al = 200
    add     al, 100                        ; al = 44, CF = 1 (carry out)

; There is no "mov rax, rflags" instruction -- the standard route is to
; push rflags onto the stack and pop it into a general register, where
; single bits can be tested with ordinary logic instructions.
    pushfq                                 ; stack: [rflags image]
    pop     rax                            ; rax = rflags image

    and     rax, 1                         ; isolate bit 0 = CF
    mov     rdi, rax                       ; exit code = 1 (carry was set)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
