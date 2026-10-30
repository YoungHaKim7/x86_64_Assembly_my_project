; -----------------------------------------------------------------------------
; Seventh argument passed on the stack
;
; Demonstrates: argument 7 and beyond travel on the stack; inside the callee
;               the first stack argument sits at [rsp+8] (the call
;               instruction pushed the return address at [rsp])
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.8.1 (Parameter Passing),
;               12.8.3 (Call Frame)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_05_seventh_argument_stack.lst ch12_05_seventh_argument_stack.asm && ld -g -o ch12_05_seventh_argument_stack ch12_05_seventh_argument_stack.o
; Run:    ./ch12_05_seventh_argument_stack ; echo $?        -> exit code: 28
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; sumSeven -- returns the sum of seven arguments in rax.
; Arguments 1..6 arrive in rdi, rsi, rdx, rcx, r8, r9.
; Argument 7 was pushed by the caller, so at function entry:
;       [rsp]     = return address (pushed by call)
;       [rsp + 8] = argument 7
sumSeven:
    mov     rax, rdi                    ; argument 1
    add     rax, rsi                    ; + argument 2
    add     rax, rdx                    ; + argument 3
    add     rax, rcx                    ; + argument 4
    add     rax, r8                     ; + argument 5
    add     rax, r9                     ; + argument 6
    add     rax, qword [rsp + 8]        ; + argument 7 (from the stack)
    ret

_start:
    sub     rsp, 8                      ; reserve one stack slot (keeps the
                                        ; stack 16-byte aligned for the call)
    mov     qword [rsp], 7              ; argument 7 -> stack slot

    mov     rdi, 1                      ; argument 1
    mov     rsi, 2                      ; argument 2
    mov     rdx, 3                      ; argument 3
    mov     rcx, 4                      ; argument 4
    mov     r8, 5                       ; argument 5
    mov     r9, 6                       ; argument 6
    call    sumSeven                    ; rax = 1+...+7 = 28

    add     rsp, 8                      ; release the argument slot again
    mov     rdi, rax                    ; exit status = computed result (28)
    mov     rax, SYS_exit               ; call code for exit
    syscall
