; -----------------------------------------------------------------------------
; div (byte form): ax = 137, div bl (10) -> al = 13, ah = 7
;
; Demonstrates: unsigned byte divide div, quotient in al, remainder in ah
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_65.lst ch07_65_div_byte.asm && ld -g -o ch07_65 ch07_65_div_byte.o
; Run:    ./ch07_65 ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; For the byte form of div the ENTIRE ax register is the dividend (not just
; al), and the results pack back into ax: quotient in al, remainder in ah.
; Loading ax with 137 sets ah = 0 and al = 137, giving the intended
; 16-bit dividend 0x0089.  The quotient 13 and remainder 7 both fit in
; bytes, so no divide fault can occur.
    mov     ax, 137                     ; dividend: full ax (ah=0, al=137)
    mov     bl, 10                      ; divisor
    div     bl                          ; al = 137/10 = 13, ah = 137%10 = 7

; The remainder lands in the high byte of ax -- extract it for the status.
    movzx   edi, ah                     ; exit status = remainder (7)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (7)
