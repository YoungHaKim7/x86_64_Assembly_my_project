section     .data
    SYS_EXIT equ 60
    EXIT_CODE equ 0

    SYS_WRITE equ 1
    STDOUT equ 1

    SYS_READ equ   0
    STDIN equ   0

    ASCII_A equ 97

    CASE_DIFF equ 32

CHAR:
    resb 1  

; 65 - 91 = 'A' - 'Z'
; 97 - 123 = 'a' - 'z'

; 'A' + 32 = 'a'
; 'a' - 32 = 'A'

section     .text
    global _start

_start:
    ; read(STDIN, CHAR, 1)
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, CHAR
    mov rdx, 1
    syscall

    cmp byte [CHAR], ASCII_A        ; if byte at CHAR is lowercase
    jl  WRITE   ; If less than 'a', write it directly (non-alphabetic)
    cmp byte [CHAR], ASCII_A + 26  ; Check if it's within 'a' to 'z' range
    jge MAKE_UPPERCASE


MAKE_LOWERCASE:
    add byte [CHAR], CASE_DIFF
    jmp WRITE                   ; then write it to stdout

MAKE_UPPERCASE:
    sub byte [CHAR], CASE_DIFF

WRITE:
    ; write(STDOUT, CHAR, 1)
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, CHAR
    mov rdx, 1
    syscall

    ; exit(code)
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall
