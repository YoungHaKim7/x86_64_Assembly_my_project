; -----------------------------------------------------------------------------
; itoa with sign -- printing -42
;
; Demonstrates: magnitude conversion plus a prepended '-'
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_12.lst ch13_12_itoa_negative.asm && ld -g -o ch13_12_itoa_negative ch13_12_itoa_negative.o
; Run:    ./ch13_12_itoa_negative
;         -> -42
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
_start:
    mov     rax, -42                   ; value to convert
    xor     r8, r8                     ; negative flag
    test    rax, rax
    jns     .positive
    neg     rax                         ; work with magnitude
    mov     r8, 1
.positive:
    mov     rsi, tmpBuf
    xor     r9, r9

.divLoop:
    xor     rdx, rdx
    mov     rbx, 10
    div     rbx
    add     dl, '0'
    push    rdx
    inc     r9
    test    rax, rax
    jnz     .divLoop

    test    r8, r8                      ; negative? prepend '-'
    jz      .popLoop
    mov     byte [rsi], '-'
    inc     rsi                        ; r9 stays: it counts pushed digits

.popLoop:
    pop     rdx
    mov     byte [rsi], dl
    inc     rsi
    dec     r9
    jnz     .popLoop

    mov     byte [rsi], NL             ; "-42\n" = 4 bytes

    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, tmpBuf
    mov     rdx, 4
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
