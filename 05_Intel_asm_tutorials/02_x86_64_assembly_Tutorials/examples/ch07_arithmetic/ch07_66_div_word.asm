; -----------------------------------------------------------------------------
; div (word form): 12345 / 100 -> quotient 123, remainder 45 (dx:ax)
;
; Demonstrates: unsigned word divide div, dx:ax dividend, results in ax/dx
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_66.lst ch07_66_div_word.asm && ld -g -o ch07_66 ch07_66_div_word.o
; Run:    ./ch07_66 ; echo $?        -> exit code: 45
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; For the word form of div the dividend is the register pair dx:ax.  The
; dividend 12345 fits in 16 bits, so dx (the high word) must be cleared.
; The quotient lands in ax and the remainder in dx.
    mov     dx, 0                       ; dx = 0 (high word of dividend)
    mov     ax, 12345                   ; ax = 12345 (low word of dividend)
    mov     bx, 100                     ; bx = divisor
    div     bx                          ; ax = 123, dx = 12345 % 100 = 45

; 100 * 123 + 45 = 12345.  Had dx held garbage, the true quotient could
; exceed 16 bits and the CPU would raise a divide-error exception (#DE).
    movzx   edi, dx                     ; exit status = remainder (45)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (45)
