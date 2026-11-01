.intel_syntax noprefix

.global main

.section .text

main:
    movabs rax, 0x123456789ABCDEF0

    mov eax, 0x11111111

    movabs rax, 0x123456789ABCDEF0

    mov ax, 0x2222

    mov al, 0x33

    mov rax, 60
    xor rdi, rdi
    syscall

.section .note.GNU-stack,"",@progbits
