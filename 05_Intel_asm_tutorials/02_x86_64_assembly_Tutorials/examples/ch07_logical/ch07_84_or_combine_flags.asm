; -----------------------------------------------------------------------------
; OR to combine permission bits: READ(4) or WRITE(2) -> rw = 6
;
; Demonstrates: or instruction building a bit-set flag word from
;               single-bit constants (unix-style permission masks)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_84.lst ch07_84_or_combine_flags.asm && ld -g -o ch07_84 ch07_84_or_combine_flags.o
; Run:    ./ch07_84 ; echo $?        -> exit code: 6
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

PERM_READ        equ 4                   ; bit 2 = r--
PERM_WRITE       equ 2                   ; bit 1 = -w-
PERM_EXEC        equ 1                   ; bit 0 = --x

section .text
global _start
_start:

; Each permission is one bit, so a permission set is the OR of its parts.
; "rw" = PERM_READ or PERM_WRITE = 100 or 010 = 110 = 6:
    mov     al, PERM_READ                ; al = 0000 0100
    or      al, PERM_WRITE               ; al = 0000 0110 = rw (6)
    mov     bl, al                       ; bl = 6 (the rw mode)

; Contrast: "rwx" additionally ORs in the exec bit -> 111 = 7.
    mov     al, PERM_READ
    or      al, PERM_WRITE
    or      al, PERM_EXEC                ; al = 0000 0111 = rwx (7)

last:
    movzx   rdi, bl                      ; exit status = 6 (the rw flags)
    mov     rax, SYS_exit                ; call code for exit
    syscall
