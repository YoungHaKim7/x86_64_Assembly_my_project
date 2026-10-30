; -----------------------------------------------------------------------------
; getpid -- a syscall that returns information, not I/O
;
; Demonstrates: SYS_getpid (39), label + integer output
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 23.2 (Basic System Services)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_25.lst ch13_25_getpid.asm && ld -g -o ch13_25_getpid ch13_25_getpid.o
; Run:    ./ch13_25_getpid
;         -> pid: 4242        (any pid; different every run)
; -----------------------------------------------------------------------------

SYS_getpid        equ 39
SYS_write         equ 1
SYS_exit          equ 60
EXIT_SUCCESS      equ 0
STDOUT            equ 1
NL                equ 10

section .data
    label       db  "pid: "
    labelLen    equ $-label

section .bss
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
    mov     rax, SYS_write             ; fixed label first
    mov     rdi, STDOUT
    mov     rsi, label
    mov     rdx, labelLen
    syscall

    mov     rax, SYS_getpid            ; no arguments, returns pid in rax
    mov     rdi, rax
    call    printInt                   ; "pid: <number>\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
