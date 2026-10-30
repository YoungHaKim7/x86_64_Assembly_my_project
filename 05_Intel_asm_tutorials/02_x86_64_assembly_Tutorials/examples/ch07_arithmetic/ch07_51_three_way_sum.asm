; -----------------------------------------------------------------------------
; chained add: three-way sum of bytes (100 + 100 + 55 = 255)
;
; Demonstrates: accumulating a sum with repeated add, carry check per step
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_51.lst ch07_51_three_way_sum.asm && ld -g -o ch07_51 ch07_51_three_way_sum.o
; Run:    ./ch07_51 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVal1       db 100                    ; first byte addend
    bVal2       db 100                    ; second byte addend
    bVal3       db 55                     ; third byte addend

section .text
global _start
_start:

; running sum in al: 100 -> 200 -> 255. Each partial sum stays <= 255,
; so no byte carry ever occurs (first add hits 200, second wraps to 255)
    mov     al, byte [bVal1]              ; al = 100 (running sum)
    add     al, byte [bVal2]              ; al = 200, CF = 0
    add     al, byte [bVal3]              ; al = 255, CF = 0

; full result: 255 = 0xFF -- the byte sum that exactly fills the range,
; which also happens to be the widest possible exit code
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 255

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
