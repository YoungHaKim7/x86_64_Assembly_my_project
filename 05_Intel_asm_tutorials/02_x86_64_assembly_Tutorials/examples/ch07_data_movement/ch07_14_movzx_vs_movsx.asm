; -----------------------------------------------------------------------------
; movzx vs movsx: the same byte, two interpretations
;
; Demonstrates: zero- vs sign-extension of one byte, compared side by side
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_14.lst ch07_14_movzx_vs_movsx.asm && ld -g -o ch07_14 ch07_14_movzx_vs_movsx.o
; Run:    ./ch07_14 ; echo $?        -> exit code: 224
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar        db 0xF0              ; bit 7 set: negative if signed

section .text
global _start
_start:

; The BITS loaded are identical in both registers — only the fill of the
; upper bits differs, and that is decided by the instruction chosen:
    movzx   rbx, byte [bVar]         ; rbx = 0x00000000000000F0 =  240 (unsigned)
    movsx   rcx, byte [bVar]         ; rcx = 0xFFFFFFFFFFFFFFF0 =  -16 (signed)

; Adding the two views:  240 + (-16) = 224.  A convenient way to see
; both values in one exit status.
    add     rbx, rcx                 ; rbx = 224

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 224
    syscall
