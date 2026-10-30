; -----------------------------------------------------------------------------
; movsx: moving a byte with sign-extension
;
; Demonstrates: movsx reg64, byte [mem] — signed byte load
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_11.lst ch07_11_movsx_byte.asm && ld -g -o ch07_11 ch07_11_movsx_byte.o
; Run:    ./ch07_11 ; echo $?        -> exit code: 128
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar        db 0x80              ; byte with the sign bit set

section .text
global _start
_start:

; movsx ("move with sign-extend") copies the small operand and then
; replicates its SIGN BIT (bit 7 for a byte) into every higher bit.
; 0x80 has bit 7 set, so all 56 upper bits become 1s: the byte is
; interpreted as the NEGATIVE value -128.
    movsx   rax, byte [bVar]         ; rax = 0xFFFFFFFFFFFFFF80 = -128

; Contrast: movzx would have given the unsigned value 128 instead
; (see ch07_09 and ch07_14).
    mov     rbx, rax                 ; save the full 64-bit result

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; -128 -> exit status = low byte 0x80 = 128
    syscall
