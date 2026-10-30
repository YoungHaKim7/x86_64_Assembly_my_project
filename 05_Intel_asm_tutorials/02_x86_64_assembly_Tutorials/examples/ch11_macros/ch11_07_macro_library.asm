; -----------------------------------------------------------------------------
; Using a macro library kept in a separate include file
;
; Demonstrates: %include of a macro library (macros.inc), invoking library
;               macros (exitProgram, negateReg) defined in another file
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.2 (Multi-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_07_macro_library.lst ch11_07_macro_library.asm && ld -g -o ch11_07_macro_library ch11_07_macro_library.o
;         (assemble from this directory so %include "macros.inc" resolves)
; Run:    ./ch11_07_macro_library ; echo $?        -> exit code: 44
; -----------------------------------------------------------------------------

%include "macros.inc"                    ; exitProgram, negateReg, SYS_exit

section .data
    qVar1       dq -30                   ; first value (negative)
    qVar2       dq -14                   ; second value (negative)

section .text
global _start
_start:

    ; negateReg comes from the library: -30 becomes +30.
    mov     rax, qword [qVar1]           ; rax = -30
    negateReg rax                        ; rax = 30

    ; Second library use: -14 becomes +14.
    mov     rbx, qword [qVar2]           ; rbx = -14
    negateReg rbx                        ; rbx = 14

    add     rax, rbx                     ; rax = 30 + 14 = 44

    ; exitProgram also comes from the library -- no exit boilerplate here.
    exitProgram rax                      ; exit with status 44
