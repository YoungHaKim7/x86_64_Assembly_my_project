; -----------------------------------------------------------------------------
; lib_minmax.asm -- a tiny function library in its own object file
;
; minValue: rdi, rsi -> rax = smaller signed value
; maxValue: rdi, rsi -> rax = larger signed value
; absValue: rdi      -> rax = |rdi|
; All three are global: the linker resolves them from any object file.
; -----------------------------------------------------------------------------

section .text
global minValue
global maxValue
global absValue

minValue:
    mov     rax, rdi
    cmp     rsi, rax
    cmovl   rax, rsi
    ret

maxValue:
    mov     rax, rdi
    cmp     rsi, rax
    cmovg   rax, rsi
    ret

absValue:
    mov     rax, rdi
    test    rax, rax
    jns     .done
    neg     rax
.done:
    ret
