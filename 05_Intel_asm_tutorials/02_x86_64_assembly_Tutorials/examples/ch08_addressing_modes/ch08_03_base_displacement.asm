; -----------------------------------------------------------------------------
; base + displacement addressing: rbx holds the base, +16 selects qArr[2]
;
; Demonstrates: [base register + constant displacement] addressing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.1 (Addressing Modes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_03_base_displacement.lst ch08_03_base_displacement.asm && ld -g -o ch08_03_base_displacement ch08_03_base_displacement.o
; Run:    ./ch08_03_base_displacement ; echo $?        -> exit code: 30
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 10, 20, 30, 40          ; qword array: qArr[0..3]

section .text
global _start
_start:

; Base + displacement: rbx holds the array base; the constant is a byte
; offset from that base.  Element 2 of a qword array is 2*8 = 16 bytes in.
; This form allows the SAME code to work on different arrays: just load a
; different base address into rbx.
    mov     rbx, qArr                      ; rbx = base address of qArr
    mov     rax, qword [rbx+16]            ; rax = qArr[2] = 30
    mov     rdi, rax                       ; exit code = element 2 (30)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
