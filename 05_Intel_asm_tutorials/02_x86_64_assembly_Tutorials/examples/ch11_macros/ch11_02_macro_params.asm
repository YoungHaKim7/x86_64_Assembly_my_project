; -----------------------------------------------------------------------------
; Single-line macro with two parameters (constant and register arguments)
;
; Demonstrates: %define macro with multiple parameters; expression-style
;               macro used with immediates and instruction-style macro used
;               with registers (like the book's mulby4)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.1 (Single-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_02_macro_params.lst ch11_02_macro_params.asm && ld -g -o ch11_02_macro_params ch11_02_macro_params.o
; Run:    ./ch11_02_macro_params ; echo $?        -> exit code: 30
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; Expression-style macro: the body is an expression, so it may appear where
; a constant is expected. Register arithmetic is not allowed inside an
; operand expression, so this form is for immediate arguments.
%define ADD_TWO(a, b)     ((a) + (b))

; Instruction-style macro (like the book's "%define mulby4(x) shl x, 2"):
; the body is a whole instruction, which makes register arguments legal.
%define ADD_IT(a, b)      add a, b

section .data
    qVar1       dq 13                    ; first operand
    qVar2       dq 17                    ; second operand

section .text
global _start
_start:

    ; Constant arguments: expands to "mov rax, ((13) + (17))"; the assembler
    ; folds it to 30 at assembly time (visible in the .lst file).
    mov     rax, ADD_TWO(13, 17)         ; rax = 30

    ; Register arguments: expands to "add rbx, rcx".
    mov     rbx, qword [qVar1]           ; rbx = 13
    mov     rcx, qword [qVar2]           ; rcx = 17
    ADD_IT(rbx, rcx)                     ; rbx = 13 + 17 = 30

    ; Both expansions must agree: rax - rbx is 0 only if both produced 30.
    sub     rax, rbx                     ; rax = 0 (paths agree)
    add     rax, 30                      ; rax = 30

last:
    mov     rdi, rax                     ; exit status = computed result (30)
    mov     rax, SYS_exit                ; call code for exit
    syscall
