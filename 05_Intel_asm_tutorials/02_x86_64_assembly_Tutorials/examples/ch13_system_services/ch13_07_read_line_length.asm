; -----------------------------------------------------------------------------
; How many bytes did read return?
;
; Demonstrates: SYS_read return value used as data
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.4 (Console Input)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_07.lst ch13_07_read_line_length.asm && ld -g -o ch13_07_read_line_length ch13_07_read_line_length.o
; Run:    echo "hello" | ./ch13_07_read_line_length ; echo $?
;         -> 6           (5 letters + newline)
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0

section .bss
    inBuf       resb 32

section .text
global _start
_start:
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 32
    syscall                             ; rax = byte count

last:
    mov     rdi, rax                    ; exit status = bytes read (6)
    mov     rax, SYS_exit
    syscall
