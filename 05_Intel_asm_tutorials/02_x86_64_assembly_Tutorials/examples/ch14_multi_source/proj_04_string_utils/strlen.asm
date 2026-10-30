; strLen: rdi = NUL-terminated string -> rax = length
section .text
global strLen

strLen:
    xor     rax, rax
.next:
    cmp     byte [rdi + rax], 0
    je      .done
    inc     rax
    jmp     .next
.done:
    ret
