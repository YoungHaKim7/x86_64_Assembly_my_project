; -----------------------------------------------------------------------------
; idiv (positive operands): 137 / 10 -> quotient 13, remainder 7
;
; Demonstrates: signed quadword divide idiv with positive operands, cqo
;               before the divide
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_69.lst ch07_69_idiv_positive.asm && ld -g -o ch07_69 ch07_69_idiv_positive.o
; Run:    ./ch07_69 ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; idiv rbx divides the 128-bit signed value rdx:rax by rbx.  Before the
; divide, rdx must hold the SIGN EXTENSION of rax -- produced by cqo
; (convert quadword to octaword).  For a positive rax, cqo simply fills
; rdx with zeros.
    mov     rax, 137                    ; rax = 137 (signed dividend)
    cqo                                ; rdx:rax = sign-extended 137
    mov     rbx, 10                     ; rbx = 10 (signed divisor)
    idiv    rbx                         ; rax = 13, rdx = 137 % 10 = 7

; With both operands positive, signed and unsigned division agree:
; 10 * 13 + 7 = 137, remainder in rdx.
    movzx   edi, dl                     ; exit status = remainder (7)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (7)
