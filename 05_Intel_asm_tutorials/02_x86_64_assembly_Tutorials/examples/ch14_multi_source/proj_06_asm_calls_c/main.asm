; -----------------------------------------------------------------------------
; main.asm -- assembly _start calling a C function
;
; Demonstrates: asm -> C direction of mixed-language programs
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.3 (Interfacing with a High-Level Language)
;
; Build:  bash build.sh
; Run:    ./proj_06_asm_calls_c
;         -> sum = 60
;
; add3 is pure computation (no stdio inside), so the asm side keeps full
; control of console output via SYS_write; the integer printing is the
; book's itoa.  Linked with gcc -no-pie so absolute addressing is legal.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

extern add3                      ; from helper.c

section .data
    msg         db  "sum = "
    msgLen      equ $-msg

section .bss
    tmpBuf      resb 32

section .text
global _start

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

_start:
    mov     rax, SYS_write             ; "sum = "
    mov     rdi, STDOUT
    mov     rsi, msg
    mov     rdx, msgLen
    syscall

    mov     rdi, 10                    ; args 1..3 for add3
    mov     rsi, 20
    mov     rdx, 30
    call    add3                       ; rax = 60

    mov     rdi, rax
    call    printInt                   ; "60\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
