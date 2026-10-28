        .global _start

        .section .text
_start:
        leaq    message(%rip), %rdi     # First argument: message
        call    puts@PLT                # puts(message)
        xorl    %eax, %eax              # Return 0 from main
        ret

        .section .rodata
message:
        .asciz  "Hola, mundo"

        .section .note.GNU-stack,"",@progbits
