        .global _start

        .section .text
_start:
        # Align the stack at process entry.
        andq    $-16, %rsp

        # Initialize Fibonacci values.
        xorq    %r12, %r12              # Current number = 0
        movq    $1, %rbx                # Next number = 1
        movl    $90, %r13d              # Print 90 numbers

print:
        # Preserve Fibonacci state across printf.
        pushq   %r12
        pushq   %rbx

        leaq    format(%rip), %rdi      # Argument 1: format
        movq    %r12, %rsi              # Argument 2: current number
        xorl    %eax, %eax              # No vector arguments

        # Stack is 16-byte aligned before this call.
        call    printf@PLT

        # Restore Fibonacci state.
        popq    %rbx
        popq    %r12

        # Calculate the next Fibonacci pair.
        movq    %r12, %rdx
        movq    %rbx, %r12
        addq    %rdx, %rbx

        decl    %r13d
        jnz     print

        # Flush libc output before exiting.
        xorl    %edi, %edi              # fflush(NULL)
        call    fflush@PLT

        # Linux x86-64 exit syscall.
        movl    $60, %eax               # SYS_exit
        xorl    %edi, %edi              # Status = 0
        syscall

        .section .rodata
format:
        .asciz  "%20ld\n"

        .section .note.GNU-stack,"",@progbits

