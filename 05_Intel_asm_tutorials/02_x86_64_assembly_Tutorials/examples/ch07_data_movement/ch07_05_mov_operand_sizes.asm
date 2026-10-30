; -----------------------------------------------------------------------------
; mov operand sizes: byte, word, and dword destinations
;
; Demonstrates: how 8/16/32-bit mov instructions affect a 64-bit register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_05.lst ch07_05_mov_operand_sizes.asm && ld -g -o ch07_05 ch07_05_mov_operand_sizes.o
; Run:    ./ch07_05 ; echo $?        -> exit code: 171
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 0xAB              ; byte operand  (0xAB)
    wVar1       dw 0xABCD            ; word operand  (0xABCD)
    dVar1       dd 0xAABBCCDD        ; dword operand (0xAABBCCDD)

section .text
global _start
_start:

; A byte-sized destination touches ONLY the low 8 bits of the register:
    mov     rbx, -1                  ; rbx = 0xFFFFFFFFFFFFFFFF (all bits set)
    mov     bl, byte [bVar1]         ; rbx = 0xFFFFFFFFFFFFFFAB (only bl changed)

; A word-sized destination touches ONLY the low 16 bits:
    mov     rcx, -1                  ; rcx = 0xFFFFFFFFFFFFFFFF
    mov     cx, word [wVar1]         ; rcx = 0xFFFFFFFFFFFFABCD (only cx changed)

; A dword-sized destination writes eax/ebx/... AND ZEROES the upper half
; of the 64-bit register — 32-bit writes always zero-extend:
    mov     rdx, -1                  ; rdx = 0xFFFFFFFFFFFFFFFF
    mov     edx, dword [dVar1]       ; rdx = 0x00000000AABBCCDD (upper half gone!)

; Exit with the byte's unsigned value: 0xAB = 171.  Only the low 8 bits
; of the exit status survive anyway, so store the byte into dil.
    xor     rdi, rdi                 ; rdi = 0 (clear the whole register)
    mov     dil, byte [bVar1]        ; rdi = 171 (only dil changed)

last:
    mov     rax, SYS_exit            ; call code for exit
    syscall                           ; exit status already in rdi (171)
