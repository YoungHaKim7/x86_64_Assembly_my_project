; -----------------------------------------------------------------------------
; div (quadword): 137 / 10 -> quotient 13, remainder 7
;
; Demonstrates: unsigned quadword divide div, quotient in rax, remainder in
;               rdx, rdx:rax dividend convention
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_64.lst ch07_64_div_qword.asm && ld -g -o ch07_64 ch07_64_div_qword.o
; Run:    ./ch07_64 ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; The quadword form of div divides the 128-bit value in rdx:rax by the
; operand.  Since 137 is a plain 64-bit dividend, rdx MUST be zeroed first
; -- otherwise left-over bits in rdx would become the high half of the
; dividend and change the answer entirely.
    mov     rax, 137                    ; rax = low 64 bits of dividend
    xor     rdx, rdx                    ; rdx = 0 (high 64 bits of dividend)
    mov     rbx, 10                     ; rbx = divisor
    div     rbx                         ; rax = 137/10 = 13, rdx = 137%10 = 7

; Unsigned division truncates: 10 * 13 + 7 = 137.  The remainder is the
; modulo result, a natural exit status (7).
    movzx   edi, dl                     ; exit status = remainder (7)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (7)
