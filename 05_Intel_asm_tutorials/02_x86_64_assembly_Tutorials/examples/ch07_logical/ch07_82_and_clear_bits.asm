; -----------------------------------------------------------------------------
; AND to clear the upper bits of a byte: 0xFF and 0x3F -> 0x3F (63)
;
; Demonstrates: and instruction zeroing selected bits (top two bits here)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_82.lst ch07_82_and_clear_bits.asm && ld -g -o ch07_82 ch07_82_and_clear_bits.o
; Run:    ./ch07_82 ; echo $?        -> exit code: 63
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar        db 0xFF                  ; all eight bits set

section .text
global _start
_start:

; Mask 0x3F = 0011 1111 keeps the low six bits and clears the top two.
; Whatever the upper bits held, the result is guaranteed <= 63:
;
;       0xFF = 1111 1111
;   AND 0x3F = 0011 1111
;       -----------------
;       0x3F = 0011 1111   (63 -- bits 7 and 6 cleared)
    mov     al, byte [bVar]             ; al = 1111 1111
    and     al, 0x3F                    ; al = 0011 1111 = 63
    mov     byte [bVar], al             ; store the masked byte back

last:
    movzx   rdi, byte [bVar]            ; exit status = 63
    mov     rax, SYS_exit               ; call code for exit
    syscall
