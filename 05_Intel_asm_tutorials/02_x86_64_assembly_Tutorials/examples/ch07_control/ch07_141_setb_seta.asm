; -----------------------------------------------------------------------------
; seta / setb -- unsigned comparison outcomes
;
; Demonstrates: setcc with UNSIGNED conditions
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_141.lst ch07_141_setb_seta.asm && ld -g -o ch07_141_setb_seta ch07_141_setb_seta.o
; Run:    ./ch07_141_setb_seta ; echo $?        -> exit code: 1
;
; 200 vs 100 as unsigned: above = 1, below = 0.  The same bits read as
; signed would flip both answers -- the a/b family never looks at SF/OF.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rbx, 200
    mov     rcx, 100
    xor     rax, rax                   ; zero first -- xor would clear the
    xor     rdx, rdx                   ; flags if placed after the cmp
    cmp     rbx, rcx
    seta    al                         ; al = (200 >u 100) = 1
    setb    dl                         ; dl = (200 <u 100) = 0
    add     rax, rdx                   ; rax = 1

last:
    mov     rdi, rax                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
