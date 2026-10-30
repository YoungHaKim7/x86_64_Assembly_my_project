; -----------------------------------------------------------------------------
; imul (three operand): imul rbx, rax, 21 -- 12 * 21 = 252
;
; Demonstrates: the three-operand signed multiply,
;               destination = source * immediate
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_61.lst ch07_61_imul_three_operand.asm && ld -g -o ch07_61 ch07_61_imul_three_operand.o
; Run:    ./ch07_61 ; echo $?        -> exit code: 252
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; The three-operand form computes destination = source1 * source2 without
; touching source1 -- handy when the original value is needed again later.
; The second source is usually an immediate constant.
    mov     rax, 12                     ; rax = 12 (unchanged by the imul)
    imul    rbx, rax, 21                ; rbx = rax * 21 = 12 * 21 = 252

; rax still holds 12; the product went only into rbx.
    movzx   edi, bl                     ; exit status = 252

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (252)
