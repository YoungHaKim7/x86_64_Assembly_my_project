; -----------------------------------------------------------------------------
; lea vs mov on a label: two ways to obtain an address
;
; Demonstrates: lea reg,[label] compared with mov reg,label (address)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_15.lst ch07_15_lea_address.asm && ld -g -o ch07_15 ch07_15_lea_address.o
; Run:    ./ch07_15 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar        dq 42                ; any variable — only its address matters

section .text
global _start
_start:

; lea ("load effective address") computes the address of its memory
; operand but NEVER reads memory — brackets do not mean a load here.
    lea     rbx, [qVar]              ; rbx = ADDRESS of qVar

; A label used without brackets is assembled as an immediate constant,
; so this mov loads that same address as a plain number.
    mov     rcx, qVar                ; rcx = ADDRESS of qVar (immediate form)

; If both instructions delivered the same address, their difference is
; zero; add 1 so the "addresses match" result fits the exit status.
    sub     rcx, rbx                 ; rcx = 0 -> lea and mov agree
    add     rcx, 1                   ; rcx = 1 for the exit status

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rcx                 ; exit status = rcx = 1
    syscall
