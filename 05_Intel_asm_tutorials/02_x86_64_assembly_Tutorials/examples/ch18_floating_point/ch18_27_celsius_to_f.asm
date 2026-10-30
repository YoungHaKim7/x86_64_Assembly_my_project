; -----------------------------------------------------------------------------
; Celsius to Fahrenheit -- F = C * 9 / 5 + 32
;
; Demonstrates: constant folding order matters less with exact values
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_27.lst ch18_27_celsius_to_f.asm && ld -g -o ch18_27_celsius_to_f ch18_27_celsius_to_f.o
; Run:    ./ch18_27_celsius_to_f ; echo $?        -> exit code: 212
;
; 100 C: 100*9 = 900, /5 = 180, +32 = 212 (boiling point).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    celsius     dq  100.0
    nine        dq  9.0
    five        dq  5.0
    offset32    dq  32.0

section .text
global _start
_start:
    movsd   xmm0, qword [celsius]
    mulsd   xmm0, qword [nine]         ; 900
    divsd   xmm0, qword [five]         ; 180
    addsd   xmm0, qword [offset32]     ; 212
    cvttsd2si rax, xmm0                ; 212

last:
    mov     rdi, rax                    ; exit status = 212
    mov     rax, SYS_exit
    syscall
