; -----------------------------------------------------------------------------
; movsxd: sign-extending a dword into a 64-bit register
;
; Demonstrates: movsxd reg64, dword [mem] — 64-bit-only sign extension
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_13.lst ch07_13_movsxd_dword.asm && ld -g -o ch07_13 ch07_13_movsxd_dword.o
; Run:    ./ch07_13 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar        dd 0xFFFFFFFF        ; dword with the sign bit set

section .text
global _start
_start:

; For dword sources the instruction is movsxd (movsx does not accept a
; 32-bit source in 64-bit mode).  Bit 31 of 0xFFFFFFFF is set, so the
; upper 32 bits are filled with 1s and the register holds -1.
    movsxd  rax, dword [dVar]        ; rax = 0xFFFFFFFFFFFFFFFF = -1

; Note the trap this instruction avoids: a 32-bit mov zero-extends, so
;       mov     eax, dword [dVar]    ; would give +4294967295, NOT -1
    mov     rbx, rax                 ; save the full 64-bit result

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; -1 -> exit status = low byte 0xFF = 255
    syscall
