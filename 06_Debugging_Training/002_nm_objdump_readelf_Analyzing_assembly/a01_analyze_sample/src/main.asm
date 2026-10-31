; NASM x86-64 assembly

global main
global calculate

section .text

main:
    mov rax, 10
    mov rbx, 20

    call calculate

    ; Linux x86-64 exit syscall
    mov rax, 60
    xor rdi, rdi
    syscall

calculate:
    add rax, rbx
    ret


section .data

my_value:
    dq 12345


section .bss

buffer:
    resb 64
