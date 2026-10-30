; -----------------------------------------------------------------------------
; BTR: clear a set bit -- btr rax,5 on rax=0x20 -> bit now clear
;
; Demonstrates: btr (bit test and reset) turning a bit off, checked with bt
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_94.lst ch07_94_btr_clear_bit.asm && ld -g -o ch07_94 ch07_94_btr_clear_bit.o
; Run:    ./ch07_94 ; echo $?        -> exit code: 0
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; BTR stores 0 into the selected bit (old value goes to CF).  rax starts
; with only bit 5 set (0x20 = 32); after BTR the register is 0.
    mov     rax, 0x20                   ; rax = 0010 0000 (bit 5 set)
    btr     rax, 5                      ; rax = 0 (bit 5 cleared)

; Confirm with a plain BT that the bit is now off.
    mov     edi, 0                      ; status if the bit is now clear
    bt      rax, 5                      ; CF = bit 5 of rax = 0
    jnc     last                        ; taken (CF = 0): exit with 0
    mov     edi, 1                      ; reached only if the bit survived

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (0)
