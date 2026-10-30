; -----------------------------------------------------------------------------
; cdq + idiv (double-word): eax = -100, idiv by 3 -> quotient -33
;
; Demonstrates: cdq sign-extending eax into edx:eax before a signed
;               double-word divide
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_72.lst ch07_72_cdq_idiv_dword.asm && ld -g -o ch07_72 ch07_72_cdq_idiv_dword.o
; Run:    ./ch07_72 ; echo $?        -> exit code: 223
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; cdq (convert double to quad) is the 32-bit companion of cqo: it copies
; the sign bit of eax into every bit of edx, building the 64-bit signed
; dividend edx:eax that the double-word idiv expects.
    mov     eax, -100                   ; eax = -100 (0xFFFFFF9C)
    cdq                                ; edx = 0xFFFFFFFF (sign extension)
    mov     ebx, 3                      ; ebx = 3
    idiv    ebx                         ; eax = -33, edx = -1

; Quotient -33 = 0xFFFFFFDF in 32-bit two's complement.  The exit status
; keeps only the low byte 0xDF = 223 decimal.  (Check: 3 * -33 + -1 = -100.)
    movzx   edi, al                     ; exit status = 223 (low byte of -33)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (223)
