; -----------------------------------------------------------------------------
; A small addition sets neither CF nor OF
;
; Demonstrates: 5 + 5 fits in a signed byte, so both overflow flags stay 0
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.2 (Unsigned and Signed Addition)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_08_no_flags.lst ch03_08_no_flags.asm && ld -g -o ch03_08_no_flags ch03_08_no_flags.o
; Run:    ./ch03_08_no_flags ; echo $?        -> exit code: 0
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    xor     rdi, rdi                        ; result 0 unless some flag was set
    mov     al, 5
    add     al, 5                           ; al = 10: CF = 0 (no wrap) and OF = 0
    jc      flagWasSet                      ; unsigned overflow check
    jo      flagWasSet                      ; signed overflow check
    jmp     last                            ; both clear -> rdi stays 0

flagWasSet:
    mov     rdi, 1                          ; (unreachable for 5 + 5)

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
