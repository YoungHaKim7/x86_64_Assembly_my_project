; -----------------------------------------------------------------------------
; js: jump if the sign flag is set (result is negative)
;
; Demonstrates: test reg,reg + js (SF = 1)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_121.lst ch07_121_js_negative.asm && ld -g -o ch07_121 ch07_121_js_negative.o
; Run:    ./ch07_121 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd -7                 ; negative value (sign bit set)

section .text
global _start
_start:

; `test eax, eax` ANDs eax with itself: the value is unchanged but the
; flags are set exactly as cmp eax,0 would — SF copies bit 31 of -7,
; so SF = 1 and js ("jump if sign") is taken.  jns is the opposite.
    mov     eax, dword [dVar1]      ; eax = -7 (0xFFFFFFF9)
    mov     ebx, 0                  ; result if the jump is not taken
    test    eax, eax                ; sets SF = 1 because bit 31 is set
    js      wasNegative             ; taken: value is negative
    jmp     last                    ; (skipped by the js)

wasNegative:
    mov     ebx, 1                  ; report that js fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
