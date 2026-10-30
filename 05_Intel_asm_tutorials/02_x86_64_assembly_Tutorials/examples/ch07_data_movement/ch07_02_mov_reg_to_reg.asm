; -----------------------------------------------------------------------------
; Register to register mov: passing a value along a chain
;
; Demonstrates: mov reg64, reg64 — register-to-register copies
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_02.lst ch07_02_mov_reg_to_reg.asm && ld -g -o ch07_02 ch07_02_mov_reg_to_reg.o
; Run:    ./ch07_02 ; echo $?        -> exit code: 77
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; A mov between two registers copies the source into the destination
; and leaves the source unchanged, like an assignment in a high-level
; language:  destination = source.
    mov     rax, 77                  ; rax = 77 (the starting value)
    mov     rbx, rax                 ; rbx = 77 (copy of rax; rax keeps 77)
    mov     rcx, rbx                 ; rcx = 77 (copy of rbx; rbx keeps 77)
    mov     rdx, rcx                 ; rdx = 77 (copy of rcx; rcx keeps 77)

; All four registers now hold the same value — a mov duplicates data,
; it never "moves it away" from the source.

last:
    mov     rax, SYS_exit            ; rax is reused for the syscall number
    mov     rdi, rdx                 ; exit status = rdx = 77
    syscall
