; -----------------------------------------------------------------------------
; Buffered input -- a mini `cat`: read chunks, echo chunks
;
; Demonstrates: read-side buffering (block reads beat byte reads)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 17.1 - 17.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch17_04.lst ch17_04_buffered_read_cat.asm && ld -g -o ch17_04_buffered_read_cat ch17_04_buffered_read_cat.o
; Run:    printf "multi\nline\ntext\n" | ./ch17_04_buffered_read_cat
;         -> multi
;            line
;            text
;
; Each SYS_read grabs up to 16 bytes at once; read returns 0 at EOF, which
; is the loop's exit condition.
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
STDOUT           equ 1

BUFSIZE          equ 16

section .bss
    ioBuf       resb BUFSIZE

section .text
global _start
_start:
.readLoop:
    mov     rax, SYS_read              ; fill the buffer
    mov     rdi, STDIN
    mov     rsi, ioBuf
    mov     rdx, BUFSIZE
    syscall

    test    rax, rax                   ; 0 = end of input
    jz      last
    jns     .writeChunk                ; negative would be an error
    jmp     last

.writeChunk:
    mov     rdx, rax                   ; echo exactly what arrived
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, ioBuf
    syscall
    jmp     .readLoop

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
