; -----------------------------------------------------------------------------
; Collatz steps -- while-loop until the sequence reaches 1
;
; Demonstrates: open-ended while loop with parity branch inside
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_155.lst ch07_155_collatz.asm && ld -g -o ch07_155_collatz ch07_155_collatz.o
; Run:    ./ch07_155_collatz ; echo $?        -> exit code: 111
;
; Collatz rule: n even -> n/2; n odd -> 3n+1.  Starting at 27 the
; sequence climbs to 9232 before falling to 1, taking 111 steps.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 27                    ; starting value
    xor     rbx, rbx                   ; step count

.stepLoop:
    cmp     rax, 1
    je      last                       ; reached 1 -> stop
    test    al, 1                      ; odd?
    jnz     .oddStep
    shr     rax, 1                     ; even: halve
    jmp     .countStep
.oddStep:
    lea     rax, [rax + rax*2 + 1]     ; odd: 3n+1 in one instruction
.countStep:
    inc     rbx
    jmp     .stepLoop

last:
    mov     rdi, rbx                   ; exit status = 111
    mov     rax, SYS_exit
    syscall
