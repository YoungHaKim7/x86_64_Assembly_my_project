; -----------------------------------------------------------------------------
; Writing eax zeroes the upper half of rax
;
; Demonstrates: 32-bit destination writes zero-extend into the 64-bit reg
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_20.lst ch07_20_eax_zero_extends.asm && ld -g -o ch07_20 ch07_20_eax_zero_extends.o
; Run:    ./ch07_20 ; echo $?        -> exit code: 11
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Fill the register with 1-bits so any leftover garbage would be obvious.
    mov     rax, -1                  ; rax = 0xFFFFFFFFFFFFFFFF

; A 32-bit destination (eax) writes the low dword AND clears the upper
; dword to zero in the same instruction — not just "leaves it alone".
    mov     eax, 0x0B                ; rax = 0x000000000000000B = 11 EXACTLY

; The old -1 is completely gone: rax equals 11, not 0xFFFFFFFF0000000B.
    mov     rbx, rax                 ; save the result (rax = syscall number)

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 11
    syscall
