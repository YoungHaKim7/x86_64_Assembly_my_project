; -----------------------------------------------------------------------------
; Many appends, one flush -- three lines leave in one syscall
;
; Demonstrates: batching output through a buffer
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 17.1 - 17.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch17_02.lst ch17_02_buffer_flush.asm && ld -g -o ch17_02_buffer_flush ch17_02_buffer_flush.o
; Run:    ./ch17_02_buffer_flush
;         -> a
;            b
;            c
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    lineA       db  "a", 10
    lineB       db  "b", 10
    lineC       db  "c", 10

section .bss
    outBuf      resb 64
    fillCount   resq 1

section .text
global _start

; ---- append rdi bytes from rsi ----------------------------------------------
appendStr:
    mov     rcx, rdi
.copy:
    test    rcx, rcx
    jz      .done
    mov     al, byte [rsi]
    mov     rdx, qword [fillCount]
    mov     byte [outBuf + rdx], al
    inc     qword [fillCount]
    inc     rsi
    dec     rcx
    jmp     .copy
.done:
    ret

_start:
    mov     rdi, 2
    mov     rsi, lineA
    call    appendStr
    mov     rdi, 2
    mov     rsi, lineB
    call    appendStr
    mov     rdi, 2
    mov     rsi, lineC
    call    appendStr                  ; 6 bytes buffered, 0 syscalls yet

    mov     rax, SYS_write             ; the only write
    mov     rdi, STDOUT
    mov     rsi, outBuf
    mov     rdx, qword [fillCount]
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
