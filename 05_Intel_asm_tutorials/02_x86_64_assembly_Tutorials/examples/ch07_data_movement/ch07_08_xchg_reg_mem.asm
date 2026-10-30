; -----------------------------------------------------------------------------
; xchg with a memory operand: swapping a register and a variable
;
; Demonstrates: xchg reg64, qword [mem] — register/memory exchange
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_08.lst ch07_08_xchg_reg_mem.asm && ld -g -o ch07_08 ch07_08_xchg_reg_mem.o
; Run:    ./ch07_08 ; echo $?        -> exit code: 55
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar        dq 55                ; memory side of the swap

section .text
global _start
_start:

    mov     rax, 7                   ; rax = 7  (register side of the swap)

; xchg works with one memory operand exactly like the register version:
; the register receives the OLD memory value and the memory location
; receives the OLD register value.
    xchg    rax, qword [qVar]        ; rax = 55 (old qVar), qVar = 7 (old rax)

; The register now holds what the variable held before the swap (55).
; (Check in a debugger: qVar would now read as 7.)
last:
    mov     rbx, rax                 ; keep the swap result; rax = syscall no.
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 55
    syscall
