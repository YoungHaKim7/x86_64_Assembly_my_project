; -----------------------------------------------------------------------------
; rbp stack frame: two local variables at [rbp-8] and [rbp-16], sum = 25
;
; Demonstrates: standard frame prologue/epilogue (push rbp / mov rbp,rsp /
;               sub rsp,N) and locals addressed relative to rbp
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.4 (Stack Frame)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_12_rbp_frame.lst ch09_12_rbp_frame.asm && ld -g -o ch09_12_rbp_frame ch09_12_rbp_frame.o
; Run:    ./ch09_12_rbp_frame ; echo $?        -> exit code: 25
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Frame prologue: rbp is pinned to the base of the current frame, so locals
; keep their addresses ([rbp-8], [rbp-16]) even while rsp moves.
    push    rbp                            ; save caller's rbp
    mov     rbp, rsp                       ; rbp = frame base
    sub     rsp, 16                        ; room for two qword locals

    mov     qword [rbp-8], 10              ; local 1 = 10
    mov     qword [rbp-16], 15             ; local 2 = 15

    mov     rax, qword [rbp-8]             ; rax = 10
    add     rax, qword [rbp-16]            ; rax = 10 + 15 = 25

; Frame epilogue: drop the locals by restoring rsp from rbp, then bring the
; caller's rbp back -- the mirror image of the prologue.
    mov     rsp, rbp                       ; deallocate locals
    pop     rbp                            ; restore caller's rbp

    mov     rdi, rax                       ; exit code = 25

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
