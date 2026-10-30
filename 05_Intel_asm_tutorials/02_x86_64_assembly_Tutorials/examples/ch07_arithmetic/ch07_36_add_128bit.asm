; -----------------------------------------------------------------------------
; 128-bit addition: add + adc on a rdx:rax pair
;
; Demonstrates: multi-precision addition using add (low) and adc (high)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_36.lst ch07_36_add_128bit.asm && ld -g -o ch07_36 ch07_36_add_128bit.o
; Run:    ./ch07_36 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qLowA       dq 0xFFFFFFFFFFFFFFFE      ; A, low qword
    qHighA      dq 0                       ; A, high qword (A = 2^64 - 2)
    qLowB       dq 3                       ; B, low qword
    qHighB      dq 0                       ; B, high qword (B = 3)

section .text
global _start
_start:

; 128-bit A + B held as rdx:rax. The low qwords are added with add;
; any carry out is folded into the high qwords by adc.
    mov     rax, qword [qLowA]             ; rax = low half of A
    mov     rdx, qword [qHighA]            ; rdx = high half of A

    add     rax, qword [qLowB]             ; low: 0xFFFFFFFFFFFFFFFE + 3
                                            ;      -> rax = 1, CF = 1
    adc     rdx, qword [qHighB]            ; high: 0 + 0 + CF -> rdx = 1

; full 128-bit result: 0x0000000000000001_0000000000000001
; (A + B = (2^64 - 2) + 3 = 2^64 + 1)
    mov     rdi, rdx                       ; exit = high qword & 0xFF = 1

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
