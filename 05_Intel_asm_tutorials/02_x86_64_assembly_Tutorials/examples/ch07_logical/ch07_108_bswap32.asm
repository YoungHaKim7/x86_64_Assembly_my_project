; -----------------------------------------------------------------------------
; BSWAP a dword: 0x12345678 -> 0x78563412 (little <-> big endian)
;
; Demonstrates: bswap reversing the byte order of a 32-bit register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_108.lst ch07_108_bswap32.asm && ld -g -o ch07_108 ch07_108_bswap32.o
; Run:    ./ch07_108 ; echo $?        -> exit code: 18
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar        dd 0x12345678            ; stored little-endian: 78 56 34 12

section .text
global _start
_start:

; BSWAP reverses all four bytes of a 32-bit register in one instruction:
;       0x12345678  ->  0x78563412
; x86 is little-endian, so bswap is the standard way to convert to or
; from the big-endian byte order used by network protocols.
    mov     eax, dword [dVar]           ; eax = 0x12345678
    bswap   eax                         ; eax = 0x78563412

; Swapping twice returns the original -- the exit code uses the low byte
; of the single swap (0x12 = 18); the full swapped value stays in rbx.
    mov     ebx, eax                    ; rbx = 0x0000000078563412 (kept)
    movzx   rdi, al                     ; rdi = 0x12 = 18

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
