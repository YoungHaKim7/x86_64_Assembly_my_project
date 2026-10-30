; -----------------------------------------------------------------------------
; Recursive summation 1 + 2 + ... + n
;
; Demonstrates: accumulator-free linear recursion; each frame's n lives on
;               the stack until the base case unwinds
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.8.3 (Call Frame),
;               12.10 (Example, Statistical Function 2 (non-leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_14_recursive_sum.lst ch12_14_recursive_sum.asm && ld -g -o ch12_14_recursive_sum ch12_14_recursive_sum.o
; Run:    ./ch12_14_recursive_sum ; echo $?        -> exit code: 210
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; rsum -- rdi = n (n >= 0); returns 1 + 2 + ... + n in rax.
;
;   rsum(n) = n + rsum(n-1),   rsum(0) = 0
;
; Identical shape to the recursive factorial: push this frame's n, recurse,
; pop it back and add. n = 20 gives 210.
rsum:
    test    rdi, rdi                    ; base case: n = 0
    jz      .base
    push    rdi                         ; save THIS frame's n
    dec     rdi                         ; argument n-1
    call    rsum                        ; rax = 1 + ... + (n-1)
    pop     rdi                         ; restore THIS frame's n
    add     rax, rdi                    ; rax = n + rsum(n-1)
    ret
.base:
    xor     rax, rax                    ; rsum(0) = 0
    ret

_start:
    mov     rdi, 20                     ; n = 20
    call    rsum                        ; rax = 210

last:
    mov     rdi, rax                    ; exit status = computed result (210)
    mov     rax, SYS_exit               ; call code for exit
    syscall
