; -----------------------------------------------------------------------------
; Arguments in reverse -- walking argv back to front
;
; Demonstrates: downward index loop over the argument vector
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 16.3 - 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_08.lst ch16_08_reverse_args.asm && ld -g -o ch16_08_reverse_args ch16_08_reverse_args.o
; Run:    ./ch16_08_reverse_args x y z
;         -> z
;            y
;            x
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
    mov     rbx, r13
    dec     rbx                        ; start at argv[argc-1]

.argLoop:
    test    rbx, rbx
    jz      last                       ; printed down to argv[1]
    mov     rsi, qword [rsp + 8 + rbx*8]
    call    printArg
    dec     rbx
    jmp     .argLoop

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
