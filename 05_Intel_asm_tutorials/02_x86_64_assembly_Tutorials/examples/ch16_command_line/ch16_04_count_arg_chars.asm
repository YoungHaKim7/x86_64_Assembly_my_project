; -----------------------------------------------------------------------------
; Total argument length -- summing strlen over argv
;
; Demonstrates: nested scan loops over the argument vector
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 16.3 - 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_04.lst ch16_04_count_arg_chars.asm && ld -g -o ch16_04_count_arg_chars ch16_04_count_arg_chars.o
; Run:    ./ch16_04_count_arg_chars abc de ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     r13, qword [rsp]           ; argc
    mov     rbx, 1                     ; argument index
    xor     r12, r12                   ; total characters

.argLoop:
    cmp     rbx, r13
    jge     done
    mov     rsi, qword [rsp + 8 + rbx*8]

.lenLoop:
    cmp     byte [rsi], 0
    je      .nextArg
    inc     r12
    inc     rsi
    jmp     .lenLoop
.nextArg:
    inc     rbx
    jmp     .argLoop

done:
    mov     rdi, r12                    ; exit status = character total

last:
    mov     rax, SYS_exit
    syscall
