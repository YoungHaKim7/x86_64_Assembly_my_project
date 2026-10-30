; -----------------------------------------------------------------------------
; cmovg -- conditional move on signed greater (pick the maximum)
;
; Demonstrates: cmovg implementing max(a,b) without a jump
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_132.lst ch07_132_cmovg_max.asm && ld -g -o ch07_132_cmovg_max ch07_132_cmovg_max.o
; Run:    ./ch07_132_cmovg_max ; echo $?        -> exit code: 88
;
; Mirror image of ch07_131: cmp rbx,rax asks "other > candidate?" and
; cmovg swaps in the other value only when that is true.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 23                    ; rax = candidate (first value)
    mov     rbx, 88                    ; rbx = other value
    cmp     rbx, rax                   ; flags reflect: other > candidate?
    cmovg   rax, rbx                   ; yes -> rax = other; no -> keep rax
    ; rax = max(23, 88) = 88

last:
    mov     rdi, rax                   ; exit status = 88
    mov     rax, SYS_exit
    syscall
