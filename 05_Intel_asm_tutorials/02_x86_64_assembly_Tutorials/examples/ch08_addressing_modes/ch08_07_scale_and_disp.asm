; -----------------------------------------------------------------------------
; scale + displacement addressing: [dArr + rcx*4 + 8] reaches dArr[3]
;
; Demonstrates: general form [displacement + index*scale + displacement]
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.2 (Addressing Mode Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_07_scale_and_disp.lst ch08_07_scale_and_disp.asm && ld -g -o ch08_07_scale_and_disp ch08_07_scale_and_disp.o
; Run:    ./ch08_07_scale_and_disp ; echo $?        -> exit code: 40
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 10, 20, 30, 40          ; dword array: dArr[0..3]

section .text
global _start
_start:

; The fullest memory-address form: [label + index*scale + constant].
; With rcx = 1 the effective address is  dArr + 1*4 + 8  =  dArr + 12,
; which is exactly the address of element 3 of the dword array.
; (Useful shorthand: a displacement of k*sizeof(element) shifts the window
; of the array the index register walks over.)
    mov     rcx, 1                         ; rcx = index 1
    mov     eax, dword [dArr + rcx*4 + 8]  ; eax = dArr[3] = 40
    mov     edi, eax                       ; rdi = 40 (32-bit write clears rdi)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
