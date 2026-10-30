; -----------------------------------------------------------------------------
; Swap two memory values through pointers (pass by reference)
;
; Demonstrates: passing ADDRESSES as arguments in rdi/rsi so the function
;               can modify the caller's variables
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.7 (Argument Transmission)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_29_swap_pointers_function.lst ch12_29_swap_pointers_function.asm && ld -g -o ch12_29_swap_pointers_function ch12_29_swap_pointers_function.o
; Run:    ./ch12_29_swap_pointers_function ; echo $?        -> exit code: 3
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qVarA       dq 3                    ; a = 3
    qVarB       dq 8                    ; b = 8

section .text
global _start

; -----------------------------------------------------------------------------
; swapValues -- rdi = address of first qword, rsi = address of second
;               qword; exchanges the two values in memory.
;
; The caller passes addresses, not values: only then can the function reach
; back and change the caller's variables. This is pass by reference,
; assembly style.
swapValues:
    mov     rax, qword [rdi]            ; rax = *pA
    mov     rdx, qword [rsi]            ; rdx = *pB
    mov     qword [rdi], rdx            ; *pA = old *pB
    mov     qword [rsi], rax            ; *pB = old *pA
    ret

_start:
    mov     rdi, qVarA                  ; argument 1: address of a
    mov     rsi, qVarB                  ; argument 2: address of b
    call    swapValues                  ; a = 8, b = 3

    mov     rax, qword [qVarB]          ; b must now hold 3 (the old a)

last:
    mov     rdi, rax                    ; exit status = 3
    mov     rax, SYS_exit               ; call code for exit
    syscall
