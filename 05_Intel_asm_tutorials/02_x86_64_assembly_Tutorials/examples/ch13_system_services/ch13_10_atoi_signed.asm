; -----------------------------------------------------------------------------
; atoi with sign -- handling a leading minus
;
; Demonstrates: signed decimal parsing (negate after the loop)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_10.lst ch13_10_atoi_signed.asm && ld -g -o ch13_10_atoi_signed ch13_10_atoi_signed.o
; Run:    echo "-7" | ./ch13_10_atoi_signed ; echo $?
;         -> 249          (low byte of -7 in two's complement)
;
; Parse the magnitude, then apply the sign once at the end.
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
NL               equ 10

section .bss
    inBuf       resb 32

section .text
global _start
_start:
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 32
    syscall
    mov     rcx, rax                   ; byte count

    xor     rbx, rbx                   ; magnitude accumulator
    xor     r8, r8                     ; negative flag = false
    mov     rsi, inBuf

    cmp     byte [rsi], '-'            ; leading minus?
    jne     .digitLoop
    mov     r8, 1                      ; remember: negative
    inc     rsi
    dec     rcx

.digitLoop:
    movzx   rdx, byte [rsi]
    cmp     dl, NL
    je      .applySign
    imul    rbx, rbx, 10
    sub     rdx, '0'
    add     rbx, rdx
    inc     rsi
    dec     rcx
    jnz     .digitLoop

.applySign:
    test    r8, r8
    jz      .done
    neg     rbx                        ; -7
.done:

last:
    mov     rdi, rbx                    ; exit status = 0xF9 = 249
    mov     rax, SYS_exit
    syscall
