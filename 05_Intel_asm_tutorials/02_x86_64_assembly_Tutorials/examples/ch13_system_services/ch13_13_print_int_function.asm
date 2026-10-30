; -----------------------------------------------------------------------------
; printInt -- a reusable integer-printing function
;
; Demonstrates: itoa + write packaged as one routine (rdi = value)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 - 12.8 and 13.8
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_13.lst ch13_13_print_int_function.asm && ld -g -o ch13_13_print_int_function ch13_13_print_int_function.o
; Run:    ./ch13_13_print_int_function
;         -> 375
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

; ---- printInt: rdi = signed value; prints value + newline ----------------
printInt:
    push    rbx                        ; rbx is callee-saved; we use it below
    mov     rax, rdi
    mov     rsi, tmpBuf
    xor     r9, r9                     ; digit count
    xor     r8, r8                     ; negative flag
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
    sub     rdx, tmpBuf                ; rdx = total bytes
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    syscall
    pop     rbx                        ; restore callee-saved rbx
    ret

_start:
    mov     rdi, 375
    call    printInt

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
