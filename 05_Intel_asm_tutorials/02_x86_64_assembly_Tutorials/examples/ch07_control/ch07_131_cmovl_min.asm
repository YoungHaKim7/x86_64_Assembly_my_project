; -----------------------------------------------------------------------------
; cmovl -- conditional move on signed less-than (pick the minimum)
;
; Demonstrates: cmovl implementing min(a,b) without a jump
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_131.lst ch07_131_cmovl_min.asm && ld -g -o ch07_131_cmovl_min ch07_131_cmovl_min.o
; Run:    ./ch07_131_cmovl_min ; echo $?        -> exit code: 23
;
; The compare direction decides the meaning: cmp rbx,rax sets flags for
; "other < candidate?", and cmovl replaces the candidate exactly then.
; No branch is taken, so the CPU never stalls the pipeline -- the main
; reason cmovcc exists.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 88                    ; rax = candidate (first value)
    mov     rbx, 23                    ; rbx = other value
    cmp     rbx, rax                   ; flags reflect: other < candidate?
    cmovl   rax, rbx                   ; yes -> rax = other; no -> keep rax
    ; rax = min(88, 23) = 23

last:
    mov     rdi, rax                   ; exit status = 23
    mov     rax, SYS_exit
    syscall
