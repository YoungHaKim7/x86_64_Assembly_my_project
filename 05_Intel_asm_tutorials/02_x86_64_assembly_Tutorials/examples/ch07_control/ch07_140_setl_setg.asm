; -----------------------------------------------------------------------------
; setl + setg -- signed comparison outcomes side by side
;
; Demonstrates: two setcc captures from one cmp
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_140.lst ch07_140_setl_setg.asm && ld -g -o ch07_140_setl_setg ch07_140_setl_setg.o
; Run:    ./ch07_140_setl_setg ; echo $?        -> exit code: 2
;
; One cmp -3 vs 9 feeds both captures: setl says "less" (1), setg says
; "greater" (0).  Packed as less*2 + greater = 2.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rbx, -3
    mov     rcx, 9
    xor     rax, rax                   ; zero BEFORE cmp: setcc writes only
    xor     rdx, rdx                   ; the low byte, and xor must not run
    cmp     rbx, rcx                   ; after cmp or it would eat the flags
    setl    al                         ; al = (-3 < 9)  = 1
    setg    dl                         ; dl = (-3 > 9)  = 0

    add     rax, rax                   ; less term  *2 = 2
    add     rax, rdx                   ; + greater term = 2

last:
    mov     rdi, rax                   ; exit status = 2
    mov     rax, SYS_exit
    syscall
