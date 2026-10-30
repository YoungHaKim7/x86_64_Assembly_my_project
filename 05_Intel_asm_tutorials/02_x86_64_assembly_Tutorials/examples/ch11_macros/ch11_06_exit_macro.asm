; -----------------------------------------------------------------------------
; A multi-line macro that wraps the exit system call
;
; Demonstrates: %macro with one argument used as an operand, replacing the
;               usual four-line exit sequence with one macro invocation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.2 (Multi-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_06_exit_macro.lst ch11_06_exit_macro.asm && ld -g -o ch11_06_exit_macro ch11_06_exit_macro.o
; Run:    ./ch11_06_exit_macro ; echo $?        -> exit code: 33
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; exitProgram rc -- terminate the process with exit status rc.
; The argument %1 is substituted textually, so it may be an immediate
; ("exitProgram 0") or a register holding the status ("exitProgram rbx").
%macro exitProgram 1
    mov     rdi, %1                      ; exit status = macro argument
    mov     rax, SYS_exit                ; call code for exit (clobbers rax,
                                        ; so the status is loaded FIRST --
                                        ; this keeps "exitProgram rax" legal)
    syscall                             ; kernel takes it from here
%endmacro

section .text
global _start
_start:

    ; Compute a status value the long way so the macro gets a register.
    mov     rbx, 30                      ; rbx = 30
    add     rbx, 3                       ; rbx = 33

    exitProgram rbx                      ; exit with status 33
