; -----------------------------------------------------------------------------
; 128-bit shift left: (rdx:rax = 0:0xFFFFFFFFFFFFFFFF) shl 1 -> rdx = 1
;
; Demonstrates: multi-precision shifting with shl plus adc (or rcl) to
;               carry the shifted-out bit into the high qword
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_102.lst ch07_102_shl_128bit.asm && ld -g -o ch07_102 ch07_102_shl_128bit.o
; Run:    ./ch07_102 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qLow        dq 0xFFFFFFFFFFFFFFFF   ; low  64 bits of the 128-bit value
    qHigh       dq 0                    ; high 64 bits of the 128-bit value

section .text
global _start
_start:

; Load the 128-bit value 0:0xFFFFFFFFFFFFFFFF into the rdx:rax pair.
    mov     rax, qword [qLow]           ; rax = 0xFFFFFFFFFFFFFFFF
    mov     rdx, qword [qHigh]          ; rdx = 0

; Shift the pair left one position.  SHL rax,1 pushes the top bit of rax
; into CF and leaves the rest of the pair untouched, so the carry must be
; walked into the high qword separately.  ADC rdx,0 adds CF (here 1) to
; rdx -- "rcl rdx,1" would do the same job since rdx started at 0.
    shl     rax, 1                      ; CF = old bit 63 of rax = 1
    adc     rdx, 0                      ; rdx = 0 + 0 + CF = 1

; The pair now reads 0000...0001 : 1111...1110, i.e. the original
; 128-bit value doubled = 0x1FFFFFFFFFFFFFFFE.
    mov     rdi, rdx                    ; exit status = 1 (the new high qword)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
