; -----------------------------------------------------------------------------
; Buffered write -- assemble a line in memory, flush once
;
; Demonstrates: why buffering exists: one syscall instead of many
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 17.1 - 17.2 (Why Buffer?)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch17_01.lst ch17_01_buffered_write.asm && ld -g -o ch17_01_buffered_write ch17_01_buffered_write.o
; Run:    ./ch17_01_buffered_write
;         -> hello buffered
;
; appendChar copies into the buffer and bumps the fill count; exactly ONE
; SYS_write happens at the end, no matter how many appends preceded it.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    helloStr    db  "hello "
    helloLen    equ $-helloStr
    bufStr      db  "buffered", 10

section .bss
    outBuf      resb 64
    fillCount   resq 1                  ; bytes currently in the buffer

section .text
global _start

; ---- append rdi bytes from rsi into the buffer ------------------------------
appendStr:
    mov     rcx, rdi                   ; byte count
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
    mov     rdi, helloLen              ; buffer "hello "
    mov     rsi, helloStr
    call    appendStr

    mov     rdi, 9                     ; buffer "buffered\n"
    mov     rsi, bufStr
    call    appendStr

    ; ---- single flush -------------------------------------------------------
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, outBuf
    mov     rdx, qword [fillCount]
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
