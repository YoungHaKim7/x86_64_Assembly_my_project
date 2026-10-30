; -----------------------------------------------------------------------------
; Uppercase conversion in place
;
; Demonstrates: modifying a string through its address ('a'..'z' -> 'A'..'Z'
;               by subtracting 32), then checksumming the result
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.7 (Argument Transmission)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_21_string_upper_function.lst ch12_21_string_upper_function.asm && ld -g -o ch12_21_string_upper_function ch12_21_string_upper_function.o
; Run:    ./ch12_21_string_upper_function ; echo $?        -> exit code: 198
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    strng       db "aBc", 0             ; will become "ABC" in place

section .text
global _start

; -----------------------------------------------------------------------------
; strToUpper -- rdi = string address; converts lowercase a..z to uppercase
;               A..Z in place (other characters, including the NUL, are
;               left untouched).
strToUpper:
.next:
    mov     al, byte [rdi]              ; current character
    test    al, al                      ; NUL terminator?
    jz      .done
    cmp     al, 'a'                     ; below 'a' -> not lowercase
    jb      .skip
    cmp     al, 'z'                     ; above 'z' -> not lowercase
    ja      .skip
    sub     al, 32                      ; 'a'..'z' -> 'A'..'Z'
    mov     byte [rdi], al              ; write the uppercase byte back
.skip:
    inc     rdi                         ; advance to the next character
    jmp     .next
.done:
    ret

_start:
    mov     rdi, strng                  ; argument: address of the string
    call    strToUpper                  ; strng is now "ABC"

    ; Checksum the converted string: 'A'+'B'+'C' = 65+66+67 = 198.
    xor     rax, rax                    ; rax = checksum = 0
    xor     rcx, rcx                    ; rcx = index
.sumLoop:
    movzx   edx, byte [strng + rcx]     ; one character, zero-extended
    test    edx, edx                    ; NUL terminator?
    jz      .doneSum
    add     rax, rdx                    ; checksum += character
    inc     rcx
    jmp     .sumLoop
.doneSum:

last:
    mov     rdi, rax                    ; exit status = checksum (198)
    mov     rax, SYS_exit               ; call code for exit
    syscall
