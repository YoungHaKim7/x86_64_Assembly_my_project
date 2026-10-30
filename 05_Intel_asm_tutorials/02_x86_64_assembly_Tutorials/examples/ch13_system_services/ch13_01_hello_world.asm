; -----------------------------------------------------------------------------
; Hello World -- the minimal SYS_write program
;
; Demonstrates: SYS_write (1) syscall, .data string with computed length
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.3 (Console Output)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_01.lst ch13_01_hello_world.asm && ld -g -o ch13_01_hello_world ch13_01_hello_world.o
; Run:    ./ch13_01_hello_world
;         -> Hello World
; -----------------------------------------------------------------------------

SYS_write        equ 1                 ; write syscall number
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    msg         db  "Hello World", 10  ; 10 = newline (NL)
    msgLen      equ $-msg              ; length computed at assembly time

section .text
global _start
_start:
    mov     rax, SYS_write             ; rax = syscall number
    mov     rdi, STDOUT                ; rdi = file descriptor
    mov     rsi, msg                   ; rsi = buffer address
    mov     rdx, msgLen                ; rdx = byte count
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
