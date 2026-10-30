; -----------------------------------------------------------------------------
; jc: jump if the carry flag signals unsigned overflow
;
; Demonstrates: byte add 255 + 1 -> CF = 1 -> jc taken
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_123.lst ch07_123_jc_carry.asm && ld -g -o ch07_123 ch07_123_jc_carry.o
; Run:    ./ch07_123 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 255                ; 255: the largest unsigned byte

section .text
global _start
_start:

; Adding 1 to 255 produces 0x100, which does not fit in 8 bits: al keeps
; the low byte 0 and the carry out sets CF = 1.  CF is the UNSIGNED
; "ran out of bits" flag (jc is the same instruction as jb and jnae).
    mov     al, byte [bVar1]        ; al = 255
    mov     ebx, 0                  ; result if the jump is not taken
    add     al, 1                   ; al = 0 with a carry out -> CF = 1
    jc      carried                 ; taken: carry out of the byte
    jmp     last                    ; (skipped by the jc)

carried:
    mov     ebx, 1                  ; report that jc fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
