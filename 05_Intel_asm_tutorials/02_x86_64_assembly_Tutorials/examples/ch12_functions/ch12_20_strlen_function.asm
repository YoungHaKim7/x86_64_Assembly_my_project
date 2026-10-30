; -----------------------------------------------------------------------------
; String length function (NUL-terminated string)
;
; Demonstrates: scanning a string until the NUL terminator, pointer plus
;               index addressing, string passed by address in rdi
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.7 (Argument Transmission)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_20_strlen_function.lst ch12_20_strlen_function.asm && ld -g -o ch12_20_strlen_function ch12_20_strlen_function.o
; Run:    ./ch12_20_strlen_function ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    strng       db "Hello", 0           ; five characters plus terminator

section .text
global _start

; -----------------------------------------------------------------------------
; strLen -- rdi = string address; returns the number of bytes before the
;           terminating NUL in rax.
strLen:
    xor     rax, rax                    ; rax = length = 0
.countLoop:
    cmp     byte [rdi + rax], 0         ; strng[len] == NUL?
    je      .done
    inc     rax                         ; one more character
    jmp     .countLoop
.done:
    ret

_start:
    mov     rdi, strng                  ; argument: address of the string
    call    strLen                      ; rax = 5

last:
    mov     rdi, rax                    ; exit status = computed result (5)
    mov     rax, SYS_exit               ; call code for exit
    syscall
