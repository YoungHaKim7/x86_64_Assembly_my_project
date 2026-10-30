; -----------------------------------------------------------------------------
; character counting: count the 's' characters in "mississippi" (4)
;
; Demonstrates: byte-string scan with [strng + i], cmp of an immediate char
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_18_count_char.lst ch08_18_count_char.asm && ld -g -o ch08_18_count_char ch08_18_count_char.o
; Run:    ./ch08_18_count_char ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    strng       db "mississippi"           ; string to scan (a byte list)
    STR_LEN     equ 11                     ; its length, no NUL needed

section .text
global _start
_start:

; A string is just a byte array: walk index i over STR_LEN bytes, comparing
; each one against the immediate character 's' (0x73).
; "mississippi" contains 's' at offsets 2, 3, 5 and 6 -> 4 hits.
    mov     rbx, 0                         ; count = 0
    mov     r12, 0                         ; i = 0
    mov     rcx, STR_LEN                   ; rcx = byte count (for loop)

countLoop:
    cmp     byte [strng + r12], 's'        ; is strng[i] == 's'?
    jne     nextChar                       ; no -> nothing to count
    inc     rbx                            ; yes -> count it
nextChar:
    inc     r12                            ; i++
    loop    countLoop                      ; dec rcx; repeat while rcx > 0

    mov     rdi, rbx                       ; exit code = 4

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
