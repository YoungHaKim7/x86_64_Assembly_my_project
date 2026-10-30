; -----------------------------------------------------------------------------
; inc: increment a byte (254 -> 255)
;
; Demonstrates: inc instruction with byte operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_43.lst ch07_43_inc_byte.asm && ld -g -o ch07_43 ch07_43_inc_byte.o
; Run:    ./ch07_43 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bCount      db 254                    ; byte counter one below its max

section .text
global _start
_start:

; inc adds 1 to its operand: 254 + 1 = 255 = 0xFF, still fits a byte
    mov     al, byte [bCount]             ; al = 254
    inc     al                            ; al = 255

; inc is the compact, flag-friendly form of "add operand, 1"
    inc     byte [bCount]                 ; memory form: bCount = 255 too

; exit with the register result: 255
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 255

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
