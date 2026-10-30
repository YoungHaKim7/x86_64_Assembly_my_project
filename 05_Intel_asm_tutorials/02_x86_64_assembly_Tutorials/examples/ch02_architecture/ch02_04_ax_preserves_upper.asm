; -----------------------------------------------------------------------------
; 16-bit writes preserve the upper bits of the register
;
; Demonstrates: mov ax, <src> only replaces the low 16 bits of rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.3.1.1 (General Purpose Registers)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_04_ax_preserves_upper.lst ch02_04_ax_preserves_upper.asm && ld -g -o ch02_04_ax_preserves_upper ch02_04_ax_preserves_upper.o
; Run:    ./ch02_04_ax_preserves_upper ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     rax, -1                         ; rax = 0xFFFFFFFFFFFFFFFF
    mov     ax, 7                           ; 16-bit destination -> upper bits kept

; rax = 0xFFFFFFFFFFFFFF07: the low byte is 7 but rax != 7
    movzx   rdi, al                         ; extract the low byte (7) for the exit code

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
