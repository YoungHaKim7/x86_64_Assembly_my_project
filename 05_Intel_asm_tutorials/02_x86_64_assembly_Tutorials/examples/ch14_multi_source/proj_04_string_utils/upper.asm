; strUpper: rdi = string (converted in place), rsi = length
section .text
global strUpper

strUpper:
.next:
    test    rsi, rsi
    jz      .done
    mov     al, byte [rdi]
    cmp     al, 'a'
    jb      .keep
    cmp     al, 'z'
    ja      .keep
    sub     al, 'a' - 'A'
    mov     byte [rdi], al
.keep:
    inc     rdi
    dec     rsi
    jmp     .next
.done:
    ret
