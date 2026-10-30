; -----------------------------------------------------------------------------
; base + index addressing (scale 1): byte array access with [rbx+rcx]
;
; Demonstrates: base + index addressing on a byte array, movzx of a byte
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.2 (Addressing Mode Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_05_base_index_bytes.lst ch08_05_base_index_bytes.asm && ld -g -o ch08_05_base_index_bytes ch08_05_base_index_bytes.o
; Run:    ./ch08_05_base_index_bytes ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bArr        db 1, 2, 3, 4, 5           ; byte array: bArr[0..4]

section .text
global _start
_start:

; Base + index with NO scale term: bytes are addressed one byte per index,
; so the index register already IS the byte offset.  (The CPU default scale
; is 1; that is exactly what a byte array needs.)
    mov     rbx, bArr                      ; rbx = base address of bArr
    mov     rcx, 4                         ; rcx = index 4 (last element)
    movzx   edi, byte [rbx+rcx]            ; edi = bArr[4] = 5 (zero-extended)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
