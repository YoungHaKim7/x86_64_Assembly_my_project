; -----------------------------------------------------------------------------
; save/restore pattern: push rbx before clobbering it, pop it back after
;
; Demonstrates: using the stack to preserve a register across code that
;               reuses the same register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_03_save_restore.lst ch09_03_save_restore.asm && ld -g -o ch09_03_save_restore ch09_03_save_restore.o
; Run:    ./ch09_03_save_restore ; echo $?        -> exit code: 17
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Classic register preservation: some code between the push and the pop is
; free to use rbx for anything; the original value survives on the stack.
    mov     rbx, 17                        ; rbx holds a value we need later
    push    rbx                            ; save rbx on the stack

    mov     rbx, 99                        ; ... other code clobbers rbx ...
    add     rbx, 1                         ; ... any number of changes ...

    pop     rbx                            ; restore rbx = 17 (99 gone)

    mov     rdi, rbx                       ; exit code = 17

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
