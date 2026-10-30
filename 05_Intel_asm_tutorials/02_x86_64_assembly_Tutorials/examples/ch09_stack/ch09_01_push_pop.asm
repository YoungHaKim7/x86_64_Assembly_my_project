; -----------------------------------------------------------------------------
; push and pop basics: push 42 onto the stack, pop it back into rbx
;
; Demonstrates: push (immediate), pop (into a register)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_01_push_pop.lst ch09_01_push_pop.asm && ld -g -o ch09_01_push_pop ch09_01_push_pop.o
; Run:    ./ch09_01_push_pop ; echo $?        -> exit code: 42
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; push stores its operand at rsp-8 and then subtracts 8 from rsp; pop reads
; the qword at rsp and adds 8 back.  A push/pop pair around a value simply
; moves it through memory -- here the value 42 travels to rbx.
    push    42                             ; stack: [42]      rsp -= 8
    pop     rbx                            ; rbx = 42         rsp += 8

    mov     rdi, rbx                       ; exit code = 42

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
