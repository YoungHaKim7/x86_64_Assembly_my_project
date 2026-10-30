; -----------------------------------------------------------------------------
; macros.inc -- a small reusable macro library
;
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 11.2 (Multi-Line Macros)
;
; Include from a program that lives in the same directory with:
;
;       %include "macros.inc"
;
; Assemble from this directory (or with -I pointing at it) so that the
; include file can be found.
; -----------------------------------------------------------------------------

; System call number for exit -- used by the exitProgram macro below.
SYS_exit         equ 60

; exitProgram rc -- terminate the process with exit status rc.
; The argument may be an immediate or a register (including rax: the
; status is loaded into rdi BEFORE rax is clobbered with the call code).
%macro exitProgram 1
    mov     rdi, %1                      ; exit status = macro argument
    mov     rax, SYS_exit                ; call code for exit
    syscall                             ; kernel takes it from here
%endmacro

; negateReg reg64 -- replaces the contents of a 64-bit register with its
; two's-complement negation (0 - reg). Same idea as the book's "abs" macro,
; but unconditional.
%macro negateReg 1
    neg     %1                           ; reg = -reg
%endmacro
