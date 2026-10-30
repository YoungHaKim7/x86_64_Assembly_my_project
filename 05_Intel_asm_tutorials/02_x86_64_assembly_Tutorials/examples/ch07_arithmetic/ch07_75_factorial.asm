; -----------------------------------------------------------------------------
; Factorial (iterative): 5! = 5*4*3*2*1 = 120
;
; Demonstrates: imul inside a counting loop, loop bookkeeping with
;               dec / conditional jump
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_75.lst ch07_75_factorial.asm && ld -g -o ch07_75 ch07_75_factorial.o
; Run:    ./ch07_75 ; echo $?        -> exit code: 120
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qN          dq 5                    ; n, the factorial argument

section .bss
    qResult     resq 1                  ; the factorial result

section .text
global _start
_start:

; result = 1;  while (n > 1)  result = result * n--;
    mov     rcx, qword [qN]             ; rcx = n = 5 (loop counter)
    mov     rax, 1                      ; rax = running product = 1

factorialLoop:
    cmp     rcx, 1                      ; multiplier still above 1?
    jle     factorialDone               ; no: product complete
    imul    rax, rcx                    ; result = result * n
    dec     rcx                         ; next smaller multiplier
    jmp     factorialLoop               ; repeat until rcx = 1

factorialDone:
    mov     qword [qResult], rax        ; store 5! = 120

; Product trail: 1*5=5, 5*4=20, 20*3=60, 60*2=120.  Exit with 120.
    movzx   edi, byte [qResult]         ; exit status = 120 (fits in a byte)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (120)
