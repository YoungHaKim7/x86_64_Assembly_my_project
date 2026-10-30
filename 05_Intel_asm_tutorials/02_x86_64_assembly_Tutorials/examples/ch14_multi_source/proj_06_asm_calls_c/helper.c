/* helper.c -- a C function called FROM assembly.
 * add3 follows the System V convention: a/b/c arrive in rdi/rsi/rdx and
 * the result returns in rax, so the assembly caller needs no glue. */
long add3(long a, long b, long c)
{
    return a + b + c;
}
