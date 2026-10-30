; -----------------------------------------------------------------------------
; Single-line macro defined with %define (one parameter)
;
; Demonstrates: %define single-line macro, textual substitution at expansion,
;               why parentheses belong in macro bodies
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.1 (Single-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_01_single_line_macro.lst ch11_01_single_line_macro.asm && ld -g -o ch11_01_single_line_macro ch11_01_single_line_macro.o
; Run:    ./ch11_01_single_line_macro ; echo $?        -> exit code: 24
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; Single-line macros are defined with %define and behave like C/C++ macros:
; the preprocessor textually substitutes the body at each point of use.
; Parenthesizing every parameter is a good habit -- without them an argument
; such as (3+9) would expand as 3+9*2 due to operator precedence.
%define TWICE(r)     ((r) * 2)

section .text
global _start
_start:

    ; TWICE(12) expands to ((12) * 2); the assembler folds it to 24, so the
    ; instruction becomes "mov rax, 24" (see the .lst file).
    mov     rax, TWICE(12)            ; rax = 24

    ; A second use shows it is pure text substitution: here the parameter is
    ; an expression the assembler folds the same way.
    mov     rbx, TWICE(3 + 9)         ; rbx = ((3 + 9) * 2) = 24

    ; Both expansions must agree: rax - rbx is 0 only if both produced 24.
    sub     rax, rbx                  ; rax = 0  (both expansions gave 24)
    add     rax, 24                   ; rax = 24

last:
    mov     rdi, rax                  ; exit status = computed result (24)
    mov     rax, SYS_exit             ; call code for exit
    syscall
