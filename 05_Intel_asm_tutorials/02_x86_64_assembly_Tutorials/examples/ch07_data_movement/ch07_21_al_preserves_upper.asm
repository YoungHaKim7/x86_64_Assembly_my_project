; -----------------------------------------------------------------------------
; Writing al preserves the upper bits of rax
;
; Demonstrates: 8-bit destination writes touch ONLY the low byte
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_21.lst ch07_21_al_preserves_upper.asm && ld -g -o ch07_21 ch07_21_al_preserves_upper.o
; Run:    ./ch07_21 ; echo $?        -> exit code: 95
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Again fill the register with 1-bits first.
    mov     rax, -1                  ; rax = 0xFFFFFFFFFFFFFFFF

; An 8-bit destination (al) changes ONLY the low byte — the upper 56
; bits keep their old contents (unlike the eax case in ch07_20):
;       rax = 0xFFFFFFFFFFFFFF5F    (NOT 0x5F!)
;       al  = 0x5F = 95
    mov     al, 0x5F                 ; overwrite just one byte of rax

; To use the byte as a small value it must be isolated — movzx grabs
; al and zero-fills a fresh register.
    movzx   rbx, al                  ; rbx = 95

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 95
    syscall
