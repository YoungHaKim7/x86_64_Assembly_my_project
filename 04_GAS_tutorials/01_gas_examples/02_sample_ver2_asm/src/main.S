# ----------------------------------------------------------------------------------------
# Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
# To assemble and run:
#
#     gcc src/main.S && ./a.out
#
# or
#
#     gcc -nostdlib hello.s && ./a.out
# ----------------------------------------------------------------------------------------

        .global main

        .text
main:
        mov     $message, %rdi
        call    puts
        xor     %rax, %rax
        ret

message:
        .asciz  "Hola, mundo"

        # Mark stack as non-executable for security
        .section .note.GNU-stack,"",@progbits
