; -----------------------------------------------------------------------------
; Function with two arguments
;
; Demonstrates: first argument in rdi, second argument in rsi, sum returned
;               in rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.7 (Argument Transmission),
;               12.8.1 (Parameter Passing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_03_two_arguments.lst ch12_03_two_arguments.asm && ld -g -o ch12_03_two_arguments ch12_03_two_arguments.o
; Run:    ./ch12_03_two_arguments ; echo $?        -> exit code: 168
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; addTwo -- returns rdi + rsi in rax.
addTwo:
    mov     rax, rdi                    ; rax = argument 1
    add     rax, rsi                    ; rax += argument 2
    ret

_start:
    mov     rdi, 78                     ; argument 1
    mov     rsi, 90                     ; argument 2
    call    addTwo                      ; rax = 78 + 90 = 168

last:
    mov     rdi, rax                    ; exit status = computed result (168)
    mov     rax, SYS_exit               ; call code for exit
    syscall
