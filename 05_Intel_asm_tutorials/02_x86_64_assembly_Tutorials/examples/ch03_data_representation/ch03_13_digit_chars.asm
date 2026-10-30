; -----------------------------------------------------------------------------
; Digit characters: '7' - '0' == 7 and '0' + 9 == '9'
;
; Demonstrates: converting between a digit character and its numeric value
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.4.1.1 (American Standard Code...)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_13_digit_chars.lst ch03_13_digit_chars.asm && ld -g -o ch03_13_digit_chars ch03_13_digit_chars.o
; Run:    ./ch03_13_digit_chars ; echo $?        -> exit code: 57
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, '7'                         ; al = 55 (ASCII '7')
    sub     al, '0'                         ; al = '7' - '0' = 7 (numeric value)
    cmp     al, 7                           ; verify the character-to-value step
    jne     factsWrong

    mov     bl, '0'                         ; bl = 48 (ASCII '0')
    add     bl, 9                           ; bl = '0' + 9 = '9' = 57
    movzx   rdi, bl                         ; exit code 57 (ASCII '9')
    jmp     last

factsWrong:
    mov     rdi, 0                          ; (unreachable: digits are consecutive)

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
