; -----------------------------------------------------------------------------
; argv[1..argc-1] -- print every argument on its own line
;
; Demonstrates: looping over the argv pointer array
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 16.3 - 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_03.lst ch16_03_print_all_args.asm && ld -g -o ch16_03_print_all_args ch16_03_print_all_args.o
; Run:    ./ch16_03_print_all_args aa bb
;         -> aa
;            bb
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

section .text
global _start

; ---- rsi = string; write it plus newline -----------------------------------
printArg:
    xor     rdx, rdx
.lenLoop:
    cmp     byte [rsi + rdx], 0
    je      .write
    inc     rdx
    jmp     .lenLoop
.write:
    mov     rax, SYS_write
    mov     rdi, STDOUT
    syscall
    push    NL
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, rsp
    mov     rdx, 1
    syscall
    add     rsp, 8
    ret

_start:
    mov     r13, qword [rsp]           ; argc
    mov     rbx, 1                     ; index: skip argv[0]

.argLoop:
    cmp     rbx, r13
    jge     last
    mov     rsi, qword [rsp + 8 + rbx*8]   ; argv[i]
    call    printArg
    inc     rbx
    jmp     .argLoop

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
