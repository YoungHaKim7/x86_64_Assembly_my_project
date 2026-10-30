; -----------------------------------------------------------------------------
; nested pushes: two nesting levels, inner value popped before outer value
;
; Demonstrates: stack discipline across nested save/restore regions
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.1 (Machine Stack)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_08_nested_pushes.lst ch09_08_nested_pushes.asm && ld -g -o ch09_08_nested_pushes ch09_08_nested_pushes.o
; Run:    ./ch09_08_nested_pushes ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Outer region saves 21; while it is "busy", an inner region saves 43 on
; top of it.  The inner pop must see 43 and only afterwards may the outer
; pop see 21 -- each level gets back exactly what it pushed.
    push    21                             ; outer level
    push    43                             ; inner level (stack: 21 43)

    pop     rbx                            ; inner pop: rbx = 43
    pop     rcx                            ; outer pop: rcx = 21

; verify both values came through intact -- exit 1 on success, 0 otherwise
    cmp     rbx, 43
    jne     mismatch
    cmp     rcx, 21
    jne     mismatch
    mov     rdi, 1                         ; both nesting levels intact
    jmp     last

mismatch:
    mov     rdi, 0                         ; stack corrupted (never happens)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
