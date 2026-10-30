; -----------------------------------------------------------------------------
; cmova -- clamping a value to an upper limit
;
; Demonstrates: cmova (unsigned above) enforcing a range bound
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_137.lst ch07_137_cmov_clamp.asm && ld -g -o ch07_137_cmov_clamp ch07_137_cmov_clamp.o
; Run:    ./ch07_137_cmov_clamp ; echo $?        -> exit code: 255
;
; A byte-sized sensor reading of 300 must be clamped to 255: cmova
; replaces any value above the limit with the limit itself.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 300                   ; value to clamp
    mov     rbx, 255                   ; upper limit
    cmp     rax, rbx                   ; value above limit?
    cmova   rax, rbx                   ; yes -> replace with the limit
    ; rax = clamp(300, max 255) = 255

last:
    mov     rdi, rax                   ; exit status = 255
    mov     rax, SYS_exit
    syscall
