# ch06_02.gdb -- GDB command file for ch06_02_step_vs_next
#
# Shows the difference between 'step' and 'next' on two 'call' instructions:
#   step (s) executes one line AND steps INTO the function being called
#   next (n) executes one line, running any called function to completion
#
# Run from this directory (after building the ch06_02 binary):
#     gdb -x ch06_02.gdb ./ch06_02
# Non-interactive variant:
#     gdb -batch -x ch06_02.gdb ./ch06_02

# never stop to ask yes/no questions or at a "--More--" prompt
set confirm off
set pagination off

# make 'step' enter called functions always
set step-mode on

file ch06_02
break _start
run

# we are stopped on 'call tenFn'
# step INTO tenFn: stop before its 'mov rax, 10'
step

# executes the mov; next behaves like step on a non-call line
next

# executes 'ret', landing back in _start
step

# executes 'mov rbx, rax' (no call on this line)
next

# NEXT runs 'call fifteenFn' to completion: the whole function executes
# and we stop on 'add rbx, rax' without ever seeing the inside
next

# finish the program (it exits with code 25)
continue
quit
