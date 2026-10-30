; -----------------------------------------------------------------------------
; register indirect addressing: the address of qArr[0] is held in rbx
;
; Demonstrates: mov r64, label (load address), memory access via [register]
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.1 (Addressing Modes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_02_register_indirect.lst ch08_02_register_indirect.asm && ld -g -o ch08_02_register_indirect ch08_02_register_indirect.o
; Run:    ./ch08_02_register_indirect ; echo $?        -> exit code: 10
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 10, 20, 30, 40          ; qword array: qArr[0..3]

section .text
global _start
_start:

; Register indirect: a register HOLDS the address; [rbx] then reads memory
; at that address.  Note that "mov rbx, qArr" loads the array ADDRESS as an
; immediate (the label is just a number to the CPU), not the first element.
    mov     rbx, qArr                      ; rbx = address of qArr
    mov     rax, qword [rbx]               ; rax = qArr[0] = 10
    mov     rdi, rax                       ; exit code = element 0 (10)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
