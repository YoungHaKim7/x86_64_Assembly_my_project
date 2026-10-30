; -----------------------------------------------------------------------------
; Read from standard input and echo it back
;
; Demonstrates: SYS_read (0), .bss buffer, byte-count-driven write
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.4 (Console Input)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_06.lst ch13_06_read_stdin.asm && ld -g -o ch13_06_read_stdin ch13_06_read_stdin.o
; Run:    echo "echo" | ./ch13_06_read_stdin
;         -> echo
;
; read returns the number of bytes actually received in rax -- that count
; (not the buffer size) is what the echo write must use.
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
STDOUT           equ 1

section .bss
    inBuf       resb 32                ; input buffer

section .text
global _start
_start:
    mov     rax, SYS_read              ; service: read
    mov     rdi, STDIN                 ; arg 1: standard input
    mov     rsi, inBuf                 ; arg 2: where to put bytes
    mov     rdx, 32                    ; arg 3: at most 32 bytes
    syscall
    mov     rdx, rax                   ; rdx = bytes actually read

    mov     rax, SYS_write             ; echo exactly that many bytes
    mov     rdi, STDOUT
    mov     rsi, inBuf
    syscall                             ; rdx already holds the count

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
