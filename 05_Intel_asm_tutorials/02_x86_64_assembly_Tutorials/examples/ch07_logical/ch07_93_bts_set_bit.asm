; -----------------------------------------------------------------------------
; BTS: set a bit and verify it -- bts rax,4 then bt -> CF=1
;
; Demonstrates: bts (bit test and set) turning a bit on, checked with bt
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_93.lst ch07_93_bts_set_bit.asm && ld -g -o ch07_93 ch07_93_bts_set_bit.o
; Run:    ./ch07_93 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; BTS stores 1 into the selected bit (old value goes to CF).  Starting
; from zero, bit 4 becomes 1 and rax ends up 0x10 = 16.
    xor     rax, rax                    ; rax = 0 (all bits clear)
    bts     rax, 4                      ; rax = 0x10 (bit 4 now set)

; Confirm with a plain BT that the bit really is on.
    mov     edi, 0                      ; assume the bit is clear
    bt      rax, 4                      ; CF = bit 4 of rax = 1
    jnc     last                        ; not taken (CF = 1)
    mov     edi, 1                      ; CF was set: bts worked

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
