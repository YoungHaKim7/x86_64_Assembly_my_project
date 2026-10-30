; -----------------------------------------------------------------------------
; div (double-word form): 1000000 / 7 -> quotient 142857, remainder 1
;
; Demonstrates: unsigned double-word divide div, edx:eax dividend
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_67.lst ch07_67_div_dword.asm && ld -g -o ch07_67 ch07_67_div_dword.o
; Run:    ./ch07_67 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; For the double-word form of div the dividend is the register pair
; edx:eax, the quotient lands in eax, and the remainder in edx.
    mov     edx, 0                      ; edx = 0 (high double-word)
    mov     eax, 1000000                ; eax = 1000000 (low double-word)
    mov     ebx, 7                      ; ebx = divisor
    div     ebx                         ; eax = 142857, edx = 1000000 % 7

; 7 * 142857 = 999999, so the remainder is 1: the classic "million mod 7".
    mov     edi, edx                    ; exit status = remainder (1)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
