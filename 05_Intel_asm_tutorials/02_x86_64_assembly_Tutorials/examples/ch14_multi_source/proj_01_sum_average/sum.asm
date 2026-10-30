; -----------------------------------------------------------------------------
; sum.asm -- array statistics in a separate object file
;
; arraySum: rdi = qword array address, rsi = length -> rax = sum
; The label is declared global so the linker can bind calls from main.asm.
; -----------------------------------------------------------------------------

section .text
global arraySum

arraySum:
    xor     rax, rax                   ; running sum
.next:
    test    rsi, rsi
    jz      .done
    add     rax, qword [rdi]
    add     rdi, 8
    dec     rsi
    jmp     .next
.done:
    ret
