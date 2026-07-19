   	global      main

section     .text

main:
    mov     eax, 4              ; system call number for sys_write (32-bit)
    mov     ebx, 1              ; file handle 1 is stdout
    mov     ecx, message        ; address of string to output
    mov     edx, 13             ; number of bytes
    int     0x80                ; 32-bit Linux system call interrupt
    mov     eax, 1              ; system call number for sys_exit (32-bit)
    xor     ebx, ebx            ; exit code 0
    int     0x80                ; 32-bit Linux system call interrupt

section     .note.GNU-stack noalloc noexec nowrite progbits

section     .data
    message: db         "Hello, World Asm", 10  ; note the newline at the end

