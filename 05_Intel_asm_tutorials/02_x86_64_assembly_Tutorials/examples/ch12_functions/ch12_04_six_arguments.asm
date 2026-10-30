; -----------------------------------------------------------------------------
; Function with six register arguments
;
; Demonstrates: the six integer argument registers of the x86-64 calling
;               convention: rdi, rsi, rdx, rcx, r8, r9
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.8.1 (Parameter Passing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_04_six_arguments.lst ch12_04_six_arguments.asm && ld -g -o ch12_04_six_arguments ch12_04_six_arguments.o
; Run:    ./ch12_04_six_arguments ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; sumSix -- returns rdi + rsi + rdx + rcx + r8 + r9 in rax.
; These six registers carry the first six integer arguments; anything past
; the sixth must travel on the stack (see ch12_05).
sumSix:
    mov     rax, rdi                    ; argument 1
    add     rax, rsi                    ; + argument 2
    add     rax, rdx                    ; + argument 3
    add     rax, rcx                    ; + argument 4
    add     rax, r8                     ; + argument 5
    add     rax, r9                     ; + argument 6
    ret

_start:
    mov     rdi, 1                      ; argument 1
    mov     rsi, 2                      ; argument 2
    mov     rdx, 3                      ; argument 3
    mov     rcx, 4                      ; argument 4
    mov     r8, 5                       ; argument 5
    mov     r9, 6                       ; argument 6
    call    sumSix                      ; rax = 1+2+3+4+5+6 = 21

last:
    mov     rdi, rax                    ; exit status = computed result (21)
    mov     rax, SYS_exit               ; call code for exit
    syscall
