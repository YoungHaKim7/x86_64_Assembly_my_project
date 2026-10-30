; -----------------------------------------------------------------------------
; Function calls that show the difference between step and next
;
; Demonstrates: call/ret structure; in a debugger
;                 step (s) executes one line AND enters the called function,
;                 next (n) executes one line and runs calls to completion
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 6.2.2.2 (Next / Step)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch06_02_step_vs_next.lst ch06_02_step_vs_next.asm && ld -g -o ch06_02 ch06_02_step_vs_next.o
; Debug:  gdb -x ch06_02.gdb ./ch06_02     (run from this directory)
; Run:    ./ch06_02 ; echo $?        -> exit code: 25
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    call    tenFn                           ; step: goes INTO tenFn / next: runs it
    mov     rbx, rax                        ; rbx = 10 (first helper's result)
    call    fifteenFn                       ; step: goes INTO fifteenFn / next: runs it
    add     rbx, rax                        ; rbx = 10 + 15 = 25

last:
    mov     rax, SYS_exit                   ; call code for exit
    mov     rdi, rbx                        ; exit code 25
    syscall

; tenFn: returns the constant 10 in rax
tenFn:
    mov     rax, 10
    ret

; fifteenFn: returns the constant 15 in rax
fifteenFn:
    mov     rax, 15
    ret
