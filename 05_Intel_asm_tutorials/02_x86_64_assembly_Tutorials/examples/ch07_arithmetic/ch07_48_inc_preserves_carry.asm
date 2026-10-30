; -----------------------------------------------------------------------------
; inc/dec quirk: they do NOT touch the carry flag
;
; Demonstrates: inc leaves CF unchanged (documented architecture quirk)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_48_inc_preserves_carry.lst ch07_48_inc_preserves_carry.asm && ld -g -o ch07_48_inc_preserves_carry ch07_48_inc_preserves_carry.o
; Run:    ./ch07_48_inc_preserves_carry ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; step 1: force CF = 1 with an add that carries out of a byte
    mov     al, 250                       ; al = 250
    add     al, 6                         ; al = 0 (wrapped), CF = 1

; step 2: inc modifies its operand but, unlike "add ..., 1", it does NOT
; update CF. This is deliberate: inc/dec are designed so a loop counter
; can be bumped in the middle of multi-precision add/adc sequences
; without destroying the carry chain. (inc DOES update ZF/SF/OF/PF.)
    mov     bl, 41                        ; bl = 41 (unrelated counter)
    inc     bl                            ; bl = 42, CF still 1 from above

; step 3: the carry survived the inc -- prove it by branching on CF
    jc      carrySurvived                 ; still taken -> CF was preserved

    mov     rdi, EXIT_SUCCESS             ; exit code 0: CF was cleared
    jmp     last

carrySurvived:
    mov     rdi, 1                        ; exit code 1: CF unchanged by inc

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
