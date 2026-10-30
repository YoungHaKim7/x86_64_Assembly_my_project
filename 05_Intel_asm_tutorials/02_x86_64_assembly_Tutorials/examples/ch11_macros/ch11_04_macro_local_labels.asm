; -----------------------------------------------------------------------------
; Macro-local labels (%%) -- same macro expanded twice
;
; Demonstrates: %%-prefixed labels inside a %macro body that expand to a
;               unique label for every invocation, avoiding duplicate-label
;               assembly errors
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.2.1 (Macro Definition)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_04_macro_local_labels.lst ch11_04_macro_local_labels.asm && ld -g -o ch11_04_macro_local_labels ch11_04_macro_local_labels.o
; Run:    ./ch11_04_macro_local_labels ; echo $?        -> exit code: 10
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; incBy reg, count -- adds 'count' to a 64-bit register one at a time.
;
; Labels inside a macro body MUST be prefixed with %% so each expansion gets
; its own uniquely generated label. Without the %% the second incBy below
; would define a second (duplicate) "again" label and assembly would fail.
; Note: the macro uses rcx as its loop counter, so callers must not rely on
; rcx surviving an incBy.
%macro incBy 2
    mov     rcx, %2                     ; loop counter = count
%%again:
    add     %1, 1                       ; one increment per iteration
    loop    %%again                     ; rcx-- and repeat while rcx != 0
%endmacro

section .text
global _start
_start:

    xor     rax, rax                    ; rax = 0
    xor     rbx, rbx                    ; rbx = 0

    incBy   rax, 4                      ; first expansion: rax = 4
    incBy   rbx, 6                      ; second expansion: rbx = 6

    add     rax, rbx                    ; rax = 4 + 6 = 10

last:
    mov     rdi, rax                    ; exit status = computed result (10)
    mov     rax, SYS_exit               ; call code for exit
    syscall
