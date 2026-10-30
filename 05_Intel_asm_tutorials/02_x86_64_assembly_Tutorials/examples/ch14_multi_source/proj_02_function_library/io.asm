; -----------------------------------------------------------------------------
; io.asm -- shared output routines for project 01
; (assembled and linked together with main.asm and sum.asm)
; -----------------------------------------------------------------------------

SYS_write        equ 1
STDOUT           equ 1
NL               equ 10

section .bss
    tmpBuf      resb 32

section .text
global printInt
global printString

; ---- printString: rdi = address, rsi = length -------------------------------
printString:
    mov     rdx, rsi
    mov     rsi, rdi
    mov     rax, SYS_write
    mov     rdi, STDOUT
    syscall
    ret

; ---- printInt: rdi = value (prints value + newline) -------------------------
printInt:
    push    rbx
    mov     rax, rdi
    mov     r8, tmpBuf
    xor     r9, r9
    xor     r10, r10
    test    rax, rax
    jns     .div
    neg     rax
    mov     r10, 1
.div:
    xor     rdx, rdx
    mov     rbx, 10
    div     rbx
    add     dl, '0'
    push    rdx
    inc     r9
    test    rax, rax
    jnz     .div
    test    r10, r10
    jz      .pop
    mov     byte [r8], '-'
    inc     r8
.pop:
    pop     rdx
    mov     byte [r8], dl
    inc     r8
    dec     r9
    jnz     .pop
    mov     byte [r8], NL
    inc     r8
    mov     rdx, r8
    sub     rdx, tmpBuf
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    syscall
    pop     rbx
    ret
