; -----------------------------------------------------------------------------
; base + index*scale addressing: [rbx + rcx*8] selects a qword element
;
; Demonstrates: base register + index register scaled by element size
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.2 (Addressing Mode Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_06_base_index_scale.lst ch08_06_base_index_scale.asm && ld -g -o ch08_06_base_index_scale ch08_06_base_index_scale.o
; Run:    ./ch08_06_base_index_scale ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 5, 10, 15, 20           ; qword array: qArr[0..3]

section .text
global _start
_start:

; Base + index + scale: the address is computed as  rbx + rcx*8, where the
; scale 8 equals sizeof(qword).  Element 2 sits 2*8 = 16 bytes past the
; base, so the CPU turns the element index 2 into the byte offset 16.
    mov     rbx, qArr                      ; rbx = base address of qArr
    mov     rcx, 2                         ; rcx = element index 2
    mov     rax, qword [rbx + rcx*8]       ; rax = qArr[2] = 15
    mov     rdi, rax                       ; exit code = element 2 (15)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
