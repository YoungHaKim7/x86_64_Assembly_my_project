; -----------------------------------------------------------------------------
; cqo + idiv: -100 / 3 -> quotient -33, remainder -1
;
; Demonstrates: cqo sign-extending rax into rdx:rax before a signed
;               quadword divide
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_71.lst ch07_71_cqo_idiv.asm && ld -g -o ch07_71 ch07_71_cqo_idiv.o
; Run:    ./ch07_71 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; cqo (convert quad to octaword) copies the sign bit of rax into every bit
; of rdx, forming the 128-bit signed dividend rdx:rax that idiv requires.
; For -100 (0xFFFFFFFFFFFFFF9C) the sign bit is 1, so rdx becomes all ones.
    mov     rax, -100                   ; rax = -100
    cqo                                ; rdx:rax = sign-extended -100
    mov     rbx, 3                      ; rbx = 3
    idiv    rbx                         ; rax = -33, rdx = -1

; Truncation toward zero: -100 / 3 = -33.33 -> -33, and the remainder
; -1 = 0xFFFFFFFF...; its low byte is 0xFF = 255 -- a fun exit status.
; (3 * -33 + (-1) = -100 checks out.)
    movzx   edi, dl                     ; exit status = 255 (low byte of -1)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (255)
