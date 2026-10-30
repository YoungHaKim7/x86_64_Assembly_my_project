; -----------------------------------------------------------------------------
; Memory to register mov: reading a quadword variable
;
; Demonstrates: mov reg64, qword [label] — loading memory into a register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_03.lst ch07_03_mov_mem_to_reg.asm && ld -g -o ch07_03 ch07_03_mov_mem_to_reg.o
; Run:    ./ch07_03 ; echo $?        -> exit code: 123
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar        dq 123               ; one initialized quadword variable

section .text
global _start
_start:

; Brackets mean "the CONTENTS of memory at this address".  With brackets
; the label is dereferenced; the qword stored at qVar (123) is loaded
; into the register.
    mov     rbx, qword [qVar]        ; rbx = 123 (memory -> register)

; Without brackets the label is just a number — the ADDRESS of the
; variable, not its contents (that form is shown in ch07_18).

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 123
    syscall
