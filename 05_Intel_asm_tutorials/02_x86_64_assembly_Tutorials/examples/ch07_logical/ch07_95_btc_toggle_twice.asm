; -----------------------------------------------------------------------------
; BTC twice restores the original bit: 1 -> 0 -> 1
;
; Demonstrates: btc (bit test and complement) as an invertible bit toggle
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_95.lst ch07_95_btc_toggle_twice.asm && ld -g -o ch07_95 ch07_95_btc_toggle_twice.o
; Run:    ./ch07_95 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; BTC flips the selected bit (old value -> CF), like a one-bit xor.
; Flipping the same bit twice must return it to its original state:
;       bit 0 of rax:  1  --btc-->  0  --btc-->  1
    mov     rax, 1                      ; rax = ...0001 (bit 0 set)
    btc     rax, 0                      ; rax = 0 (bit 0 toggled off)
    btc     rax, 0                      ; rax = 1 (bit 0 toggled back on)

; Verify the bit ended where it started.
    mov     edi, 0                      ; assume the bit is clear
    bt      rax, 0                      ; CF = bit 0 of rax = 1
    jnc     last                        ; not taken (CF = 1)
    mov     edi, 1                      ; CF was set: original value restored

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
