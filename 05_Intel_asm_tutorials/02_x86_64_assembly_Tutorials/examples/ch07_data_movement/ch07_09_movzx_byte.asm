; -----------------------------------------------------------------------------
; movzx: moving a byte with zero-extension
;
; Demonstrates: movzx reg64, byte [mem] — unsigned byte load
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_09.lst ch07_09_movzx_byte.asm && ld -g -o ch07_09 ch07_09_movzx_byte.o
; Run:    ./ch07_09 ; echo $?        -> exit code: 244
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar        db 0xF4              ; one byte, 0xF4 (unsigned 244)

section .text
global _start
_start:

; A plain 8-bit load would leave garbage in the upper bits of the
; destination, so start with every bit set to make the effect visible.
    mov     rbx, -1                  ; rbx = 0xFFFFFFFFFFFFFFFF

; movzx ("move with zero-extend") copies the small operand into the low
; bits and fills everything above it with ZERO bits — the right choice
; when the byte is an UNSIGNED value.
    movzx   rbx, byte [bVar]         ; rbx = 0x00000000000000F4 = 244

; Contrast: movsx would copy the sign bit instead and yield -12
; (see ch07_11 and ch07_14).

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 244
    syscall
