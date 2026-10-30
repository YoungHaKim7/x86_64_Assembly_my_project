; -----------------------------------------------------------------------------
; Conditional case conversion -- uppercase only what is lowercase
;
; Demonstrates: guarded arithmetic on characters ('a'..'z' -> 'A'..'Z')
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 3.4 and 7.7
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_149.lst ch07_149_to_upper.asm && ld -g -o ch07_149_to_upper ch07_149_to_upper.o
; Run:    ./ch07_149_to_upper ; echo $?        -> exit code: 81
;
; 'q' + ('A'-'a') == 'Q' == 81.  The subtraction of 32 only happens when
; the range check passes -- digits and symbols pass through untouched.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; rdi = char; rax = uppercased char (unchanged if not 'a'..'z')
toUpper:
    mov     rax, rdi
    cmp     dil, 'a'
    jb      .done
    cmp     dil, 'z'
    ja      .done
    sub     al, 'a'                    ; offset within lowercase range
    add     al, 'A'                    ; shift up to uppercase
.done:
    ret

_start:
    mov     rdi, 'q'
    call    toUpper                    ; rax = 'Q' = 81

last:
    mov     rdi, rax                   ; exit status = 81
    mov     rax, SYS_exit
    syscall
