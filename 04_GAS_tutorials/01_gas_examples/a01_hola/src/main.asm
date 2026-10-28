        .global _start

        .section .text
_start:
        leaq    message(%rip), %rdi     # Argument 1: message
        call    puts@PLT                # puts(message)

        # Exit the process using Linux x86-64 syscall
        movl    $60, %eax               # SYS_exit = 60
        xorl    %edi, %edi              # Exit status = 0
        syscall                         # exit(0)

        .section .rodata
message:
        .asciz  "Hola, mundo"

        .section .note.GNU-stack,"",@progbits
