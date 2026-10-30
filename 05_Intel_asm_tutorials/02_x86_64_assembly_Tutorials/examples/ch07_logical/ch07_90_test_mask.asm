; -----------------------------------------------------------------------------
; TEST with a mask: 0x0A and 0x40 share no bits -> ZF set, jnz not taken
;
; Demonstrates: test instruction checking whether ANY masked bits are set
;               without altering either operand
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_90.lst ch07_90_test_mask.asm && ld -g -o ch07_90 ch07_90_test_mask.o
; Run:    ./ch07_90 ; echo $?        -> exit code: 0
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 0x0A = 0000 1010 and 0x40 = 0100 0000 have no bit positions in common,
; so their AND is 0 and test sets ZF=1.  The jnz branch ("some masked bit
; is set") is therefore NOT taken, and execution falls straight through
; with the pre-loaded status 0 -- the "no bits in common" answer.
    mov     rax, 0x0A                   ; rax = 0000 1010
    mov     rbx, 0x40                   ; rbx = 0100 0000 (the mask)
    mov     edi, 0                      ; status if no common bit is found
    test    rax, rbx                    ; 0x0A AND 0x40 = 0 -> ZF = 1
    jnz     sharedBit                   ; NOT taken (result was zero)
    jmp     last                        ; fall through with edi = 0

sharedBit:
    mov     edi, 1                      ; reached only if a masked bit is 1

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (0)
