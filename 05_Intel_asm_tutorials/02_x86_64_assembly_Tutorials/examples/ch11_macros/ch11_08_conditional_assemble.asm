; -----------------------------------------------------------------------------
; Conditional assembly with %if / %else / %endif
;
; Demonstrates: selecting which code the assembler emits based on a build
;               flag; the unselected branch is not assembled at all
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.2 (Multi-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_08_conditional_assemble.lst ch11_08_conditional_assemble.asm && ld -g -o ch11_08_conditional_assemble ch11_08_conditional_assemble.o
; Run:    ./ch11_08_conditional_assemble ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; Build flag. Set to 0 and reassemble to produce the "release" version:
; the %else branch is what gets assembled instead.
%define DEBUG 1

section .text
global _start
_start:

    mov     rbx, 0                       ; running result

%if DEBUG
    ; Debug build: mark the program with 1 so a test run can identify it.
    ; This is the branch assembled when DEBUG is nonzero.
    add     rbx, 1                       ; rbx = 1
%else
    ; Release build: this text never reaches the assembler (check the .lst
    ; file -- these lines are absent from the listing when DEBUG = 1).
    add     rbx, 0                       ; rbx = 0
%endif

    ; The selected branch -- and only it -- determined rbx.
    mov     rax, rbx                     ; rax = 1 in the debug build

last:
    mov     rdi, rax                     ; exit status = 1 (debug build)
    mov     rax, SYS_exit                ; call code for exit
    syscall
