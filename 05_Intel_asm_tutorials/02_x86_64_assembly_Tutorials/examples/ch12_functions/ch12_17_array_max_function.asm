; -----------------------------------------------------------------------------
; Array maximum function
;
; Demonstrates: scan pattern with compare/conditional-move-free selection,
;               array (address, length) arguments
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_17_array_max_function.lst ch12_17_array_max_function.asm && ld -g -o ch12_17_array_max_function ch12_17_array_max_function.o
; Run:    ./ch12_17_array_max_function ; echo $?        -> exit code: 99
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 5, 99, 42, 7         ; maximum is the second element
    qLen        dq 4

section .text
global _start

; -----------------------------------------------------------------------------
; arrayMax -- rdi = array address, rsi = length (>= 1); returns the maximum
;             element in rax.
arrayMax:
    mov     rax, qword [rdi]            ; rax = best-so-far = arr[0]
    dec     rsi                         ; one element already consumed
    jz      .done
.next:
    add     rdi, 8                      ; advance to the next quadword
    mov     rdx, qword [rdi]            ; rdx = candidate
    cmp     rdx, rax                    ; candidate > best?
    jle     .skip
    mov     rax, rdx                    ; new maximum
.skip:
    dec     rsi
    jnz     .next
.done:
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    arrayMax                    ; rax = max(5, 99, 42, 7) = 99

last:
    mov     rdi, rax                    ; exit status = computed result (99)
    mov     rax, SYS_exit               ; call code for exit
    syscall
