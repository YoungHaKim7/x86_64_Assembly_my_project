; -----------------------------------------------------------------------------
; add: byte wraparound sets the carry flag (250 + 6)
;
; Demonstrates: unsigned overflow of a byte add detected with CF and jc
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_37_add_carry_flag.lst ch07_37_add_carry_flag.asm && ld -g -o ch07_37_add_carry_flag ch07_37_add_carry_flag.o
; Run:    ./ch07_37_add_carry_flag ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 250 + 6 = 256 = 0x100, which does not fit in 8 bits:
; the byte result wraps to 0x00 and the carry flag is set
    mov     al, 250                        ; al = 250
    add     al, 6                          ; al = 0 (wrapped), CF = 1
    jc      wrapped                        ; carry out -> byte range exceeded

    mov     rdi, EXIT_SUCCESS              ; exit code 0: no wrap
    jmp     last

wrapped:
    mov     rdi, 1                         ; exit code 1: wrap detected

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
