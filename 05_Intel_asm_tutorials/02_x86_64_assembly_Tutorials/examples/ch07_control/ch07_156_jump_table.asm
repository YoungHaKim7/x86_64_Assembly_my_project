; -----------------------------------------------------------------------------
; Jump table -- dispatch via indirect jmp through a qword table
;
; Demonstrates: switch/case implemented as a table of code addresses
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_156.lst ch07_156_jump_table.asm && ld -g -o ch07_156_jump_table ch07_156_jump_table.o
; Run:    ./ch07_156_jump_table ; echo $?        -> exit code: 22
;
; selector 2 indexes the table; jmp qword [table + selector*8] lands in
; case2, which yields 22.  Each case falls through to last.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    jumpTable   dq  case0, case1, case2, case3

section .text
global _start
_start:
    mov     rbx, 2                     ; selector
    cmp     rbx, 3                     ; guard against out-of-range
    ja      outOfRange
    jmp     qword [jumpTable + rbx*8]  ; indirect dispatch

case0:
    mov     rax, 10
    jmp     last
case1:
    mov     rax, 15
    jmp     last
case2:
    mov     rax, 22                    ; selected case
    jmp     last
case3:
    mov     rax, 30
    jmp     last

; out-of-range selectors land here (must be a full label: local .labels
; scope under the nearest preceding non-local label, which here is case3)
outOfRange:
    xor     rax, rax

last:
    mov     rdi, rax                   ; exit status = 22
    mov     rax, SYS_exit
    syscall
