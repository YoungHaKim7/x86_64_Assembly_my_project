; -----------------------------------------------------------------------------
; Searching the environment -- finding "PATH=" among envp
;
; Demonstrates: envp array walk + prefix comparison
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 16.3 (envp follows argv's NULL)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_07.lst ch16_07_find_path_env.asm && ld -g -o ch16_07_find_path_env ch16_07_find_path_env.o
; Run:    ./ch16_07_find_path_env ; echo $?        -> exit code: 1
;
; envp = rsp + 8 + 8*argc + 8  (skip argc, all argv pointers, the NULL).
; Each entry is "NAME=value"; we test the first five bytes against PATH=.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    pathPrefix  db  "PATH="

section .text
global _start
_start:
    mov     rax, qword [rsp]           ; argc
    lea     rsi, [rsp + 8]             ; argv base
    lea     rsi, [rsi + rax*8 + 8]     ; skip argv pointers AND the NULL:
                                        ; rsi now -> first envp entry

.envLoop:
    mov     rdi, qword [rsi]           ; NULL terminates envp
    test    rdi, rdi
    jz      notFound

    ; ---- compare first 5 bytes with "PATH=" --------------------------------
    mov     al, byte [rdi]
    cmp     al, byte [pathPrefix]
    jne     .next
    mov     al, byte [rdi+1]
    cmp     al, byte [pathPrefix+1]
    jne     .next
    mov     al, byte [rdi+2]
    cmp     al, byte [pathPrefix+2]
    jne     .next
    mov     al, byte [rdi+3]
    cmp     al, byte [pathPrefix+3]
    jne     .next
    mov     al, byte [rdi+4]
    cmp     al, byte [pathPrefix+4]
    jne     .next
    jmp     found

.next:
    add     rsi, 8
    jmp     .envLoop

found:
    mov     rbx, 1
    jmp     last
notFound:
    xor     rbx, rbx

last:
    mov     rdi, rbx                    ; exit status = 1 when found
    mov     rax, SYS_exit
    syscall
