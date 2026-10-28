# Intel syntax (System V AMD64). rustc's global_asm! assembles Intel syntax by
# default on x86-64, so no syntax-switch directive is needed here (one would
# only be required when running this file through plain GNU `as`).

        .globl  maxofthree

        .text
maxofthree:
        mov     rax, rdi                # result (rax) initially holds x
        cmp     rax, rsi                # is x less than y?
        cmovl   rax, rsi                # if so, set result to y
        cmp     rax, rdx                # is max(x,y) less than z?
        cmovl   rax, rdx                # if so, set result to z
        ret                             # maximum is returned in rax

        # Mark stack as non-executable
        .section .note.GNU-stack,"",@progbits
