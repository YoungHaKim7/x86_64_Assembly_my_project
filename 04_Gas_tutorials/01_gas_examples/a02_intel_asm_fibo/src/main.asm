; -----------------------------------------------------------------------------
; A 64-bit Linux application that writes the first 90 Fibonacci numbers.
; To assemble and run:
;   nasm -felf64 fib.asm && gcc fib.o && ./a.out
; -----------------------------------------------------------------------------

global main
extern printf

section .data
    format: db "%ld", 10, 0    ; "%ld\n" format string for printf

section .text
main:
    push rbx                  ; Save rbx (callee-saved register)
    push r12                  ; Save r12
    push r13                  ; Save r13

    mov rcx, 90               ; Loop counter for 90 Fibonacci numbers
    xor rax, rax              ; rax = F(n-2) = 0
    xor rbx, rbx              ; rbx = F(n-1) = 0
    inc rbx                   ; rbx = 1 (first Fibonacci number)

print_loop:
    ; Print current Fibonacci number (stored in rax)
    push rax                  ; Save current rax
    push rcx                  ; Save rcx (caller-saved)

    mov rdi, format           ; 1st argument for printf: format string
    mov rsi, rax              ; 2nd argument for printf: value to print
    xor rax, rax              ; Clear rax for varargs (printf uses 0 vector registers)
    call printf

    pop rcx                   ; Restore rcx
    pop rax                   ; Restore rax

    ; Compute next Fibonacci number:
    ; F(n) = F(n-1) + F(n-2)
    mov rdx, rbx              ; rdx = F(n-1)
    add rdx, rax              ; rdx = F(n-1) + F(n-2)
    mov rax, rbx              ; Shift F(n-1) into rax
    mov rbx, rdx              ; Shift new sum into rbx

    dec rcx                   ; Decrement counter
    jnz print_loop            ; Repeat until rcx reaches 0

    xor rax, rax              ; Return code 0
    pop r13                   ; Restore r13
    pop r12                   ; Restore r12
    pop rbx                   ; Restore rbx
    ret
