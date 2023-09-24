global      _start

section     .text

_start:
    mov rax, 1 
    mov rdi, 1
    mov rsi, message
    mov rdx, 13
    syscall
    mov rax, 60             ; system call for exit
    xor rdi, rdi            ; exit code 0
    syscall

    section .data
message: db         "Hello, world Asm", 10
