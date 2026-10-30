; -----------------------------------------------------------------------------
; Summing 1..10 with the loop instruction
;
; Demonstrates: loop adding the counter itself each pass (10+9+...+1 = 55)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_128.lst ch07_128_loop_sum.asm && ld -g -o ch07_128 ch07_128_loop_sum.o
; Run:    ./ch07_128 ; echo $?       -> exit code: 55
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; The loop instruction's counter rcx is itself a usable value: adding it on
; every pass accumulates 10 + 9 + 8 + ... + 1 as it counts down to zero.
    mov     rcx, 10                 ; counter runs 10, 9, ..., 1
    xor     rbx, rbx                ; rbx = running sum, starts at 0
sumLoop:
    add     rbx, rcx                ; sum += CURRENT counter value
    loop    sumLoop                 ; rcx--; jump back while rcx != 0

; rbx = 10+9+8+7+6+5+4+3+2+1 = 55 (Gauss's famous shortcut, in reverse)

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 55
    syscall
