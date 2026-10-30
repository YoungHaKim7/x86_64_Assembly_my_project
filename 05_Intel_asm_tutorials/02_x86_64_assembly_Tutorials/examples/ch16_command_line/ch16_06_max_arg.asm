; -----------------------------------------------------------------------------
; Largest numeric argument
;
; Demonstrates: atoi plus unsigned-compare selection loop
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 16.3 - 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_06.lst ch16_06_max_arg.asm && ld -g -o ch16_06_max_arg ch16_06_max_arg.o
; Run:    ./ch16_06_max_arg 5 77 19 ; echo $?        -> exit code: 77
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; ---- rsi = decimal string -> rax --------------------------------------------
atoiArg:
    xor     rax, rax
.next:
    movzx   rdx, byte [rsi]
    test    dl, dl
    jz      .done
    imul    rax, rax, 10
    sub     rdx, '0'
    add     rax, rdx
    inc     rsi
    jmp     .next
.done:
    ret

_start:
    mov     r13, qword [rsp]           ; argc
    mov     rbx, 1
    xor     r12, r12                   ; max so far (0)

.argLoop:
    cmp     rbx, r13
    jge     last
    mov     rsi, qword [rsp + 8 + rbx*8]
    call    atoiArg
    cmp     rax, r12                   ; bigger than current max?
    jbe     .nextArg                   ; unsigned compare (all inputs >= 0)
    mov     r12, rax
.nextArg:
    inc     rbx
    jmp     .argLoop

last:
    mov     rdi, r12                    ; exit status = max argument
    mov     rax, SYS_exit
    syscall
