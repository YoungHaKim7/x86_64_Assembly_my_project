; -----------------------------------------------------------------------------
; Preserving a callee-saved register (rbx) across a function call
;
; Demonstrates: rbx belongs to the callee-saved set, so a function that uses
;               it must push it on entry and pop it before returning
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_07_callee_saved_rbx.lst ch12_07_callee_saved_rbx.asm && ld -g -o ch12_07_callee_saved_rbx ch12_07_callee_saved_rbx.o
; Run:    ./ch12_07_callee_saved_rbx ; echo $?        -> exit code: 55
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; useRbx -- freely uses rbx internally (it is an excellent scratch register
; as long as it is saved and restored); returns 1000 in rax.
useRbx:
    push    rbx                         ; rbx is callee-saved: preserve it
    mov     rbx, 500                    ; clobber away -- rbx is ours now
    add     rbx, rbx                    ; rbx = 1000
    mov     rax, rbx                    ; rax = 1000 (function result)
    pop     rbx                         ; restore the caller's rbx
    ret

_start:
    mov     rbx, 55                     ; a value the caller cares about
    call    useRbx                      ; rax = 1000, rbx must STILL be 55

    ; rbx surviving the call is the whole point: report it directly.
    mov     rdi, rbx                    ; exit status = caller's rbx (55)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
