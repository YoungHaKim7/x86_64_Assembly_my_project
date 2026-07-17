	global      main

section     .text

main:
    mov     rax, 1              ; system call for write
    mov     rdi, 1              ; file handle 1 is stdout
    mov     rsi, message        ; address of string to output
    mov     rdx, 13             ; number of bytes
    syscall
    mov     rax, 60             ; system call for exit
    xor     rdi, rdi            ; exit code 0
    syscall

section     .note.GNU-stack noalloc noexec nowrite progbits

section     .data
    message: db         "Hello, World Asm", 10  ; note the newline at the end
