; -----------------------------------------------------------------------------
; printInt twice -- two results on two lines
;
; Demonstrates: calling a print function repeatedly
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 - 12.8 and 13.8
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_14.lst ch13_14_print_two_ints.asm && ld -g -o ch13_14_print_two_ints ch13_14_print_two_ints.o
; Run:    ./ch13_14_print_two_ints
;         -> 30
;            6            (18+12 and 18-12)
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

section .bss
    tmpBuf      resb 32

section .text
global _start

printInt:
    push    rbx                        ; rbx is callee-saved; we use it below
    mov     rax, rdi
    mov     rsi, tmpBuf
    xor     r9, r9
    xor     r8, r8
    test    rax, rax
    jns     .divLoop
    neg     rax
    mov     r8, 1
.divLoop:
    xor     rdx, rdx
    mov     rbx, 10
    div     rbx
    add     dl, '0'
    push    rdx
    inc     r9
    test    rax, rax
    jnz     .divLoop
    test    r8, r8
    jz      .popLoop
    mov     byte [rsi], '-'
    inc     rsi                        ; r9 stays: it counts pushed digits
.popLoop:
    pop     rdx
    mov     byte [rsi], dl
    inc     rsi
    dec     r9
    jnz     .popLoop
    mov     byte [rsi], NL
    inc     rsi                        ; newline counts in the length
    mov     rdx, rsi
    sub     rdx, tmpBuf
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    syscall
    pop     rbx                        ; restore callee-saved rbx
    ret

_start:
    ; keep operands in callee-saved registers: syscall clobbers rcx/r11,
    ; so a value parked in rcx would not survive the printInt call
    mov     rbx, 18
    mov     r12, 12

    lea     rdi, [rbx + r12]           ; 30
    call    printInt

    mov     rdi, rbx
    sub     rdi, r12                   ; 6
    call    printInt

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
