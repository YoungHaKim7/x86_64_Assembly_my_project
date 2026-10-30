; -----------------------------------------------------------------------------
; pushfq/popfq: save the rflags register across flag-destroying code
;
; Demonstrates: pushfq, popfq, carry flag surviving on the stack
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_04_pushfq_popfq.lst ch09_04_pushfq_popfq.asm && ld -g -o ch09_04_pushfq_popfq ch09_04_pushfq_popfq.o
; Run:    ./ch09_04_pushfq_popfq ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Every arithmetic instruction rewrites the flags.  pushfq stores the whole
; rflags register as a qword, popfq loads it back -- a snapshot/restore
; that lets a flag decision survive intervening arithmetic.
    mov     al, 255                        ; al = 255
    add     al, 1                          ; al = 0, CF = 1 (carry out)

    pushfq                                 ; save rflags with CF = 1

    add     al, 1                          ; al = 1, CF = 0 (flag destroyed)

    popfq                                  ; restore rflags -> CF = 1 again
    jc      carrySurvived                  ; CF survived the round trip

    mov     rdi, 0                         ; CF lost (never happens)
    jmp     last

carrySurvived:
    mov     rdi, 1                         ; the saved carry was restored

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
