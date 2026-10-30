; -----------------------------------------------------------------------------
; BT on a register: bt rax,3 with rax=8 -> CF=1, jc taken
;
; Demonstrates: bt (bit test) copying one selected bit into the carry flag
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_91.lst ch07_91_bt_register.asm && ld -g -o ch07_91 ch07_91_bt_register.o
; Run:    ./ch07_91 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; BT (bit test) reads a single bit -- here bit 3 of rax -- into CF and
; leaves the register untouched.  rax = 8 = 2^3, so bit 3 is 1.
    mov     rax, 8                      ; rax = 0000 ... 1000 (bit 3 set)
    mov     edi, 0                      ; assume the bit is clear
    bt      rax, 3                      ; CF = bit 3 of rax = 1
    jnc     last                        ; not taken (CF = 1)
    mov     edi, 1                      ; CF was set: bit 3 is 1

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
