global      _start

section     .text

_start:
    mov     rax, 1              ; system call for write
    mov     rdi, 1              ; file handle 1 is stdout
    mov     rsi, message        ; address of string to output
    mov     rdx, 13             ; number of bytes

    ; mov <dest>, <src>
    mov rax, 5                  ; store 5 in rax
    mov rsi, rdi                ; copy value in rdi to rsi
    mov [r12], 15               ; store 15 at the memory address in r12

    movb [r12], 15              ; write 15 as 1 byte to memory address in r12
    movw [r12], 15              ; write 15 as 2 byte to memory address in r12
    movl [r12], 15              ; write 15 as 4 byte to memory address in r12
    movq [r12], 15              ; write 15 as 8 byte to memory address in r12

    mov rax, r12                ; copy value from r12 to rax
    mov rax, [r12]              ; copy value from memory address stored in r12
                                ; to rax



    syscall
    mov     rax, 60             ; system call for exit
    xor     rdi, rdi            ; exit code 0
    syscall

section     .data
    message: db         "Hello, World Asm", 10  ; note the newline at the end
