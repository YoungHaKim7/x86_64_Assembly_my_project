; -----------------------------------------------------------------------------
; Stack-based local variables
;
; Demonstrates: standard prologue (push rbp / mov rbp, rsp), reserving local
;               space with sub rsp, locals addressed as [rbp - N], epilogue
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.11 (Stack-Based Local Variables)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_10_stack_local_vars.lst ch12_10_stack_local_vars.asm && ld -g -o ch12_10_stack_local_vars ch12_10_stack_local_vars.o
; Run:    ./ch12_10_stack_local_vars ; echo $?        -> exit code: 35
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; localSum -- returns 35 in rax using two stack-based local variables.
;
; Frame layout after the prologue (rbp is the frame pointer):
;       [rbp]      saved rbp of the caller
;       [rbp + 8]  return address
;       [rbp - 8]  local1
;       [rbp - 16] local2
localSum:
    push    rbp                         ; prologue: save caller's frame ptr
    mov     rbp, rsp                    ; rbp marks the top of our frame
    sub     rsp, 16                     ; room for two qword locals

    mov     qword [rbp - 8], 15         ; local1 = 15
    mov     qword [rbp - 16], 20        ; local2 = 20

    mov     rax, qword [rbp - 8]        ; rax = local1
    add     rax, qword [rbp - 16]       ; rax = local1 + local2 = 35

    mov     rsp, rbp                    ; epilogue: drop the locals
    pop     rbp                         ; restore caller's frame pointer
    ret

_start:
    call    localSum                    ; rax = 35

last:
    mov     rdi, rax                    ; exit status = computed result (35)
    mov     rax, SYS_exit               ; call code for exit
    syscall
