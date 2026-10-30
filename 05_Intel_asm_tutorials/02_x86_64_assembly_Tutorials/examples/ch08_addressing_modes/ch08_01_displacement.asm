; -----------------------------------------------------------------------------
; displacement addressing: mov rax, [qArr+8] loads element 1 of a qword array
;
; Demonstrates: memory addressing as label + constant displacement (offset)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.1 (Addressing Modes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_01_displacement.lst ch08_01_displacement.asm && ld -g -o ch08_01_displacement ch08_01_displacement.o
; Run:    ./ch08_01_displacement ; echo $?        -> exit code: 20
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 10, 20, 30, 40          ; qword array: qArr[0..3]

section .text
global _start
_start:

; Addressing mode "displacement": the effective address is the assembler-
; time constant (label + offset).  The displacement counts BYTES from the
; label, so qword element i lives at qArr + i*8:
;   qArr+0  -> 10     qArr+8  -> 20     qArr+16 -> 30     qArr+24 -> 40
    mov     rax, qword [qArr+8]            ; rax = qArr[1] = 20
    mov     rdi, rax                       ; exit code = element 1 (20)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
