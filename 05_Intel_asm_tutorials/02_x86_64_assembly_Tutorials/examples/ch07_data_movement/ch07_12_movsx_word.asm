; -----------------------------------------------------------------------------
; movsx: moving a word with sign-extension
;
; Demonstrates: movsx reg64, word [mem] — signed word load
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_12.lst ch07_12_movsx_word.asm && ld -g -o ch07_12 ch07_12_movsx_word.o
; Run:    ./ch07_12 ; echo $?        -> exit code: 133
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVar        dw 0xFF85            ; word with the sign bit set

section .text
global _start
_start:

; The sign bit of a word is bit 15; 0xFF85 has it set, so movsx fills
; the upper 48 bits with 1s.  As a signed 16-bit number 0xFF85 is -123,
; and the register receives -123 as a full 64-bit value.
    movsx   rax, word [wVar]         ; rax = 0xFFFFFFFFFFFFFF85 = -123

; Contrast: movzx would have produced the unsigned value 65413.
    mov     rbx, rax                 ; save the full 64-bit result

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; -123 -> exit status = low byte 0x85 = 133
    syscall
