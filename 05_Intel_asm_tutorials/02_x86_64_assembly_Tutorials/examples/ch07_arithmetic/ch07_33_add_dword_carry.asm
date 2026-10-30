; -----------------------------------------------------------------------------
; add: dword addition past the signed limit (0x7FFFFFFF + 1 = 0x80000000)
;
; Demonstrates: add with dword operands, overflow flag (OF) vs carry flag (CF)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_33.lst ch07_33_add_dword_carry.asm && ld -g -o ch07_33 ch07_33_add_dword_carry.o
; Run:    ./ch07_33 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 0x7FFFFFFF             ; largest positive signed dword

section .text
global _start
_start:

; 0x7FFFFFFF + 1 = 0x80000000. Note WHICH flag reports the trouble:
;   CF = 0 -- the unsigned result 0x80000000 still fits in 32 bits, so
;              there is no carry out of the register (jc would NOT jump);
;   OF = 1 -- signed reading: positive + 1 became "negative", which is
;              impossible in valid arithmetic -> signed overflow.
    mov     eax, dword [dVar1]            ; eax = 0x7FFFFFFF (2147483647)
    add     eax, 1                        ; eax = 0x80000000, OF = 1, CF = 0
    jo      overflowDetected              ; OF set -> signed overflow occurred

; not reached in this demo (kept to show the fall-through exit path)
    mov     rdi, EXIT_SUCCESS             ; exit code 0: no overflow
    jmp     last

overflowDetected:
    mov     rdi, 1                        ; exit code 1: overflow was detected

; For a true unsigned CARRY at dword width you would add past 0xFFFFFFFF
; (e.g. 0xFFFFFFFF + 1 -> 0 with CF = 1, detected with jc); the byte and
; qword width versions of that case are shown in ch07_37 and ch07_35.

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
