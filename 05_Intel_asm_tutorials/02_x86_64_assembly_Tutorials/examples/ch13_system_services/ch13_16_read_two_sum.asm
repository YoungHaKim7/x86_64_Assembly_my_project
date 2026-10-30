; -----------------------------------------------------------------------------
; Read two numbers, print their sum
;
; Demonstrates: two reads feeding one computation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_16.lst ch13_16_read_two_sum.asm && ld -g -o ch13_16_read_two_sum ch13_16_read_two_sum.o
; Run:    printf "60\n40\n" | ./ch13_16_read_two_sum
;         -> 100
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
STDOUT           equ 1
NL               equ 10

section .bss
    inBuf       resb 32
    tmpBuf      resb 32

section .text
global _start

atoi:                                   ; rsi = buf, rcx = count -> rbx
    xor     rbx, rbx
.next:
    movzx   rdx, byte [rsi]
    cmp     dl, NL
    je      .done
    imul    rbx, rbx, 10
    sub     rdx, '0'
    add     rbx, rdx
    inc     rsi
    dec     rcx
    jnz     .next
.done:
    ret

printInt:                               ; rdi = value
    push    rbx                        ; rbx is callee-saved; we use it below
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
    inc     r8                         ; newline counts in the length
    mov     rdx, r8
    sub     rdx, tmpBuf
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    syscall
    pop     rbx                        ; restore callee-saved rbx
    ret

_start:
    ; ---- one read usually delivers BOTH lines ("60\n40\n") --------------
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 32
    syscall
    mov     rcx, rax                   ; total bytes
    mov     rsi, inBuf
    call    atoi                       ; stops at first newline; rsi -> NL
    mov     r12, rbx                   ; r12 = 60

    ; ---- second number: skip the newline, count what remains ---------------
    inc     rsi
    mov     rcx, inBuf
    add     rcx, rax                   ; one past the input end
    sub     rcx, rsi                   ; bytes left for the second number
    call    atoi
    add     r12, rbx                   ; r12 = 60 + 40 = 100

    mov     rdi, r12
    call    printInt                   ; "100\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
