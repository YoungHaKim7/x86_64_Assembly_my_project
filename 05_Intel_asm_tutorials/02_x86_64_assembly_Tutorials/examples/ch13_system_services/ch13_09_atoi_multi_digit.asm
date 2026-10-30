; -----------------------------------------------------------------------------
; atoi, multi-digit -- the book's multiply-by-10 loop
;
; Demonstrates: converting a decimal string to binary
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_09.lst ch13_09_atoi_multi_digit.asm && ld -g -o ch13_09_atoi_multi_digit ch13_09_atoi_multi_digit.o
; Run:    echo "250" | ./ch13_09_atoi_multi_digit ; echo $?
;         -> 250
;
; value = 0; for each digit: value = value*10 + digit.  "2","5","0":
; 0*10+2=2 -> 2*10+5=25 -> 25*10+0=250.  Stops at the newline.
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
NL               equ 10

section .bss
    inBuf       resb 32

section .text
global _start
_start:
    mov     rax, SYS_read
    mov     rdi, STDIN
    mov     rsi, inBuf
    mov     rdx, 32
    syscall                             ; rax = byte count

    xor     rbx, rbx                   ; rbx = accumulated value
    mov     rsi, inBuf                 ; rsi -> next character
    mov     rcx, rax                   ; rcx = characters left

.digitLoop:
    movzx   rdx, byte [rsi]
    cmp     dl, NL                     ; newline terminates the number
    je      .done
    imul    rbx, rbx, 10               ; value *= 10
    sub     rdx, '0'                   ; char -> digit
    add     rbx, rdx                   ; value += digit
    inc     rsi
    dec     rcx
    jnz     .digitLoop
.done:
    ; rbx = 250

last:
    mov     rdi, rbx                    ; exit status = 250
    mov     rax, SYS_exit
    syscall
