section     .data
    SYS_EXIT equ 60
    EXIT_CODE equ 0

section     .text
    global _start

_start:
    ; exit(code)
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall
