; -----------------------------------------------------------------------------
; comiss -- ordering: less-than uses jb (below)
;
; Demonstrates: float compare maps to unsigned-style jumps
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.6 (Floating-Point Control)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_23.lst ch18_23_comiss_less.asm && ld -g -o ch18_23_comiss_less ch18_23_comiss_less.o
; Run:    ./ch18_23_comiss_less ; echo $?        -> exit code: 1
;
; comiss sets CF=1 when the first operand is smaller: jb reads it.
; (jl would interpret SF/OF and give nonsense for floats.)
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  2.5
    fltB        dd  3.0

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    movss   xmm1, dword [fltB]
    comiss  xmm0, xmm1                 ; 2.5 vs 3.0
    jb      isLess
    xor     rax, rax
    jmp     last
isLess:
    mov     rax, 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
