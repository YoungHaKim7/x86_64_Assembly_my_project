; -----------------------------------------------------------------------------
; atoi, single digit -- a character becomes a number
;
; Demonstrates: subtracting '0' to convert an ASCII digit
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_08.lst ch13_08_atoi_single_digit.asm && ld -g -o ch13_08_atoi_single_digit ch13_08_atoi_single_digit.o
; Run:    echo "7" | ./ch13_08_atoi_single_digit ; echo $?
;         -> 7
;
; ASCII digits are contiguous: '7' (0x37) - '0' (0x30) = 7.
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0

section .bss
    inBuf       resb 8

section .text
global _start
_start:
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 8
    syscall

    movzx   rax, byte [inBuf]          ; the digit character
    sub     rax, '0'                   ; '7' -> 7

last:
    mov     rdi, rax                    ; exit status = 7
    mov     rax, SYS_exit
    syscall
