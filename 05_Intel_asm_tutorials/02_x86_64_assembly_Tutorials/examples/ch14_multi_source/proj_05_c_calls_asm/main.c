/* main.c -- C driver calling the assembly routine in power.asm */
#include <stdio.h>

long power(long base, long exp);       /* implemented in power.asm */

int main(void)
{
    printf("%ld^%ld = %ld\n", 2L, 10L, power(2, 10));
    return 0;
}
