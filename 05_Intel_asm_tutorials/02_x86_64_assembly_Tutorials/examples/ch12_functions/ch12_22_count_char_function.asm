; -----------------------------------------------------------------------------
; Count occurrences of a character in a string
;
; Demonstrates: two arguments of different kinds (string address in rdi,
;               character value in rsi), byte comparison with sil
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.7 (Argument Transmission),
;               12.8.1 (Parameter Passing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_22_count_char_function.lst ch12_22_count_char_function.asm && ld -g -o ch12_22_count_char_function ch12_22_count_char_function.o
; Run:    ./ch12_22_count_char_function ; echo $?        -> exit code: 3
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    strng       db "banana", 0          ; 'a' occurs three times

section .text
global _start

; -----------------------------------------------------------------------------
; countChar -- rdi = string address, rsi = character to count; returns the
;              number of occurrences in rax.
countChar:
    xor     rax, rax                    ; rax = counter = 0
.next:
    cmp     byte [rdi], 0               ; NUL terminator?
    je      .done
    cmp     byte [rdi], sil             ; strng[i] == wanted character?
    jne     .skip
    inc     rax                         ; one more occurrence
.skip:
    inc     rdi                         ; advance to the next character
    jmp     .next
.done:
    ret

_start:
    mov     rdi, strng                  ; argument 1: address of the string
    mov     rsi, 'a'                    ; argument 2: character to count
    call    countChar                   ; rax = 3

last:
    mov     rdi, rax                    ; exit status = computed result (3)
    mov     rax, SYS_exit               ; call code for exit
    syscall
