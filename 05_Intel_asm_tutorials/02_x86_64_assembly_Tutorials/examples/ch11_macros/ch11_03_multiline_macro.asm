; -----------------------------------------------------------------------------
; Multi-line macro (%macro / %endmacro) used twice
;
; Demonstrates: %macro definition, %1-style argument references, a prologue
;               and epilogue macro pair expanded in two functions
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.2 (Multi-Line Macros),
;               sections 11.2.1 - 11.2.2 (Macro Definition / Using a Macro)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_03_multiline_macro.lst ch11_03_multiline_macro.asm && ld -g -o ch11_03_multiline_macro ch11_03_multiline_macro.o
; Run:    ./ch11_03_multiline_macro ; echo $?        -> exit code: 8
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; A multi-line macro takes the number of arguments after its name; the
; arguments are referenced as %1, %2, ... inside the body.
;
; prologue -- standard function entry: establish a stack frame.
%macro prologue 0
    push    rbp                         ; save caller's frame pointer
    mov     rbp, rsp                    ; rbp = current stack top
%endmacro

; epilogue -- tear the frame down and return. These functions do not change
; rsp after the prologue, so popping rbp lands on the return address.
%macro epilogue 0
    pop     rbp                         ; restore caller's frame pointer
    ret                                 ; back to the caller
%endmacro

section .text
global _start

; -----------------------------------------------------------------------------
; doubleIt -- leaf function: returns 2 * rdi in rax. Uses the macros above.
doubleIt:
    prologue                            ; macro expansion #1
    mov     rax, rdi                    ; rax = argument
    add     rax, rax                    ; rax = 2 * argument
    epilogue                            ; macro expansion #2

; -----------------------------------------------------------------------------
; addTwo -- leaf function: returns rdi + rsi in rax. Same macros again.
addTwo:
    prologue                            ; macro expansion #3
    mov     rax, rdi                    ; first argument
    add     rax, rsi                    ; plus second argument
    epilogue                            ; macro expansion #4

_start:
    mov     rdi, 3                      ; 3 ...
    call    doubleIt                    ; ... doubled = 6

    mov     rdi, rax                    ; feed 6 into the next function
    mov     rsi, 2                      ; ... plus 2
    call    addTwo                      ; rax = 6 + 2 = 8

last:
    mov     rdi, rax                    ; exit status = computed result (8)
    mov     rax, SYS_exit               ; call code for exit
    syscall
