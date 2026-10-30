; -----------------------------------------------------------------------------
; itoa -- converting 12345 to "12345"
;
; Demonstrates: the book's divide-push-pop digit loop
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_11.lst ch13_11_itoa_positive.asm && ld -g -o ch13_11_itoa_positive ch13_11_itoa_positive.o
; Run:    ./ch13_11_itoa_positive
;         -> 12345
;
; div by 10 yields digits least-significant first, so each digit is
; PUSHED; popping reverses them into printable order.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

section .bss
    tmpBuf      resb 32                ; digit scratch space

section .text
global _start
_start:
    mov     rax, 12345                 ; value to convert
    mov     rsi, tmpBuf
    xor     r9, r9                     ; digit count

.divLoop:
    xor     rdx, rdx
    mov     rbx, 10
    div     rbx                        ; rax = quotient, rdx = digit
    add     dl, '0'                    ; digit -> ASCII
    push    rdx                        ; stack holds digits reversed
    inc     r9
    test    rax, rax
    jnz     .divLoop

.popLoop:
    pop     rdx
    mov     byte [rsi], dl             ; pop restores correct order
    inc     rsi
    dec     r9
    jnz     .popLoop

    mov     byte [rsi], NL             ; append newline

    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    mov     rdx, 6                     ; 5 digits + newline
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
