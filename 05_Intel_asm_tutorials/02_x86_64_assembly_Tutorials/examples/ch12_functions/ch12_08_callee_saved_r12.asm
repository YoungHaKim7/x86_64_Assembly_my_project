; -----------------------------------------------------------------------------
; Preserving a callee-saved register (r12) across a function call
;
; Demonstrates: r12-r15 join rbx and rbp in the callee-saved set; a function
;               that uses r12 must push it on entry and pop it before
;               returning
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_08_callee_saved_r12.lst ch12_08_callee_saved_r12.asm && ld -g -o ch12_08_callee_saved_r12 ch12_08_callee_saved_r12.o
; Run:    ./ch12_08_callee_saved_r12 ; echo $?        -> exit code: 66
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; useR12 -- freely uses r12 internally; returns 2000 in rax.
useR12:
    push    r12                         ; r12 is callee-saved: preserve it
    mov     r12, 1000                   ; clobber away -- r12 is ours now
    add     r12, r12                    ; r12 = 2000
    mov     rax, r12                    ; rax = 2000 (function result)
    pop     r12                         ; restore the caller's r12
    ret

_start:
    mov     r12, 66                     ; a value the caller cares about
    call    useR12                      ; rax = 2000, r12 must STILL be 66

    ; r12 surviving the call is the whole point: report it directly.
    mov     rdi, r12                    ; exit status = caller's r12 (66)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
