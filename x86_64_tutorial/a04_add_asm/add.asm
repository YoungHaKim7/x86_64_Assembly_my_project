; addition program on x86 assembly languague
;  by Shirshak Khatiwada
; Date : April 28th 2022

section .data

EXIT_SUCCESS equ 0 ;successful operation 
SYS_exit equ 60 ;call code for terminate


value1 db 20
value2 db 80
answer db 0

section .text
global _start
_start:

mov al,byte[value1]
mov bl,byte[value2]
add al,bl
mov byte[answer],al

last:
mov rax, SYS_exit ; Call code for exit
mov rdi, EXIT_SUCCESS ; Exit program with success
syscall