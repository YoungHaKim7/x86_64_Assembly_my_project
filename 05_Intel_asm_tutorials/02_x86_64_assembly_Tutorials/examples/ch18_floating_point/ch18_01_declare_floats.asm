; -----------------------------------------------------------------------------
; Declaring floating-point constants in .data
;
; Demonstrates: dd (32-bit float) and dq (64-bit double) declarations
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 3.3 and 18.1 (Floating-Point Values)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_01.lst ch18_01_declare_floats.asm && ld -g -o ch18_01_declare_floats ch18_01_declare_floats.o
; Run:    ./ch18_01_declare_floats ; echo $?        -> exit code: 3
;
; dd holds an IEEE-754 single (about 7 decimal digits); dq holds a double
; (about 15 digits).  The exit code reports how many constants are defined.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    flt1        dd  1.5                 ; 32-bit float
    flt2        dd  2.5                 ; 32-bit float
    dbl1        dq  3.141592653589793   ; 64-bit double

section .text
global _start
_start:
    mov     rax, flt1                   ; addresses prove three separate
    mov     rbx, flt2                   ; 4/4/8-byte allocations exist;
    mov     rcx, dbl1                   ; the count itself is the result
    mov     rax, 3                      ; three floating-point constants

last:
    mov     rdi, rax                    ; exit status = 3
    mov     rax, SYS_exit
    syscall
