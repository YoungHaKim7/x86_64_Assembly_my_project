; -----------------------------------------------------------------------------
; Sum 1..n with a loop: 1+2+...+20 = 210
;
; Demonstrates: accumulating addition in a countdown loop, result used as
;               the exit status
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_79.lst ch07_79_sum_1_to_n.asm && ld -g -o ch07_79 ch07_79_sum_1_to_n.o
; Run:    ./ch07_79 ; echo $?        -> exit code: 210
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qN          dq 20                   ; upper limit n

section .bss
    qSum        resq 1                  ; the accumulated sum

section .text
global _start
_start:

; sum = 0;  for (i = n; i >= 1; i--)  sum = sum + i;
    mov     rcx, qword [qN]             ; rcx = i = 20 (counts down)
    mov     rax, 0                      ; rax = sum = 0

sumLoop:
    add     rax, rcx                    ; sum = sum + i
    dec     rcx                         ; next smaller term
    jnz     sumLoop                     ; repeat until rcx = 0

    mov     qword [qSum], rax           ; store 1+2+...+20 = 210

; (Gauss's shortcut n*(n+1)/2 = 20*21/2 = 210 gives the same answer.)
    movzx   edi, byte [qSum]            ; exit status = 210

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (210)
