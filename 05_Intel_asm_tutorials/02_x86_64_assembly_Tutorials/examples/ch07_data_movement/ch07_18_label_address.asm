; -----------------------------------------------------------------------------
; A string label is an address: pointing at the first character
;
; Demonstrates: mov reg,label then movzx reg,byte [reg] — pointer basics
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_18.lst ch07_18_label_address.asm && ld -g -o ch07_18 ch07_18_label_address.o
; Run:    ./ch07_18 ; echo $?        -> exit code: 65
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    msg         db "ABC"             ; three bytes: 65, 66, 67 (no NUL needed)

section .text
global _start
_start:

; "msg" with no brackets assembles to the ADDRESS of the first byte —
; a mov of an immediate constant into rax.
    mov     rax, msg                 ; rax = address of 'A'

; Now rax can be used as a pointer: brackets dereference it and the
; size word says to fetch exactly one byte.  movzx widens the character
; 'A' (= 65) into the full register with zero fill.
    movzx   rbx, byte [rax]          ; rbx = 'A' = 65

; rax still holds the address; msg[1] would be at [rax + 1].

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 65
    syscall
