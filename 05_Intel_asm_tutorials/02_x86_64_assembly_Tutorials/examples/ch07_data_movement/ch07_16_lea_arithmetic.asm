; -----------------------------------------------------------------------------
; lea as an arithmetic shortcut: multiply by 3 without mul
;
; Demonstrates: lea reg,[reg + reg*2] — scaled-index arithmetic, no flags
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_16.lst ch07_16_lea_arithmetic.asm && ld -g -o ch07_16 ch07_16_lea_arithmetic.o
; Run:    ./ch07_16 ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     rax, 7                   ; the value to triple

; lea evaluates the ADDRESS EXPRESSION in brackets and discards the
; memory it points at:  rax + rax*2 = 7 + 14 = 21.  It is a multiply-
; by-small-constant trick that neither reads memory nor modifies the
; flags (an add or imul would).
    lea     rbx, [rax + rax*2]       ; rbx = 21  (and rax stays 7)

; Bonus: the same trick scales by 5 ([rax + rax*4]) or 8 [rax*r8], etc.

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 21
    syscall
