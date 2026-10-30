; -----------------------------------------------------------------------------
; mul (double-word form): 3000000000 * 2 = 6000000000, product in edx:eax
;
; Demonstrates: unsigned double-word multiply mul, 64-bit product in edx:eax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_56.lst ch07_56_mul_dword_edxeax.asm && ld -g -o ch07_56 ch07_56_mul_dword_edxeax.o
; Run:    ./ch07_56 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVal1       dd 3000000000           ; double-word multiplicand (fits unsigned)
    dVal2       dd 2                    ; double-word multiplier

section .text
global _start
_start:

; For the double-word form of mul the multiplicand MUST be in eax.  The
; product of two double-words can need up to 64 bits, so it is placed in
; the edx:eax register pair:  edx high, eax low.
    mov     eax, dword [dVal1]          ; eax = 3000000000 (multiplicand)
    mov     ebx, dword [dVal2]          ; ebx = 2 (multiplier)
    mul     ebx                         ; edx:eax = 3000000000 * 2

; 6000000000 decimal = 0x1_65A0BC00, which does NOT fit in 32 bits:
;   edx = 0x00000001  (high double-word = 1)
;   eax = 0x65A0BC00  (low double-word)
; The non-zero edx proves the 32-bit product spilled into edx:eax.
    mov     edi, edx                    ; exit status = high double-word (1)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
