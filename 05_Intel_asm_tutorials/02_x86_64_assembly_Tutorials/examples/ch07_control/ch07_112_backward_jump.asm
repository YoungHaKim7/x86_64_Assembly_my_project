; -----------------------------------------------------------------------------
; Backward jump: a tiny loop whose body runs exactly three times
;
; Demonstrates: backward jmp target, dec + jnz — a counted loop by hand
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_112.lst ch07_112_backward_jump.asm && ld -g -o ch07_112 ch07_112_backward_jump.o
; Run:    ./ch07_112 ; echo $?       -> exit code: 3
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; A jump is "backward" when its target label appears EARLIER in the code
; (lower address).  Taking a backward jump again and again until a counter
; runs out is how a loop is built from raw jump instructions.
    mov     rcx, 3                  ; iterations still to do
    xor     rbx, rbx                ; rbx counts completed iterations
again:
    inc     rbx                     ; loop body: record one more pass
    dec     rcx                     ; one fewer remaining; sets ZF at zero
    jnz     again                   ; backward jump while rcx != 0

; Three passes were made: rbx went 1, 2, 3 and rcx is now 0.

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 3 iterations
    syscall
