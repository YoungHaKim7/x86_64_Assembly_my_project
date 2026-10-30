; -----------------------------------------------------------------------------
; adc: add-with-carry propagates a carry between qwords
;
; Demonstrates: adc instruction, carry propagation from add to adc
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_35.lst ch07_35_adc_carry_chain.asm && ld -g -o ch07_35 ch07_35_adc_carry_chain.o
; Run:    ./ch07_35 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; step 1: add 1 to the largest qword -> wraps to 0 and sets CF = 1
    mov     rax, 0xFFFFFFFFFFFFFFFF        ; rax = 2^64 - 1 (max qword)
    add     rax, 1                         ; rax = 0, carry out -> CF = 1

; step 2: adc adds its operands PLUS the carry flag:
; rdx = 0 + 0 + CF = 0 + 0 + 1 = 1
    mov     rdx, 0                         ; high qword starts at 0
    adc     rdx, 0                         ; rdx = 1 (consumed the carry)

; the 128-bit pair rdx:rax now holds 0x0000000000000001_0000000000000000,
; i.e. 2^64 -- the carry moved from the low qword into the high qword
    mov     rdi, rdx                       ; exit code = high qword = 1

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
