; -----------------------------------------------------------------------------
; setne -- capture the not-equal flag into a register
;
; Demonstrates: setne (setnz) writing 0/1 into a byte register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_139.lst ch07_139_setne.asm && ld -g -o ch07_139_setne ch07_139_setne.o
; Run:    ./ch07_139_setne ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    xor     rax, rax
    mov     rbx, 41
    mov     rcx, 42
    cmp     rbx, rcx                   ; different -> ZF=0
    setne   al                         ; al = 1
    ; rax = 1

last:
    mov     rdi, rax                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
