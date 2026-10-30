; -----------------------------------------------------------------------------
; sete -- capture the equal flag into a register
;
; Demonstrates: setcc writing 0/1 into a byte register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_138.lst ch07_138_sete.asm && ld -g -o ch07_138_sete ch07_138_sete.o
; Run:    ./ch07_138_sete ; echo $?        -> exit code: 1
;
; sete stores 1 when ZF=1, 0 otherwise -- the comparison result becomes
; data instead of a branch.  Remember to zero rax first: setcc only
; writes the low byte.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    xor     rax, rax                   ; setcc writes only al
    mov     rbx, 42
    mov     rcx, 42
    cmp     rbx, rcx                   ; equal -> ZF=1
    sete    al                         ; al = 1
    ; rax = 1

last:
    mov     rdi, rax                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
