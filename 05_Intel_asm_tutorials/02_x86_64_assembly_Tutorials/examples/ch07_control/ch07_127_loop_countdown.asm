; -----------------------------------------------------------------------------
; The loop instruction: rcx as a built-in countdown counter
;
; Demonstrates: loop — decrement rcx and jump while rcx != 0
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_127.lst ch07_127_loop_countdown.asm && ld -g -o ch07_127 ch07_127_loop_countdown.o
; Run:    ./ch07_127 ; echo $?       -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; `loop` behaves like "dec rcx; jnz target" fused into one instruction:
; it decrements rcx and jumps while the result is non-zero.  Two things to
; note: the counter MUST be rcx (no other register works), and loop does
; not modify any rFLAGS bits — so the inc below is harmless.
    mov     rcx, 5                  ; loop counter: 5 iterations
    xor     rbx, rbx                ; rbx tallies completed iterations
countdown:
    inc     rbx                     ; loop body: count this pass
    loop    countdown               ; rcx--; jump back while rcx != 0

; Five passes later: rbx = 5 and rcx has counted down to 0.

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 5 iterations
    syscall
