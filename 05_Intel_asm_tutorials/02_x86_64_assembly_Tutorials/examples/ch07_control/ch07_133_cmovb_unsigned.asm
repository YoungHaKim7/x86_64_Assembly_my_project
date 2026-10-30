; -----------------------------------------------------------------------------
; cmovb -- conditional move on unsigned below (unsigned minimum)
;
; Demonstrates: cmovb compares UNSIGNED (contrast with signed cmovl)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_133.lst ch07_133_cmovb_unsigned.asm && ld -g -o ch07_133_cmovb_unsigned ch07_133_cmovb_unsigned.o
; Run:    ./ch07_133_cmovb_unsigned ; echo $?        -> exit code: 10
;
; 10 and 250: cmovb/cmp treat both as plain non-negative bit patterns, so
; min = 10.  Had the values been signed-negative bit patterns, cmovb and
; cmovl would disagree -- that split is shown in ch07_120.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 250                   ; rax = candidate (larger unsigned)
    mov     rbx, 10                    ; rbx = other value
    cmp     rbx, rax                   ; flags reflect: other <u candidate?
    cmovb   rax, rbx                   ; yes -> rax = other
    ; rax = unsigned min(250, 10) = 10

last:
    mov     rdi, rax                   ; exit status = 10
    mov     rax, SYS_exit
    syscall
