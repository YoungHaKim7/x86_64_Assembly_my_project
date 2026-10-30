; -----------------------------------------------------------------------------
; Function with one argument
;
; Demonstrates: passing a single argument in rdi, returning in rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.7 (Argument Transmission),
;               12.8.1 (Parameter Passing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_02_one_argument.lst ch12_02_one_argument.asm && ld -g -o ch12_02_one_argument ch12_02_one_argument.o
; Run:    ./ch12_02_one_argument ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qVar        dq 99                    ; value to pass in

section .text
global _start

; -----------------------------------------------------------------------------
; incValue -- returns rdi + 1 in rax.
incValue:
    mov     rax, rdi                    ; rax = argument
    inc     rax                         ; rax = argument + 1
    ret

_start:
    mov     rdi, qword [qVar]           ; rdi = 99 (argument 1)
    call    incValue                    ; rax = 100

last:
    mov     rdi, rax                    ; exit status = computed result (100)
    mov     rax, SYS_exit               ; call code for exit
    syscall
