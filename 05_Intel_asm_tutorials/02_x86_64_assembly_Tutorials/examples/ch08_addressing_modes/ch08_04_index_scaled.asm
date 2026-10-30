; -----------------------------------------------------------------------------
; scaled index addressing: [dArr + rdi*4] indexes a dword array by element
;
; Demonstrates: [label + index register * scale] addressing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.1 (Addressing Modes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_04_index_scaled.lst ch08_04_index_scaled.asm && ld -g -o ch08_04_index_scaled ch08_04_index_scaled.o
; Run:    ./ch08_04_index_scaled ; echo $?        -> exit code: 40
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 10, 20, 30, 40          ; dword array: dArr[0..3]

section .text
global _start
_start:

; Index (scaled) addressing: the CPU computes  dArr + rdi*4  for us, where
; the scale 4 is the size of one dword element.  Keeping the ELEMENT index
; in a register (not the byte offset) makes loops trivial: inc/dec the index.
    mov     rdi, 3                         ; rdi = element index 3 (last)
    mov     eax, dword [dArr + rdi*4]      ; eax = dArr[3] = 40

; rdi held the index, so rebuild the exit code from the loaded value
    mov     edi, eax                       ; rdi = 40 (32-bit write clears rdi)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
