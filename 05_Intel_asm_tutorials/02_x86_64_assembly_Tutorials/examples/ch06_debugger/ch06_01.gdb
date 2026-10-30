# ch06_01.gdb -- GDB command file for ch06_01_debugger_demo (sum of 1..5)
#
# Run from this directory (after building the ch06_01 binary):
#     gdb -x ch06_01.gdb ./ch06_01
# Non-interactive variant:
#     gdb -batch -x ch06_01.gdb ./ch06_01

# never stop to ask yes/no questions or at a "--More--" prompt
set confirm off
set pagination off

file ch06_01
break _start
run
info registers
break last
continue
# use 'info registers rbx r12' here to see the final sum in r12
quit
