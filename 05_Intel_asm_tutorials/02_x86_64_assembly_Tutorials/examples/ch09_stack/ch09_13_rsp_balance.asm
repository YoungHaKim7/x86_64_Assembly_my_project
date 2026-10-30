; -----------------------------------------------------------------------------
; rsp balance: rsp must return to its starting value after pop matches push
;
; Demonstrates: balanced push/pop discipline, comparing rsp before/after
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.1 (Machine Stack)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_13_rsp_balance.lst ch09_13_rsp_balance.asm && ld -g -o ch09_13_rsp_balance ch09_13_rsp_balance.o
; Run:    ./ch09_13_rsp_balance ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Snapshot rsp in a callee-saved register, then push/pop three qwords.
; Every push lowers rsp by 8 and every pop raises it by 8, so three of each
; must land rsp exactly where it started.
    mov     r12, rsp                       ; r12 = rsp before the pushes

    push    7                              ; rsp -= 8
    push    8                              ; rsp -= 8
    push    9                              ; rsp -= 8

    pop     rbx                            ; rsp += 8 (value discarded)
    pop     rbx                            ; rsp += 8
    pop     rbx                            ; rsp += 8

    cmp     rsp, r12                       ; back at the starting address?
    jne     unbalanced
    mov     rdi, 1                         ; stack perfectly balanced
    jmp     last

unbalanced:
    mov     rdi, 0                         ; push/pop mismatch (never happens)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
