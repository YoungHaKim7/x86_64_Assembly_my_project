; -----------------------------------------------------------------------------
; Simple calculator -- parse "12+34" from stdin and print the sum
;
; Demonstrates: two atoi scans in one input line (stop at '+')
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.4 and 13.8
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_26.lst ch13_26_simple_calculator.asm && ld -g -o ch13_26_simple_calculator ch13_26_simple_calculator.o
; Run:    echo "12+34" | ./ch13_26_simple_calculator
;         -> 46
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
STDOUT           equ 1
NL               equ 10

section .bss
    inBuf       resb 64
    tmpBuf      resb 32

section .text
global _start

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
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 64
    syscall
    mov     rcx, rax                   ; total bytes

    ; ---- first operand: digits until '+' -------------------------------------
    mov     rsi, inBuf
    xor     rbx, rbx                   ; left value
.firstLoop:
    movzx   rdx, byte [rsi]
    cmp     dl, '+'
    je      .plusFound
    imul    rbx, rbx, 10
    sub     rdx, '0'
    add     rbx, rdx
    inc     rsi
    dec     rcx
    jnz     .firstLoop
.plusFound:
    inc     rsi                        ; step over '+'

    ; ---- second operand: digits until newline --------------------------------
    xor     r12, r12                   ; right value
.secondLoop:
    movzx   rdx, byte [rsi]
    cmp     dl, NL
    je      .compute
    imul    r12, r12, 10
    sub     rdx, '0'
    add     r12, rdx
    inc     rsi
    dec     rcx
    jnz     .secondLoop

.compute:
    lea     rdi, [rbx + r12]           ; 12 + 34 = 46
    call    printInt

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
