; -----------------------------------------------------------------------------
; Integer power (iterative): 3^4 = 81
;
; Demonstrates: repeated imul in a counting loop (exponentiation by
;               successive multiplication)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_78.lst ch07_78_power.asm && ld -g -o ch07_78 ch07_78_power.o
; Run:    ./ch07_78 ; echo $?        -> exit code: 81
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qBase       dq 3                    ; base
    qExponent   dq 4                    ; exponent (loop count)

section .text
global _start
_start:

; result = 1;  repeat exponent times:  result = result * base.
    mov     rax, 1                      ; rax = running result = 1
    mov     rbx, qword [qBase]          ; rbx = base = 3
    mov     rcx, qword [qExponent]      ; rcx = exponent = 4

powerLoop:
    imul    rax, rbx                    ; result = result * base
    dec     rcx                         ; one factor fewer remaining
    jnz     powerLoop                   ; repeat until rcx = 0

; Product trail: 1*3=3, 3*3=9, 9*3=27, 27*3=81.  rax = 3^4 = 81.
    movzx   edi, al                     ; exit status = 81

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (81)
