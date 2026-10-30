; -----------------------------------------------------------------------------
; Squares table -- one input, a loop of outputs
;
; Demonstrates: printInt inside a counted loop
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_18.lst ch13_18_squares_table.asm && ld -g -o ch13_18_squares_table ch13_18_squares_table.o
; Run:    echo "5" | ./ch13_18_squares_table
;         -> 1
;            4
;            9
;            16
;            25
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
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 32
    syscall
    mov     rcx, rax
    mov     rsi, inBuf
    call    atoi                       ; rbx = n = 5

    mov     r12, 1                     ; current i
.tableLoop:
    cmp     r12, rbx
    jg      last
    mov     rax, r12
    mul     r12                        ; rax = i*i
    mov     rdi, rax
    call    printInt
    inc     r12
    jmp     .tableLoop

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
