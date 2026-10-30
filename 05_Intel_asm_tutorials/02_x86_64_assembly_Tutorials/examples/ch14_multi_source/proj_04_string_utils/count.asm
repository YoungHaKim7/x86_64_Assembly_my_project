; countChar: rdi = string, rsi = length, dl = char -> rax = occurrences
section .text
global countChar

countChar:
    xor     rax, rax
.next:
    test    rsi, rsi
    jz      .done
    cmp     byte [rdi], dl
    jne     .skip
    inc     rax
.skip:
    inc     rdi
    dec     rsi
    jmp     .next
.done:
    ret
