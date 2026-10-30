; -----------------------------------------------------------------------------
; argv[0] -- printing the program's own name
;
; Demonstrates: walking the argv pointer array, runtime strlen, write
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 16.3 - 16.4
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_02.lst ch16_02_print_argv0.asm && ld -g -o ch16_02_print_argv0 ch16_02_print_argv0.o
; Run:    ./ch16_02_print_argv0
;         -> ./ch16_02_print_argv0    (whatever path was used to launch it)
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

section .text
global _start
_start:
    mov     rsi, qword [rsp + 8]       ; argv[0]: NUL-terminated path

    xor     rdx, rdx                   ; rdx = length counter
.lenLoop:
    cmp     byte [rsi + rdx], 0        ; scan for the NUL terminator
    je      .gotLen
    inc     rdx
    jmp     .lenLoop
.gotLen:
    mov     r12, rdx                   ; save the length

    mov     rax, SYS_write             ; print the path...
    mov     rdi, STDOUT
    syscall

    push    NL                         ; ...then a newline (write needs an
    mov     rax, SYS_write             ; address, so the byte lives on the
    mov     rdi, STDOUT                ; stack)
    mov     rsi, rsp
    mov     rdx, 1
    syscall
    add     rsp, 8

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
