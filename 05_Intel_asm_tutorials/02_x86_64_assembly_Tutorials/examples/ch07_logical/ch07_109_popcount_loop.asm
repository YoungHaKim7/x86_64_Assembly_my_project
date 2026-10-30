; -----------------------------------------------------------------------------
; Population count by loop: 0xB6 (1011 0110) has 5 one bits
;
; Demonstrates: shr + adc looping to count the set bits of a byte
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_109.lst ch07_109_popcount_loop.asm && ld -g -o ch07_109 ch07_109_popcount_loop.o
; Run:    ./ch07_109 ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Strategy: shift the byte right one bit at a time.  Each SHR drops the
; current lowest bit into CF, and ADC adds that CF (0 or 1) to a counter
; -- eight iterations count every 1 bit.
    mov     al, 0xB6                    ; al = 1011 0110 (5 one bits)
    xor     bl, bl                      ; bl = bit count = 0
    mov     ecx, 8                      ; one iteration per bit

countLoop:
    shr     al, 1                       ; lowest bit -> CF, 0 shifts in
    adc     bl, 0                       ; bl += CF
    dec     ecx                         ; one bit processed
    jnz     countLoop                   ; until all 8 are counted

; bl = 5: bits set are 7, 5, 4, 2, 1.
    movzx   rdi, bl                     ; exit status = 5

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
