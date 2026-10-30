; -----------------------------------------------------------------------------
; Round up to the next power of two: 70 -> 128
;
; Demonstrates: the classic dec / smear-bits-with-shr+or / inc trick
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_110.lst ch07_110_round_up_pow2.asm && ld -g -o ch07_110 ch07_110_round_up_pow2.o
; Run:    ./ch07_110 ; echo $?        -> exit code: 128
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Idea: after n-1, OR the value with shifted copies of itself so every
; bit below the highest set bit becomes 1 (all ones = 2^k - 1), then +1
; gives the next power of two.  Doubling shift distances 1,2,4,8,16
; smears all 32 bits in five steps.
    mov     eax, 70                     ; eax = 70 = 0100 0110
    dec     eax                         ; eax = 69 = 0100 0101

    mov     ebx, eax
    shr     ebx, 1                      ; 69 >> 1
    or      eax, ebx                    ; eax = 0100 0111 (0x47)

    mov     ebx, eax
    shr     ebx, 2
    or      eax, ebx                    ; eax = 0111 1111 (0x7F)

    mov     ebx, eax
    shr     ebx, 4
    or      eax, ebx                    ; stays 0x7F (all low bits now 1)

    mov     ebx, eax
    shr     ebx, 8
    or      eax, ebx                    ; stays 0x7F (smear complete)

    mov     ebx, eax
    shr     ebx, 16
    or      eax, ebx                    ; stays 0x7F (covers a 32-bit value)

    inc     eax                         ; eax = 0x80 = 128 = next power of 2

last:
    mov     rdi, rax                    ; exit status = 128
    mov     rax, SYS_exit               ; call code for exit
    syscall
