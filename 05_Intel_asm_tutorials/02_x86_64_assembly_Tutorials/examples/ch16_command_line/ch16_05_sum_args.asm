; -----------------------------------------------------------------------------
; Summing numeric arguments -- atoi over argv, printInt for the total
;
; Demonstrates: combining argv walking, atoi, and itoa output
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.8 and 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_05.lst ch16_05_sum_args.asm && ld -g -o ch16_05_sum_args ch16_05_sum_args.o
; Run:    ./ch16_05_sum_args 10 20 12
;         -> 42
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

; ---- rsi = decimal string -> rax --------------------------------------------
atoiArg:
    xor     rax, rax
.next:
    movzx   rdx, byte [rsi]
    test    dl, dl                      ; NUL terminates argv strings
    jz      .done
    imul    rax, rax, 10
    sub     rdx, '0'
    add     rax, rdx
    inc     rsi
    jmp     .next
.done:
    ret

; ---- rdi = value; print with newline ----------------------------------------
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
    mov     r13, qword [rsp]           ; argc
    mov     rbx, 1
    xor     r12, r12                   ; running sum

.argLoop:
    cmp     rbx, r13
    jge     .report
    mov     rsi, qword [rsp + 8 + rbx*8]
    call    atoiArg
    add     r12, rax
    inc     rbx
    jmp     .argLoop

.report:
    mov     rdi, r12
    call    printInt

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
