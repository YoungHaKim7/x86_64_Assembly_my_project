# x86-64 Assembly Examples

**~330 verified example programs** distilled from
**_x86-64 Assembly Language Programming with Ubuntu_** (Ed Jorgensen, v1.1.40, Jan 2020) —
the PDF ships alongside this collection in this repository.

Every program is written in the book's dialect — **YASM / NASM Intel syntax,
raw Linux syscalls, no libc** — and every program has been assembled, linked,
executed and checked by an automated test suite (335 checks, all passing).

```
make            # build every example into bin/   (needs yasm)
make test       # build + verify every example against its tests.txt
make clean      # remove bin/ and artifacts
```

If `yasm` is not installed system-wide:

```bash
mkdir -p ~/asm-tools && cd ~/asm-tools
apt-get download yasm && dpkg -x yasm_*.deb ~/asm-tools
export PATH="$HOME/asm-tools/usr/bin:$PATH"
```

Each example is a single self-contained `.asm` file (the `ch14` projects use
several files plus a `build.sh`). Build one by hand the book's way:

```bash
cd examples/ch07_arithmetic
yasm -f elf64 -g dwarf2 -l example.lst ch07_75_factorial.asm
ld -g -o ch07_75_factorial ch07_75_factorial.o
./ch07_75_factorial ; echo $?        # -> 120  (5!)
```

**Verifying results.**  Numeric examples report their result through the
process exit status (documented in each file header, always 0..255);
I/O examples print to stdout. Chapter directories carry a `tests.txt`
manifest consumed by `scripts/test.sh`.

## Architecture Overview (book ch. 2)

*Data sizes, register widths, little-endian memory, rFlags* — directory `examples/ch02_architecture/` (8 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch02_01_data_sizes.asm`](examples/ch02_architecture/ch02_01_data_sizes.asm) | Data sizes: db, dw, dd, dq occupy consecutive addresses |
| 2 | [`ch02_02_gpr_sizes.asm`](examples/ch02_architecture/ch02_02_gpr_sizes.asm) | Sub-registers: al is the low byte of ax/eax/rax |
| 3 | [`ch02_03_eax_zero_extend.asm`](examples/ch02_architecture/ch02_03_eax_zero_extend.asm) | 32-bit writes zero the upper half of the 64-bit register |
| 4 | [`ch02_04_ax_preserves_upper.asm`](examples/ch02_architecture/ch02_04_ax_preserves_upper.asm) | 16-bit writes preserve the upper bits of the register |
| 5 | [`ch02_05_little_endian.asm`](examples/ch02_architecture/ch02_05_little_endian.asm) | x86-64 memory is little-endian |
| 6 | [`ch02_06_bss_is_zero.asm`](examples/ch02_architecture/ch02_06_bss_is_zero.asm) | .bss memory arrives zero-filled |
| 7 | [`ch02_07_address_stride.asm`](examples/ch02_architecture/ch02_07_address_stride.asm) | Address arithmetic: array elements are sizeof(element) apart |
| 8 | [`ch02_08_rflags_carry_bit.asm`](examples/ch02_architecture/ch02_08_rflags_carry_bit.asm) | rFlags: the carry flag (CF) on 8-bit unsigned overflow |

## Data Representation (book ch. 3)

*Two's complement, carry vs overflow, IEEE-754 bits, ASCII* — directory `examples/ch03_data_representation/` (14 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch03_01_twos_complement_byte.asm`](examples/ch03_data_representation/ch03_01_twos_complement_byte.asm) | Two's complement negate of a byte |
| 2 | [`ch03_02_twos_complement_word.asm`](examples/ch03_data_representation/ch03_02_twos_complement_word.asm) | Two's complement negate of a word |
| 3 | [`ch03_03_twos_complement_dword.asm`](examples/ch03_data_representation/ch03_03_twos_complement_dword.asm) | Two's complement identity: NOT(d) + 1 == -d  (dword) |
| 4 | [`ch03_04_twos_complement_qword.asm`](examples/ch03_data_representation/ch03_04_twos_complement_qword.asm) | Two's complement negate of a qword sets the sign flag |
| 5 | [`ch03_05_sign_extension.asm`](examples/ch03_data_representation/ch03_05_sign_extension.asm) | Sign extension: byte -5 widened to a qword |
| 6 | [`ch03_06_unsigned_carry.asm`](examples/ch03_data_representation/ch03_06_unsigned_carry.asm) | Unsigned addition overflow: carry flag (CF) |
| 7 | [`ch03_07_signed_overflow.asm`](examples/ch03_data_representation/ch03_07_signed_overflow.asm) | Signed addition overflow: overflow flag (OF) |
| 8 | [`ch03_08_no_flags.asm`](examples/ch03_data_representation/ch03_08_no_flags.asm) | A small addition sets neither CF nor OF |
| 9 | [`ch03_09_ieee754_float_bits.asm`](examples/ch03_data_representation/ch03_09_ieee754_float_bits.asm) | IEEE-754 single precision: bit pattern of 1.0 |
| 10 | [`ch03_10_ieee754_double_bits.asm`](examples/ch03_data_representation/ch03_10_ieee754_double_bits.asm) | IEEE-754 double precision: bit pattern of 1.0 |
| 11 | [`ch03_11_ascii_codes.asm`](examples/ch03_data_representation/ch03_11_ascii_codes.asm) | Characters are small integers: the ASCII code of 'A' |
| 12 | [`ch03_12_ascii_case.asm`](examples/ch03_data_representation/ch03_12_ascii_case.asm) | ASCII case conversion: 'A' + 32 == 'a' |
| 13 | [`ch03_13_digit_chars.asm`](examples/ch03_data_representation/ch03_13_digit_chars.asm) | Digit characters: '7' - '0' == 7 and '0' + 9 == '9' |
| 14 | [`ch03_14_string_bytes.asm`](examples/ch03_data_representation/ch03_14_string_bytes.asm) | A string is a byte array: "Hi" and its length |

## Program Format (book ch. 4)

*.data/.bss/.text sections, db..dq, equ constants, number bases* — directory `examples/ch04_program_format/` (12 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch04_01_program_skeleton.asm`](examples/ch04_program_format/ch04_01_program_skeleton.asm) | Bare program skeleton: data, bss, text sections and _start |
| 2 | [`ch04_02_byte_variables.asm`](examples/ch04_program_format/ch04_02_byte_variables.asm) | Byte variables in the data section |
| 3 | [`ch04_03_word_variables.asm`](examples/ch04_program_format/ch04_03_word_variables.asm) | Word variables in the data section |
| 4 | [`ch04_04_dword_variables.asm`](examples/ch04_program_format/ch04_04_dword_variables.asm) | Dword variables in the data section |
| 5 | [`ch04_05_qword_variables.asm`](examples/ch04_program_format/ch04_05_qword_variables.asm) | Qword variables in the data section |
| 6 | [`ch04_06_mixed_sizes.asm`](examples/ch04_program_format/ch04_06_mixed_sizes.asm) | Mixing byte, word and dword variables |
| 7 | [`ch04_07_bss_variables.asm`](examples/ch04_program_format/ch04_07_bss_variables.asm) | Reserving space in the bss section |
| 8 | [`ch04_08_equ_constants.asm`](examples/ch04_program_format/ch04_08_equ_constants.asm) | Assembler-time constants with equ |
| 9 | [`ch04_09_string_variables.asm`](examples/ch04_program_format/ch04_09_string_variables.asm) | String variables and the $ - label length idiom |
| 10 | [`ch04_10_array_variables.asm`](examples/ch04_program_format/ch04_10_array_variables.asm) | Arrays are consecutive elements in the data section |
| 11 | [`ch04_11_float_variables.asm`](examples/ch04_program_format/ch04_11_float_variables.asm) | Floating-point variables stored as raw bit patterns |
| 12 | [`ch04_12_number_bases.asm`](examples/ch04_program_format/ch04_12_number_bases.asm) | Number bases in source code: hex, octal, decimal |

## DDD/GDB Debugger (book ch. 6)

*Breakpoint-friendly programs plus ready-to-run .gdb command files* — directory `examples/ch06_debugger/` (2 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch06_01_debugger_demo.asm`](examples/ch06_debugger/ch06_01_debugger_demo.asm) | A labeled loop made for breakpoint inspection (sum of 1..5) |
| 2 | [`ch06_02_step_vs_next.asm`](examples/ch06_debugger/ch06_02_step_vs_next.asm) | Function calls that show the difference between step and next |

## Instructions: Data Movement (book ch. 7)

*mov/xchg/movzx/movsx/movsxd, lea, addresses vs values* — directory `examples/ch07_data_movement/` (22 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch07_01_mov_imm_to_reg.asm`](examples/ch07_data_movement/ch07_01_mov_imm_to_reg.asm) | Loading constants: mov immediate into a register |
| 2 | [`ch07_02_mov_reg_to_reg.asm`](examples/ch07_data_movement/ch07_02_mov_reg_to_reg.asm) | Register to register mov: passing a value along a chain |
| 3 | [`ch07_03_mov_mem_to_reg.asm`](examples/ch07_data_movement/ch07_03_mov_mem_to_reg.asm) | Memory to register mov: reading a quadword variable |
| 4 | [`ch07_04_mov_reg_to_mem.asm`](examples/ch07_data_movement/ch07_04_mov_reg_to_mem.asm) | Register to memory mov: storing into a .bss variable |
| 5 | [`ch07_05_mov_operand_sizes.asm`](examples/ch07_data_movement/ch07_05_mov_operand_sizes.asm) | mov operand sizes: byte, word, and dword destinations |
| 6 | [`ch07_06_mov_imm_to_mem.asm`](examples/ch07_data_movement/ch07_06_mov_imm_to_mem.asm) | No memory-to-memory mov: values must travel through a register |
| 7 | [`ch07_07_xchg_registers.asm`](examples/ch07_data_movement/ch07_07_xchg_registers.asm) | xchg: swapping the contents of two registers |
| 8 | [`ch07_08_xchg_reg_mem.asm`](examples/ch07_data_movement/ch07_08_xchg_reg_mem.asm) | xchg with a memory operand: swapping a register and a variable |
| 9 | [`ch07_09_movzx_byte.asm`](examples/ch07_data_movement/ch07_09_movzx_byte.asm) | movzx: moving a byte with zero-extension |
| 10 | [`ch07_10_movzx_word.asm`](examples/ch07_data_movement/ch07_10_movzx_word.asm) | movzx: moving a word with zero-extension |
| 11 | [`ch07_11_movsx_byte.asm`](examples/ch07_data_movement/ch07_11_movsx_byte.asm) | movsx: moving a byte with sign-extension |
| 12 | [`ch07_12_movsx_word.asm`](examples/ch07_data_movement/ch07_12_movsx_word.asm) | movsx: moving a word with sign-extension |
| 13 | [`ch07_13_movsxd_dword.asm`](examples/ch07_data_movement/ch07_13_movsxd_dword.asm) | movsxd: sign-extending a dword into a 64-bit register |
| 14 | [`ch07_14_movzx_vs_movsx.asm`](examples/ch07_data_movement/ch07_14_movzx_vs_movsx.asm) | movzx vs movsx: the same byte, two interpretations |
| 15 | [`ch07_15_lea_address.asm`](examples/ch07_data_movement/ch07_15_lea_address.asm) | lea vs mov on a label: two ways to obtain an address |
| 16 | [`ch07_16_lea_arithmetic.asm`](examples/ch07_data_movement/ch07_16_lea_arithmetic.asm) | lea as an arithmetic shortcut: multiply by 3 without mul |
| 17 | [`ch07_17_lea_vs_mov_value.asm`](examples/ch07_data_movement/ch07_17_lea_vs_mov_value.asm) | lea gives the address, mov gives the value |
| 18 | [`ch07_18_label_address.asm`](examples/ch07_data_movement/ch07_18_label_address.asm) | A string label is an address: pointing at the first character |
| 19 | [`ch07_19_address_stride.asm`](examples/ch07_data_movement/ch07_19_address_stride.asm) | Address arithmetic: the byte stride of a qword array |
| 20 | [`ch07_20_eax_zero_extends.asm`](examples/ch07_data_movement/ch07_20_eax_zero_extends.asm) | Writing eax zeroes the upper half of rax |
| 21 | [`ch07_21_al_preserves_upper.asm`](examples/ch07_data_movement/ch07_21_al_preserves_upper.asm) | Writing al preserves the upper bits of rax |
| 22 | [`ch07_22_mem_via_registers.asm`](examples/ch07_data_movement/ch07_22_mem_via_registers.asm) | Base + index*scale addressing: array access through registers |

## Instructions: Integer Arithmetic (book ch. 7)

*add/adc/sub/sbb/neg, mul/imul/div/idiv, factorial/gcd/fib* — directory `examples/ch07_arithmetic/` (50 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch07_31_add_bytes.asm`](examples/ch07_arithmetic/ch07_31_add_bytes.asm) | add: byte-sized addition (100 + 155 = 255) |
| 2 | [`ch07_32_add_words.asm`](examples/ch07_arithmetic/ch07_32_add_words.asm) | add: word-sized addition (30000 + 123 = 30123) |
| 3 | [`ch07_33_add_dword_carry.asm`](examples/ch07_arithmetic/ch07_33_add_dword_carry.asm) | add: dword addition past the signed limit (0x7FFFFFFF + 1 = 0x80000000) |
| 4 | [`ch07_34_add_qwords.asm`](examples/ch07_arithmetic/ch07_34_add_qwords.asm) | add: quadword addition (1000000000000 + 1) |
| 5 | [`ch07_35_adc_carry_chain.asm`](examples/ch07_arithmetic/ch07_35_adc_carry_chain.asm) | adc: add-with-carry propagates a carry between qwords |
| 6 | [`ch07_36_add_128bit.asm`](examples/ch07_arithmetic/ch07_36_add_128bit.asm) | 128-bit addition: add + adc on a rdx:rax pair |
| 7 | [`ch07_37_add_carry_flag.asm`](examples/ch07_arithmetic/ch07_37_add_carry_flag.asm) | add: byte wraparound sets the carry flag (250 + 6) |
| 8 | [`ch07_38_sub_bytes.asm`](examples/ch07_arithmetic/ch07_38_sub_bytes.asm) | sub: byte-sized subtraction (255 - 55 = 200) |
| 9 | [`ch07_39_sub_words.asm`](examples/ch07_arithmetic/ch07_39_sub_words.asm) | sub: word-sized subtraction (1000 - 388 = 612) |
| 10 | [`ch07_40_sub_borrow.asm`](examples/ch07_arithmetic/ch07_40_sub_borrow.asm) | sub: unsigned borrow (5 - 7 wraps to 254) |
| 11 | [`ch07_41_sbb_128bit.asm`](examples/ch07_arithmetic/ch07_41_sbb_128bit.asm) | sbb: 128-bit subtraction (2^64 - 1) with borrow propagation |
| 12 | [`ch07_42_sub_128bit_small.asm`](examples/ch07_arithmetic/ch07_42_sub_128bit_small.asm) | sbb: 128-bit subtraction that needs no borrow (100 - 1) |
| 13 | [`ch07_43_inc_byte.asm`](examples/ch07_arithmetic/ch07_43_inc_byte.asm) | inc: increment a byte (254 -> 255) |
| 14 | [`ch07_44_dec_wrap.asm`](examples/ch07_arithmetic/ch07_44_dec_wrap.asm) | dec: decrement below zero wraps a byte (0 -> 255) |
| 15 | [`ch07_45_neg_byte.asm`](examples/ch07_arithmetic/ch07_45_neg_byte.asm) | neg: negate a byte (5 -> -5 = 0xFB) |
| 16 | [`ch07_46_neg_qword.asm`](examples/ch07_arithmetic/ch07_46_neg_qword.asm) | neg: negate a qword (-100 -> 100) |
| 17 | [`ch07_47_neg_zero.asm`](examples/ch07_arithmetic/ch07_47_neg_zero.asm) | neg: negating zero leaves zero and sets ZF |
| 18 | [`ch07_48_inc_preserves_carry.asm`](examples/ch07_arithmetic/ch07_48_inc_preserves_carry.asm) | inc/dec quirk: they do NOT touch the carry flag |
| 19 | [`ch07_49_abs_value.asm`](examples/ch07_arithmetic/ch07_49_abs_value.asm) | abs: absolute value of a qword via neg (-77 -> 77) |
| 20 | [`ch07_50_cmp_semantics.asm`](examples/ch07_arithmetic/ch07_50_cmp_semantics.asm) | cmp: compare sets flags without changing either operand |
| 21 | [`ch07_51_three_way_sum.asm`](examples/ch07_arithmetic/ch07_51_three_way_sum.asm) | chained add: three-way sum of bytes (100 + 100 + 55 = 255) |
| 22 | [`ch07_52_saturating_add.asm`](examples/ch07_arithmetic/ch07_52_saturating_add.asm) | saturating add: clamp a byte sum instead of wrapping (200 + 100 -> 255) |
| 23 | [`ch07_53_mul_qword.asm`](examples/ch07_arithmetic/ch07_53_mul_qword.asm) | mul (one operand, quadword): 12 * 11 = 132 |
| 24 | [`ch07_54_mul_byte.asm`](examples/ch07_arithmetic/ch07_54_mul_byte.asm) | mul (byte form): al = 12, mul bl (11) -> ax = 132 |
| 25 | [`ch07_55_mul_word_dxax.asm`](examples/ch07_arithmetic/ch07_55_mul_word_dxax.asm) | mul (word form): 300 * 400 = 120000, product split across dx:ax |
| 26 | [`ch07_56_mul_dword_edxeax.asm`](examples/ch07_arithmetic/ch07_56_mul_dword_edxeax.asm) | mul (double-word form): 3000000000 * 2 = 6000000000, product in edx:eax |
| 27 | [`ch07_57_mul_overflow_rdx.asm`](examples/ch07_arithmetic/ch07_57_mul_overflow_rdx.asm) | mul overflow detection: 2^40 * 2^30 -> rdx != 0 means result overflows 64 bits |
| 28 | [`ch07_58_mul_vs_shift.asm`](examples/ch07_arithmetic/ch07_58_mul_vs_shift.asm) | Multiply vs shift: 7 * 8 by mul equals 7 shl 3 (both give 56) |
| 29 | [`ch07_59_imul_one_operand.asm`](examples/ch07_arithmetic/ch07_59_imul_one_operand.asm) | imul (one operand, quadword): -6 * 7 = -42 (signed) |
| 30 | [`ch07_60_imul_two_operand.asm`](examples/ch07_arithmetic/ch07_60_imul_two_operand.asm) | imul (two operand): imul rbx, rcx -- 13 * 9 = 117 |
| 31 | [`ch07_61_imul_three_operand.asm`](examples/ch07_arithmetic/ch07_61_imul_three_operand.asm) | imul (three operand): imul rbx, rax, 21 -- 12 * 21 = 252 |
| 32 | [`ch07_62_imul_negatives.asm`](examples/ch07_arithmetic/ch07_62_imul_negatives.asm) | imul with negative operands: (-5) * (-5) = +25 |
| 33 | [`ch07_63_signed_vs_unsigned_mul.asm`](examples/ch07_arithmetic/ch07_63_signed_vs_unsigned_mul.asm) | Signed vs unsigned byte multiply: 0xFE * 2 as mul (254*2) and imul (-2*2) |
| 34 | [`ch07_64_div_qword.asm`](examples/ch07_arithmetic/ch07_64_div_qword.asm) | div (quadword): 137 / 10 -> quotient 13, remainder 7 |
| 35 | [`ch07_65_div_byte.asm`](examples/ch07_arithmetic/ch07_65_div_byte.asm) | div (byte form): ax = 137, div bl (10) -> al = 13, ah = 7 |
| 36 | [`ch07_66_div_word.asm`](examples/ch07_arithmetic/ch07_66_div_word.asm) | div (word form): 12345 / 100 -> quotient 123, remainder 45 (dx:ax) |
| 37 | [`ch07_67_div_dword.asm`](examples/ch07_arithmetic/ch07_67_div_dword.asm) | div (double-word form): 1000000 / 7 -> quotient 142857, remainder 1 |
| 38 | [`ch07_68_div_edx_must_be_zero.asm`](examples/ch07_arithmetic/ch07_68_div_edx_must_be_zero.asm) | div: edx MUST be zeroed before a double-word divide (avoiding the #DE trap) |
| 39 | [`ch07_69_idiv_positive.asm`](examples/ch07_arithmetic/ch07_69_idiv_positive.asm) | idiv (positive operands): 137 / 10 -> quotient 13, remainder 7 |
| 40 | [`ch07_70_idiv_negative.asm`](examples/ch07_arithmetic/ch07_70_idiv_negative.asm) | idiv (negative dividend): -137 / 10 -> quotient -13, remainder -7 |
| 41 | [`ch07_71_cqo_idiv.asm`](examples/ch07_arithmetic/ch07_71_cqo_idiv.asm) | cqo + idiv: -100 / 3 -> quotient -33, remainder -1 |
| 42 | [`ch07_72_cdq_idiv_dword.asm`](examples/ch07_arithmetic/ch07_72_cdq_idiv_dword.asm) | cdq + idiv (double-word): eax = -100, idiv by 3 -> quotient -33 |
| 43 | [`ch07_73_modulo_power_of_two.asm`](examples/ch07_arithmetic/ch07_73_modulo_power_of_two.asm) | Modulo a power of two: 100 mod 16 via AND (100 and 0xF = 4) |
| 44 | [`ch07_74_div_by_shift.asm`](examples/ch07_arithmetic/ch07_74_div_by_shift.asm) | Divide by a power of two with a shift: 200 shr 2 = 50 |
| 45 | [`ch07_75_factorial.asm`](examples/ch07_arithmetic/ch07_75_factorial.asm) | Factorial (iterative): 5! = 5*4*3*2*1 = 120 |
| 46 | [`ch07_76_fibonacci.asm`](examples/ch07_arithmetic/ch07_76_fibonacci.asm) | Fibonacci (iterative): fib(11) = 89 |
| 47 | [`ch07_77_gcd_euclid.asm`](examples/ch07_arithmetic/ch07_77_gcd_euclid.asm) | Euclid's GCD algorithm: gcd(252, 105) = 21 |
| 48 | [`ch07_78_power.asm`](examples/ch07_arithmetic/ch07_78_power.asm) | Integer power (iterative): 3^4 = 81 |
| 49 | [`ch07_79_sum_1_to_n.asm`](examples/ch07_arithmetic/ch07_79_sum_1_to_n.asm) | Sum 1..n with a loop: 1+2+...+20 = 210 |
| 50 | [`ch07_80_average.asm`](examples/ch07_arithmetic/ch07_80_average.asm) | Integer average of {7, 9, 4}: (7+9+4)/3 = 20/3 = 6 |

## Instructions: Logical & Shift (book ch. 7)

*and/or/xor/test/bt/bts, shl/shr/sar, rol/ror/rcl, bswap, popcount* — directory `examples/ch07_logical/` (30 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch07_100_sar_signed_div.asm`](examples/ch07_logical/ch07_100_sar_signed_div.asm) | SAR as signed divide-by-4: -100 sar 2 = -25 (byte 231) |
| 2 | [`ch07_101_sar_vs_shr_neg.asm`](examples/ch07_logical/ch07_101_sar_vs_shr_neg.asm) | SAR vs SHR on -1 (byte): 0xFF sar 4 -> 0xFF (255), shr 4 -> 0x0F (15) |
| 3 | [`ch07_102_shl_128bit.asm`](examples/ch07_logical/ch07_102_shl_128bit.asm) | 128-bit shift left: (rdx:rax = 0:0xFFFFFFFFFFFFFFFF) shl 1 -> rdx = 1 |
| 4 | [`ch07_103_rol_byte.asm`](examples/ch07_logical/ch07_103_rol_byte.asm) | ROL a byte by 1: 0x81 rol 1 -> 0x03 (MSB wraps around to bit 0) |
| 5 | [`ch07_104_ror_byte.asm`](examples/ch07_logical/ch07_104_ror_byte.asm) | ROR a byte by 1: 0x81 ror 1 -> 0xC0 = 192 (LSB wraps to bit 7) |
| 6 | [`ch07_105_rol_nibble_swap.asm`](examples/ch07_logical/ch07_105_rol_nibble_swap.asm) | Swap the nibbles of a byte: 0x12 rol 4 -> 0x21 = 33 |
| 7 | [`ch07_106_rcl_carry.asm`](examples/ch07_logical/ch07_106_rcl_carry.asm) | RCL rotates through carry: stc; 0x7F rcl 1 -> 0xFF = 255 |
| 8 | [`ch07_107_rcr_carry.asm`](examples/ch07_logical/ch07_107_rcr_carry.asm) | RCR rotates through carry: 0xFE rcr 1 -> 0x7F = 127 (with CF = 0) |
| 9 | [`ch07_108_bswap32.asm`](examples/ch07_logical/ch07_108_bswap32.asm) | BSWAP a dword: 0x12345678 -> 0x78563412 (little <-> big endian) |
| 10 | [`ch07_109_popcount_loop.asm`](examples/ch07_logical/ch07_109_popcount_loop.asm) | Population count by loop: 0xB6 (1011 0110) has 5 one bits |
| 11 | [`ch07_110_round_up_pow2.asm`](examples/ch07_logical/ch07_110_round_up_pow2.asm) | Round up to the next power of two: 70 -> 128 |
| 12 | [`ch07_81_and_mask_nibble.asm`](examples/ch07_logical/ch07_81_and_mask_nibble.asm) | AND as a bit mask: 0xAB and 0x0F keeps the low nibble -> 0x0B |
| 13 | [`ch07_82_and_clear_bits.asm`](examples/ch07_logical/ch07_82_and_clear_bits.asm) | AND to clear the upper bits of a byte: 0xFF and 0x3F -> 0x3F (63) |
| 14 | [`ch07_83_or_set_bits.asm`](examples/ch07_logical/ch07_83_or_set_bits.asm) | OR to set selected bits: 0x0A or 0x40 -> 0x4A (74) |
| 15 | [`ch07_84_or_combine_flags.asm`](examples/ch07_logical/ch07_84_or_combine_flags.asm) | OR to combine permission bits: READ(4) or WRITE(2) -> rw = 6 |
| 16 | [`ch07_85_xor_toggle.asm`](examples/ch07_logical/ch07_85_xor_toggle.asm) | XOR to invert bits: 0xF0 xor 0xFF -> 0x0F (15) |
| 17 | [`ch07_86_xor_zero.asm`](examples/ch07_logical/ch07_86_xor_zero.asm) | XOR a register with itself: the classic way to zero it (fastest, shortest) |
| 18 | [`ch07_87_not_invert.asm`](examples/ch07_logical/ch07_87_not_invert.asm) | NOT: one's complement of a byte, 0x0F -> 0xF0 (240) |
| 19 | [`ch07_88_and_extract_bit.asm`](examples/ch07_logical/ch07_88_and_extract_bit.asm) | Extract one bit: (0x2A shr 5) and 1 -> 1 (bit 5 of 0x2A is set) |
| 20 | [`ch07_89_test_zero.asm`](examples/ch07_logical/ch07_89_test_zero.asm) | TEST a register against itself: rbx = 0 -> ZF set -> jz taken |
| 21 | [`ch07_90_test_mask.asm`](examples/ch07_logical/ch07_90_test_mask.asm) | TEST with a mask: 0x0A and 0x40 share no bits -> ZF set, jnz not taken |
| 22 | [`ch07_91_bt_register.asm`](examples/ch07_logical/ch07_91_bt_register.asm) | BT on a register: bt rax,3 with rax=8 -> CF=1, jc taken |
| 23 | [`ch07_92_bt_memory.asm`](examples/ch07_logical/ch07_92_bt_memory.asm) | BT on memory: bit 70 of a bit string in memory -> CF=1 |
| 24 | [`ch07_93_bts_set_bit.asm`](examples/ch07_logical/ch07_93_bts_set_bit.asm) | BTS: set a bit and verify it -- bts rax,4 then bt -> CF=1 |
| 25 | [`ch07_94_btr_clear_bit.asm`](examples/ch07_logical/ch07_94_btr_clear_bit.asm) | BTR: clear a set bit -- btr rax,5 on rax=0x20 -> bit now clear |
| 26 | [`ch07_95_btc_toggle_twice.asm`](examples/ch07_logical/ch07_95_btc_toggle_twice.asm) | BTC twice restores the original bit: 1 -> 0 -> 1 |
| 27 | [`ch07_96_shl_multiply_2.asm`](examples/ch07_logical/ch07_96_shl_multiply_2.asm) | SHL as multiply-by-2: 21 shl 1 = 42 (double a value) |
| 28 | [`ch07_97_shl_multiply_8.asm`](examples/ch07_logical/ch07_97_shl_multiply_8.asm) | SHL as multiply-by-8: 5 shl 3 = 40 |
| 29 | [`ch07_98_shr_divide_4.asm`](examples/ch07_logical/ch07_98_shr_divide_4.asm) | SHR as unsigned divide-by-4: 100 shr 2 = 25 |
| 30 | [`ch07_99_shr_logical.asm`](examples/ch07_logical/ch07_99_shr_logical.asm) | SHR is a LOGICAL shift: zeros enter from the top (0xFF shr 4 = 0x0F) |

## Instructions: Control Flow (book ch. 7)

*jcc signed/unsigned, loop/loope, cmovcc, setcc, binary search* — directory `examples/ch07_control/` (46 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch07_111_jmp_skip.asm`](examples/ch07_control/ch07_111_jmp_skip.asm) | Unconditional jmp: hop over an instruction that would change the result |
| 2 | [`ch07_112_backward_jump.asm`](examples/ch07_control/ch07_112_backward_jump.asm) | Backward jump: a tiny loop whose body runs exactly three times |
| 3 | [`ch07_113_cmp_je.asm`](examples/ch07_control/ch07_113_cmp_je.asm) | cmp + je: jump when two values are equal |
| 4 | [`ch07_114_cmp_jne.asm`](examples/ch07_control/ch07_114_cmp_jne.asm) | cmp + jne: jump when two values differ |
| 5 | [`ch07_115_signed_jl.asm`](examples/ch07_control/ch07_115_signed_jl.asm) | Signed comparison: jl (jump if less) with a negative operand |
| 6 | [`ch07_116_signed_jg.asm`](examples/ch07_control/ch07_116_signed_jg.asm) | Signed comparison: jg (jump if greater) |
| 7 | [`ch07_117_signed_jle_jge.asm`](examples/ch07_control/ch07_117_signed_jle_jge.asm) | Equal values satisfy BOTH jge and jle |
| 8 | [`ch07_118_unsigned_jb.asm`](examples/ch07_control/ch07_118_unsigned_jb.asm) | Unsigned comparison: jb (jump if below) |
| 9 | [`ch07_119_unsigned_ja.asm`](examples/ch07_control/ch07_119_unsigned_ja.asm) | Unsigned comparison: ja (jump if above) |
| 10 | [`ch07_120_signed_vs_unsigned.asm`](examples/ch07_control/ch07_120_signed_vs_unsigned.asm) | The SAME bits, two different orders: signed vs unsigned jumps |
| 11 | [`ch07_121_js_negative.asm`](examples/ch07_control/ch07_121_js_negative.asm) | js: jump if the sign flag is set (result is negative) |
| 12 | [`ch07_122_jo_overflow.asm`](examples/ch07_control/ch07_122_jo_overflow.asm) | jo: jump if the overflow flag signals signed overflow |
| 13 | [`ch07_123_jc_carry.asm`](examples/ch07_control/ch07_123_jc_carry.asm) | jc: jump if the carry flag signals unsigned overflow |
| 14 | [`ch07_124_jz_after_sub.asm`](examples/ch07_control/ch07_124_jz_after_sub.asm) | jz: jump when a subtraction produces zero |
| 15 | [`ch07_125_max_of_three.asm`](examples/ch07_control/ch07_125_max_of_three.asm) | Largest of three values with a cmp/jle chain |
| 16 | [`ch07_126_min_of_three.asm`](examples/ch07_control/ch07_126_min_of_three.asm) | Smallest of three values with a cmp/jge chain |
| 17 | [`ch07_127_loop_countdown.asm`](examples/ch07_control/ch07_127_loop_countdown.asm) | The loop instruction: rcx as a built-in countdown counter |
| 18 | [`ch07_128_loop_sum.asm`](examples/ch07_control/ch07_128_loop_sum.asm) | Summing 1..10 with the loop instruction |
| 19 | [`ch07_129_loope_scan.asm`](examples/ch07_control/ch07_129_loope_scan.asm) | loope/loopz: scan an array while elements keep matching (ZF = 1) |
| 20 | [`ch07_130_loopne_scan.asm`](examples/ch07_control/ch07_130_loopne_scan.asm) | loopne/loopnz: scan an array while elements keep NOT matching (ZF = 0) |
| 21 | [`ch07_131_cmovl_min.asm`](examples/ch07_control/ch07_131_cmovl_min.asm) | cmovl -- conditional move on signed less-than (pick the minimum) |
| 22 | [`ch07_132_cmovg_max.asm`](examples/ch07_control/ch07_132_cmovg_max.asm) | cmovg -- conditional move on signed greater (pick the maximum) |
| 23 | [`ch07_133_cmovb_unsigned.asm`](examples/ch07_control/ch07_133_cmovb_unsigned.asm) | cmovb -- conditional move on unsigned below (unsigned minimum) |
| 24 | [`ch07_134_cmove_equal.asm`](examples/ch07_control/ch07_134_cmove_equal.asm) | cmove -- conditional move on equal (select a default when values match) |
| 25 | [`ch07_135_cmovs_abs.asm`](examples/ch07_control/ch07_135_cmovs_abs.asm) | cmovs / cmovns -- branchless absolute value |
| 26 | [`ch07_136_cmov_median.asm`](examples/ch07_control/ch07_136_cmov_median.asm) | cmov chain -- median of three values, fully branchless |
| 27 | [`ch07_137_cmov_clamp.asm`](examples/ch07_control/ch07_137_cmov_clamp.asm) | cmova -- clamping a value to an upper limit |
| 28 | [`ch07_138_sete.asm`](examples/ch07_control/ch07_138_sete.asm) | sete -- capture the equal flag into a register |
| 29 | [`ch07_139_setne.asm`](examples/ch07_control/ch07_139_setne.asm) | setne -- capture the not-equal flag into a register |
| 30 | [`ch07_140_setl_setg.asm`](examples/ch07_control/ch07_140_setl_setg.asm) | setl + setg -- signed comparison outcomes side by side |
| 31 | [`ch07_141_setb_seta.asm`](examples/ch07_control/ch07_141_setb_seta.asm) | seta / setb -- unsigned comparison outcomes |
| 32 | [`ch07_142_sets_setns.asm`](examples/ch07_control/ch07_142_sets_setns.asm) | sets + setns -- reading the sign of values via flags |
| 33 | [`ch07_143_classify_sign.asm`](examples/ch07_control/ch07_143_classify_sign.asm) | Sign classification -- negative / zero / positive via test + jcc |
| 34 | [`ch07_144_leap_year.asm`](examples/ch07_control/ch07_144_leap_year.asm) | Leap year test -- (div by 4 and not by 100) or (div by 400) |
| 35 | [`ch07_145_is_digit.asm`](examples/ch07_control/ch07_145_is_digit.asm) | isDigit -- range test for '0'..'9' |
| 36 | [`ch07_146_is_upper.asm`](examples/ch07_control/ch07_146_is_upper.asm) | isUpper -- range test for 'A'..'Z' |
| 37 | [`ch07_147_is_lower.asm`](examples/ch07_control/ch07_147_is_lower.asm) | isLower -- range test for 'a'..'z' |
| 38 | [`ch07_148_is_vowel.asm`](examples/ch07_control/ch07_148_is_vowel.asm) | isVowel -- membership test against a small set |
| 39 | [`ch07_149_to_upper.asm`](examples/ch07_control/ch07_149_to_upper.asm) | Conditional case conversion -- uppercase only what is lowercase |
| 40 | [`ch07_150_nested_loops_mul.asm`](examples/ch07_control/ch07_150_nested_loops_mul.asm) | Nested loops -- multiplication as repeated addition |
| 41 | [`ch07_151_binary_search.asm`](examples/ch07_control/ch07_151_binary_search.asm) | Binary search -- halving an ordered array until the key is found |
| 42 | [`ch07_152_count_even.asm`](examples/ch07_control/ch07_152_count_even.asm) | Counting evens -- test/jz over an array |
| 43 | [`ch07_153_count_negative.asm`](examples/ch07_control/ch07_153_count_negative.asm) | Counting negatives -- signed test over an array |
| 44 | [`ch07_154_sum_digits.asm`](examples/ch07_control/ch07_154_sum_digits.asm) | Sum of decimal digits -- div-by-10 loop peeling digits |
| 45 | [`ch07_155_collatz_steps.asm`](examples/ch07_control/ch07_155_collatz_steps.asm) | Collatz steps -- while-loop until the sequence reaches 1 |
| 46 | [`ch07_156_jump_table.asm`](examples/ch07_control/ch07_156_jump_table.asm) | Jump table -- dispatch via indirect jmp through a qword table |

## Addressing Modes (book ch. 8)

*displacement..scale+disp, array sums/min/max, 2-D indexing* — directory `examples/ch08_addressing_modes/` (18 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch08_01_displacement.asm`](examples/ch08_addressing_modes/ch08_01_displacement.asm) | displacement addressing: mov rax, [qArr+8] loads element 1 of a qword array |
| 2 | [`ch08_02_register_indirect.asm`](examples/ch08_addressing_modes/ch08_02_register_indirect.asm) | register indirect addressing: the address of qArr[0] is held in rbx |
| 3 | [`ch08_03_base_displacement.asm`](examples/ch08_addressing_modes/ch08_03_base_displacement.asm) | base + displacement addressing: rbx holds the base, +16 selects qArr[2] |
| 4 | [`ch08_04_index_scaled.asm`](examples/ch08_addressing_modes/ch08_04_index_scaled.asm) | scaled index addressing: [dArr + rdi*4] indexes a dword array by element |
| 5 | [`ch08_05_base_index_bytes.asm`](examples/ch08_addressing_modes/ch08_05_base_index_bytes.asm) | base + index addressing (scale 1): byte array access with [rbx+rcx] |
| 6 | [`ch08_06_base_index_scale.asm`](examples/ch08_addressing_modes/ch08_06_base_index_scale.asm) | base + index*scale addressing: [rbx + rcx*8] selects a qword element |
| 7 | [`ch08_07_scale_and_disp.asm`](examples/ch08_addressing_modes/ch08_07_scale_and_disp.asm) | scale + displacement addressing: [dArr + rcx*4 + 8] reaches dArr[3] |
| 8 | [`ch08_08_byte_array_sum.asm`](examples/ch08_addressing_modes/ch08_08_byte_array_sum.asm) | byte array summation: sum of {1,2,3,4,5} using base+index addressing |
| 9 | [`ch08_09_word_array_sum.asm`](examples/ch08_addressing_modes/ch08_09_word_array_sum.asm) | word array summation: sum of {90,95,70} using scaled index addressing |
| 10 | [`ch08_10_dword_array_sum.asm`](examples/ch08_addressing_modes/ch08_10_dword_array_sum.asm) | dword list summation: the book's List Summation example (sum = 150) |
| 11 | [`ch08_11_qword_array_sum.asm`](examples/ch08_addressing_modes/ch08_11_qword_array_sum.asm) | qword array summation: sum of {5,10,15,20} with 64-bit scaled indexing |
| 12 | [`ch08_12_array_average.asm`](examples/ch08_addressing_modes/ch08_12_array_average.asm) | list average: (10+20+30+40+50)/5 = 30 via summation then unsigned divide |
| 13 | [`ch08_13_array_max.asm`](examples/ch08_addressing_modes/ch08_13_array_max.asm) | list maximum: max of {12,45,7,88,23} = 88 via compare-and-replace loop |
| 14 | [`ch08_14_array_min.asm`](examples/ch08_addressing_modes/ch08_14_array_min.asm) | list minimum: min of {12,45,7,88,23} = 7 via compare-and-replace loop |
| 15 | [`ch08_15_reverse_copy.asm`](examples/ch08_addressing_modes/ch08_15_reverse_copy.asm) | reverse copy: copy {1,2,3,4,5} into a bss array in reverse order |
| 16 | [`ch08_16_2d_row_sum.asm`](examples/ch08_addressing_modes/ch08_16_2d_row_sum.asm) | 2-D array row sum: sum row 1 ({4,5,6}) of a 3x3 dword matrix = 15 |
| 17 | [`ch08_17_2d_element.asm`](examples/ch08_addressing_modes/ch08_17_2d_element.asm) | 2-D array element: fetch matrix[1][2] = 6 via base + row*COLS*4 + col*4 |
| 18 | [`ch08_18_count_char.asm`](examples/ch08_addressing_modes/ch08_18_count_char.asm) | character counting: count the 's' characters in "mississippi" (4) |

## Process Stack (book ch. 9)

*push/pop, pushfq, rsp work areas, rbp frames, LIFO patterns* — directory `examples/ch09_stack/` (14 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch09_01_push_pop.asm`](examples/ch09_stack/ch09_01_push_pop.asm) | push and pop basics: push 42 onto the stack, pop it back into rbx |
| 2 | [`ch09_02_lifo_order.asm`](examples/ch09_stack/ch09_02_lifo_order.asm) | LIFO order: pushes 1,2,3 come back off the stack as 3,2,1 |
| 3 | [`ch09_03_save_restore.asm`](examples/ch09_stack/ch09_03_save_restore.asm) | save/restore pattern: push rbx before clobbering it, pop it back after |
| 4 | [`ch09_04_pushfq_popfq.asm`](examples/ch09_stack/ch09_04_pushfq_popfq.asm) | pushfq/popfq: save the rflags register across flag-destroying code |
| 5 | [`ch09_05_push_memory.asm`](examples/ch09_stack/ch09_05_push_memory.asm) | pushing memory: push qword [qVar] then pop it into a register |
| 6 | [`ch09_06_sub_rsp_workspace.asm`](examples/ch09_stack/ch09_06_sub_rsp_workspace.asm) | stack workspace: sub rsp,32 reserves three qword scratch slots |
| 7 | [`ch09_07_stack_temporaries.asm`](examples/ch09_stack/ch09_07_stack_temporaries.asm) | stack temporaries: (10+20)*(3-1) = 60 with intermediates kept on the stack |
| 8 | [`ch09_08_nested_pushes.asm`](examples/ch09_stack/ch09_08_nested_pushes.asm) | nested pushes: two nesting levels, inner value popped before outer value |
| 9 | [`ch09_09_swap_via_stack.asm`](examples/ch09_stack/ch09_09_swap_via_stack.asm) | swap via the stack: exchange a=4 and b=9 stored in memory |
| 10 | [`ch09_10_reverse_array.asm`](examples/ch09_stack/ch09_10_reverse_array.asm) | reverse an array with the stack: push {1,2,3,4,5}, pop into bss array |
| 11 | [`ch09_11_stack_sum.asm`](examples/ch09_stack/ch09_11_stack_sum.asm) | stack sum: push {1,2,3,4,5} then accumulate the values while popping |
| 12 | [`ch09_12_rbp_frame.asm`](examples/ch09_stack/ch09_12_rbp_frame.asm) | rbp stack frame: two local variables at [rbp-8] and [rbp-16], sum = 25 |
| 13 | [`ch09_13_rsp_balance.asm`](examples/ch09_stack/ch09_13_rsp_balance.asm) | rsp balance: rsp must return to its starting value after pop matches push |
| 14 | [`ch09_14_rflags_carry_bit.asm`](examples/ch09_stack/ch09_14_rflags_carry_bit.asm) | rflags carry bit: read CF as bit 0 of the pushed rflags image |

## Macros (book ch. 11)

*%define, %macro/%endmacro, %%labels, macro library include* — directory `examples/ch11_macros/` (8 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch11_01_single_line_macro.asm`](examples/ch11_macros/ch11_01_single_line_macro.asm) | Single-line macro defined with %define (one parameter) |
| 2 | [`ch11_02_macro_params.asm`](examples/ch11_macros/ch11_02_macro_params.asm) | Single-line macro with two parameters (constant and register arguments) |
| 3 | [`ch11_03_multiline_macro.asm`](examples/ch11_macros/ch11_03_multiline_macro.asm) | Multi-line macro (%macro / %endmacro) used twice |
| 4 | [`ch11_04_macro_local_labels.asm`](examples/ch11_macros/ch11_04_macro_local_labels.asm) | Macro-local labels (%%) -- same macro expanded twice |
| 5 | [`ch11_05_equ_vs_define.asm`](examples/ch11_macros/ch11_05_equ_vs_define.asm) | equ constants combined with %define macros |
| 6 | [`ch11_06_exit_macro.asm`](examples/ch11_macros/ch11_06_exit_macro.asm) | A multi-line macro that wraps the exit system call |
| 7 | [`ch11_07_macro_library.asm`](examples/ch11_macros/ch11_07_macro_library.asm) | Using a macro library kept in a separate include file |
| 8 | [`ch11_08_conditional_assemble.asm`](examples/ch11_macros/ch11_08_conditional_assemble.asm) | Conditional assembly with %if / %else / %endif |

## Functions & Calling Convention (book ch. 12)

*leaf/non-leaf, six args + stack args, recursion, sort/search* — directory `examples/ch12_functions/` (30 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch12_01_leaf_function.asm`](examples/ch12_functions/ch12_01_leaf_function.asm) | Leaf function: call and ret |
| 2 | [`ch12_02_one_argument.asm`](examples/ch12_functions/ch12_02_one_argument.asm) | Function with one argument |
| 3 | [`ch12_03_two_arguments.asm`](examples/ch12_functions/ch12_03_two_arguments.asm) | Function with two arguments |
| 4 | [`ch12_04_six_arguments.asm`](examples/ch12_functions/ch12_04_six_arguments.asm) | Function with six register arguments |
| 5 | [`ch12_05_seventh_argument_stack.asm`](examples/ch12_functions/ch12_05_seventh_argument_stack.asm) | Seventh argument passed on the stack |
| 6 | [`ch12_06_two_return_values.asm`](examples/ch12_functions/ch12_06_two_return_values.asm) | Function returning two values (rax and rdx) |
| 7 | [`ch12_07_callee_saved_rbx.asm`](examples/ch12_functions/ch12_07_callee_saved_rbx.asm) | Preserving a callee-saved register (rbx) across a function call |
| 8 | [`ch12_08_callee_saved_r12.asm`](examples/ch12_functions/ch12_08_callee_saved_r12.asm) | Preserving a callee-saved register (r12) across a function call |
| 9 | [`ch12_09_non_leaf_function.asm`](examples/ch12_functions/ch12_09_non_leaf_function.asm) | Non-leaf function: a function that calls another function |
| 10 | [`ch12_10_stack_local_vars.asm`](examples/ch12_functions/ch12_10_stack_local_vars.asm) | Stack-based local variables |
| 11 | [`ch12_11_local_array.asm`](examples/ch12_functions/ch12_11_local_array.asm) | Local array allocated on the stack |
| 12 | [`ch12_12_recursive_factorial.asm`](examples/ch12_functions/ch12_12_recursive_factorial.asm) | Recursive factorial |
| 13 | [`ch12_13_recursive_fibonacci.asm`](examples/ch12_functions/ch12_13_recursive_fibonacci.asm) | Recursive Fibonacci (double recursion) |
| 14 | [`ch12_14_recursive_sum.asm`](examples/ch12_functions/ch12_14_recursive_sum.asm) | Recursive summation 1 + 2 + ... + n |
| 15 | [`ch12_15_sum_of_squares.asm`](examples/ch12_functions/ch12_15_sum_of_squares.asm) | Sum of squares (book-style statistical leaf function) |
| 16 | [`ch12_16_array_sum_function.asm`](examples/ch12_functions/ch12_16_array_sum_function.asm) | Array sum function (array address and length as arguments) |
| 17 | [`ch12_17_array_max_function.asm`](examples/ch12_functions/ch12_17_array_max_function.asm) | Array maximum function |
| 18 | [`ch12_18_array_average_function.asm`](examples/ch12_functions/ch12_18_array_average_function.asm) | Array integer-average function |
| 19 | [`ch12_19_variance_function.asm`](examples/ch12_functions/ch12_19_variance_function.asm) | Integer variance function (two-pass algorithm) |
| 20 | [`ch12_20_strlen_function.asm`](examples/ch12_functions/ch12_20_strlen_function.asm) | String length function (NUL-terminated string) |
| 21 | [`ch12_21_string_upper_function.asm`](examples/ch12_functions/ch12_21_string_upper_function.asm) | Uppercase conversion in place |
| 22 | [`ch12_22_count_char_function.asm`](examples/ch12_functions/ch12_22_count_char_function.asm) | Count occurrences of a character in a string |
| 23 | [`ch12_23_is_prime_function.asm`](examples/ch12_functions/ch12_23_is_prime_function.asm) | Primality test by trial division |
| 24 | [`ch12_24_power_function.asm`](examples/ch12_functions/ch12_24_power_function.asm) | Integer power function (iterative) |
| 25 | [`ch12_25_gcd_function.asm`](examples/ch12_functions/ch12_25_gcd_function.asm) | Greatest common divisor (Euclidean algorithm) |
| 26 | [`ch12_26_bubble_sort_function.asm`](examples/ch12_functions/ch12_26_bubble_sort_function.asm) | Bubble sort function (ascending, in place) |
| 27 | [`ch12_27_selection_sort_function.asm`](examples/ch12_functions/ch12_27_selection_sort_function.asm) | Selection sort function (ascending, in place) |
| 28 | [`ch12_28_binary_search_function.asm`](examples/ch12_functions/ch12_28_binary_search_function.asm) | Binary search function (sorted array) |
| 29 | [`ch12_29_swap_pointers_function.asm`](examples/ch12_functions/ch12_29_swap_pointers_function.asm) | Swap two memory values through pointers (pass by reference) |
| 30 | [`ch12_30_min_max_function.asm`](examples/ch12_functions/ch12_30_min_max_function.asm) | Minimum and maximum in one pass (two return values) |

## System Services (book ch. 13)

*SYS_write/read, atoi/itoa/printInt, file create/read/append/unlink* — directory `examples/ch13_system_services/` (26 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch13_01_hello_world.asm`](examples/ch13_system_services/ch13_01_hello_world.asm) | Hello World -- the minimal SYS_write program |
| 2 | [`ch13_02_multiline_message.asm`](examples/ch13_system_services/ch13_02_multiline_message.asm) | Multiline output -- three separate write calls |
| 3 | [`ch13_03_string_length_equ.asm`](examples/ch13_system_services/ch13_03_string_length_equ.asm) | String length with equ -- $-label computes it at assembly time |
| 4 | [`ch13_04_syscall_anatomy.asm`](examples/ch13_system_services/ch13_04_syscall_anatomy.asm) | Syscall anatomy -- what every register means |
| 5 | [`ch13_05_exit_code_demo.asm`](examples/ch13_system_services/ch13_05_exit_code_demo.asm) | Output plus a meaningful exit code |
| 6 | [`ch13_06_read_stdin.asm`](examples/ch13_system_services/ch13_06_read_stdin.asm) | Read from standard input and echo it back |
| 7 | [`ch13_07_read_line_length.asm`](examples/ch13_system_services/ch13_07_read_line_length.asm) | How many bytes did read return? |
| 8 | [`ch13_08_atoi_single_digit.asm`](examples/ch13_system_services/ch13_08_atoi_single_digit.asm) | atoi, single digit -- a character becomes a number |
| 9 | [`ch13_09_atoi_multi_digit.asm`](examples/ch13_system_services/ch13_09_atoi_multi_digit.asm) | atoi, multi-digit -- the book's multiply-by-10 loop |
| 10 | [`ch13_10_atoi_signed.asm`](examples/ch13_system_services/ch13_10_atoi_signed.asm) | atoi with sign -- handling a leading minus |
| 11 | [`ch13_11_itoa_positive.asm`](examples/ch13_system_services/ch13_11_itoa_positive.asm) | itoa -- converting 12345 to "12345" |
| 12 | [`ch13_12_itoa_negative.asm`](examples/ch13_system_services/ch13_12_itoa_negative.asm) | itoa with sign -- printing -42 |
| 13 | [`ch13_13_print_int_function.asm`](examples/ch13_system_services/ch13_13_print_int_function.asm) | printInt -- a reusable integer-printing function |
| 14 | [`ch13_14_print_two_ints.asm`](examples/ch13_system_services/ch13_14_print_two_ints.asm) | printInt twice -- two results on two lines |
| 15 | [`ch13_15_read_print_back.asm`](examples/ch13_system_services/ch13_15_read_print_back.asm) | Read a number, print it back -- atoi feeding printInt |
| 16 | [`ch13_16_read_two_sum.asm`](examples/ch13_system_services/ch13_16_read_two_sum.asm) | Read two numbers, print their sum |
| 17 | [`ch13_17_read_square.asm`](examples/ch13_system_services/ch13_17_read_square.asm) | Read n, print n squared |
| 18 | [`ch13_18_squares_table.asm`](examples/ch13_system_services/ch13_18_squares_table.asm) | Squares table -- one input, a loop of outputs |
| 19 | [`ch13_19_file_create_write.asm`](examples/ch13_system_services/ch13_19_file_create_write.asm) | Create a file and write text into it |
| 20 | [`ch13_20_file_roundtrip.asm`](examples/ch13_system_services/ch13_20_file_roundtrip.asm) | File round trip -- write, close, reopen, read, print |
| 21 | [`ch13_21_file_append.asm`](examples/ch13_system_services/ch13_21_file_append.asm) | Appending to a file -- O_APPEND positions every write at the end |
| 22 | [`ch13_22_file_write_numbers.asm`](examples/ch13_system_services/ch13_22_file_write_numbers.asm) | Writing numbers to a file -- itoa feeding SYS_write to a file fd |
| 23 | [`ch13_23_file_unlink.asm`](examples/ch13_system_services/ch13_23_file_unlink.asm) | unlink -- deleting a file, and proving it is gone |
| 24 | [`ch13_24_stderr_write.asm`](examples/ch13_system_services/ch13_24_stderr_write.asm) | Standard error -- fd 2 is a separate output stream |
| 25 | [`ch13_25_getpid.asm`](examples/ch13_system_services/ch13_25_getpid.asm) | getpid -- a syscall that returns information, not I/O |
| 26 | [`ch13_26_simple_calculator.asm`](examples/ch13_system_services/ch13_26_simple_calculator.asm) | Simple calculator -- parse "12+34" from stdin and print the sum |

## Multiple Source Files (book ch. 14)

*extern/global linkage, libraries split across files, C interop* — directory `examples/ch14_multi_source/` (15 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`io.asm`](examples/ch14_multi_source/proj_01_sum_average/io.asm) | io.asm -- shared output routines for project 01 |
| 2 | [`main.asm`](examples/ch14_multi_source/proj_01_sum_average/main.asm) | Project 01 -- sum and average split across three source files |
| 3 | [`sum.asm`](examples/ch14_multi_source/proj_01_sum_average/sum.asm) | sum.asm -- array statistics in a separate object file |
| 4 | [`driver.asm`](examples/ch14_multi_source/proj_02_function_library/driver.asm) | Project 02 -- calling a multi-function library from a driver file |
| 5 | [`io.asm`](examples/ch14_multi_source/proj_02_function_library/io.asm) | io.asm -- shared output routines for project 01 |
| 6 | [`lib_minmax.asm`](examples/ch14_multi_source/proj_02_function_library/lib_minmax.asm) | lib_minmax.asm -- a tiny function library in its own object file |
| 7 | [`helper.asm`](examples/ch14_multi_source/proj_03_extern_global/helper.asm) | helper.asm -- symbol visibility: one global, one file-local label |
| 8 | [`main.asm`](examples/ch14_multi_source/proj_03_extern_global/main.asm) | Project 03 -- extern/global vs file-local (static) symbols |
| 9 | [`count.asm`](examples/ch14_multi_source/proj_04_string_utils/count.asm) | countChar: rdi = string, rsi = length, dl = char -> rax = occurrences |
| 10 | [`io.asm`](examples/ch14_multi_source/proj_04_string_utils/io.asm) | io.asm -- shared output routines for project 01 |
| 11 | [`main.asm`](examples/ch14_multi_source/proj_04_string_utils/main.asm) | Project 04 -- string utilities spread over four object files |
| 12 | [`strlen.asm`](examples/ch14_multi_source/proj_04_string_utils/strlen.asm) | strLen: rdi = NUL-terminated string -> rax = length |
| 13 | [`upper.asm`](examples/ch14_multi_source/proj_04_string_utils/upper.asm) | strUpper: rdi = string (converted in place), rsi = length |
| 14 | [`power.asm`](examples/ch14_multi_source/proj_05_c_calls_asm/power.asm) | power.asm -- long power(long base, long exp) called FROM C |
| 15 | [`main.asm`](examples/ch14_multi_source/proj_06_asm_calls_c/main.asm) | main.asm -- assembly _start calling a C function |

## Command Line Arguments (book ch. 16)

*argc/argv/envp from the _start stack, arg parsing and printing* — directory `examples/ch16_command_line/` (8 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch16_01_argc_exit.asm`](examples/ch16_command_line/ch16_01_argc_exit.asm) | argc -- the argument count from the initial process stack |
| 2 | [`ch16_02_print_argv0.asm`](examples/ch16_command_line/ch16_02_print_argv0.asm) | argv[0] -- printing the program's own name |
| 3 | [`ch16_03_print_all_args.asm`](examples/ch16_command_line/ch16_03_print_all_args.asm) | argv[1..argc-1] -- print every argument on its own line |
| 4 | [`ch16_04_count_arg_chars.asm`](examples/ch16_command_line/ch16_04_count_arg_chars.asm) | Total argument length -- summing strlen over argv |
| 5 | [`ch16_05_sum_args.asm`](examples/ch16_command_line/ch16_05_sum_args.asm) | Summing numeric arguments -- atoi over argv, printInt for the total |
| 6 | [`ch16_06_max_arg.asm`](examples/ch16_command_line/ch16_06_max_arg.asm) | Largest numeric argument |
| 7 | [`ch16_07_find_path_env.asm`](examples/ch16_command_line/ch16_07_find_path_env.asm) | Searching the environment -- finding "PATH=" among envp |
| 8 | [`ch16_08_reverse_args.asm`](examples/ch16_command_line/ch16_08_reverse_args.asm) | Arguments in reverse -- walking argv back to front |

## Buffered I/O (book ch. 17)

*output buffering, line buffering, chunked input (mini cat)* — directory `examples/ch17_buffering/` (4 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch17_01_buffered_write.asm`](examples/ch17_buffering/ch17_01_buffered_write.asm) | Buffered write -- assemble a line in memory, flush once |
| 2 | [`ch17_02_buffer_flush.asm`](examples/ch17_buffering/ch17_02_buffer_flush.asm) | Many appends, one flush -- three lines leave in one syscall |
| 3 | [`ch17_03_line_buffered.asm`](examples/ch17_buffering/ch17_03_line_buffered.asm) | Line buffering -- flush only when a newline lands |
| 4 | [`ch17_04_buffered_read_cat.asm`](examples/ch17_buffering/ch17_04_buffered_read_cat.asm) | Buffered input -- a mini `cat`: read chunks, echo chunks |

## Floating-Point (SSE) (book ch. 18)

*movss/movsd, add..div, sqrt, cvt* conversions, comiss, bitmasks* — directory `examples/ch18_floating_point/` (28 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch18_01_declare_floats.asm`](examples/ch18_floating_point/ch18_01_declare_floats.asm) | Declaring floating-point constants in .data |
| 2 | [`ch18_02_movss_load.asm`](examples/ch18_floating_point/ch18_02_movss_load.asm) | movss -- loading a 32-bit float into an XMM register |
| 3 | [`ch18_03_movsd_load.asm`](examples/ch18_floating_point/ch18_03_movsd_load.asm) | movsd -- loading a 64-bit double into an XMM register |
| 4 | [`ch18_04_movss_store.asm`](examples/ch18_floating_point/ch18_04_movss_store.asm) | movss -- storing an XMM register back to memory |
| 5 | [`ch18_05_addss.asm`](examples/ch18_floating_point/ch18_05_addss.asm) | addss -- single-precision addition |
| 6 | [`ch18_06_subsd.asm`](examples/ch18_floating_point/ch18_06_subsd.asm) | subsd -- double-precision subtraction |
| 7 | [`ch18_07_mulss.asm`](examples/ch18_floating_point/ch18_07_mulss.asm) | mulss -- single-precision multiplication |
| 8 | [`ch18_08_divsd.asm`](examples/ch18_floating_point/ch18_08_divsd.asm) | divsd -- double-precision division |
| 9 | [`ch18_09_sqrtss.asm`](examples/ch18_floating_point/ch18_09_sqrtss.asm) | sqrtss -- square root, single precision |
| 10 | [`ch18_10_sqrtsd.asm`](examples/ch18_floating_point/ch18_10_sqrtsd.asm) | sqrtsd -- square root, double precision |
| 11 | [`ch18_11_addss_array_sum.asm`](examples/ch18_floating_point/ch18_11_addss_array_sum.asm) | Summing a float array with addss |
| 12 | [`ch18_12_addsd_array_sum.asm`](examples/ch18_floating_point/ch18_12_addsd_array_sum.asm) | Summing a double array with addsd |
| 13 | [`ch18_13_float_average.asm`](examples/ch18_floating_point/ch18_13_float_average.asm) | Floating-point average -- divide once at the end |
| 14 | [`ch18_14_array_max_ss.asm`](examples/ch18_floating_point/ch18_14_array_max_ss.asm) | Maximum of a float array -- comiss in a loop |
| 15 | [`ch18_15_array_min_sd.asm`](examples/ch18_floating_point/ch18_15_array_min_sd.asm) | Minimum of a double array -- comisd in a loop |
| 16 | [`ch18_16_cvtss2si.asm`](examples/ch18_floating_point/ch18_16_cvtss2si.asm) | cvtss2si -- round to NEAREST (default rounding mode) |
| 17 | [`ch18_17_cvttss2si.asm`](examples/ch18_floating_point/ch18_17_cvttss2si.asm) | cvttss2si -- TRUNCATE toward zero |
| 18 | [`ch18_18_cvtsi2ss.asm`](examples/ch18_floating_point/ch18_18_cvtsi2ss.asm) | cvtsi2ss -- integer to float |
| 19 | [`ch18_19_cvtsi2sd.asm`](examples/ch18_floating_point/ch18_19_cvtsi2sd.asm) | cvtsi2sd -- integer to double |
| 20 | [`ch18_20_cvtsd2si.asm`](examples/ch18_floating_point/ch18_20_cvtsd2si.asm) | cvtsd2si -- round-to-nearest-EVEN on ties |
| 21 | [`ch18_21_trunc_negative.asm`](examples/ch18_floating_point/ch18_21_trunc_negative.asm) | Truncating a negative float -- toward ZERO, not toward minus infinity |
| 22 | [`ch18_22_comiss_equal.asm`](examples/ch18_floating_point/ch18_22_comiss_equal.asm) | comiss -- equality: (0.5 + 0.5) == 1.0 |
| 23 | [`ch18_23_comiss_less.asm`](examples/ch18_floating_point/ch18_23_comiss_less.asm) | comiss -- ordering: less-than uses jb (below) |
| 24 | [`ch18_24_fabs_bitmask.asm`](examples/ch18_floating_point/ch18_24_fabs_bitmask.asm) | fabs via bitmask -- clearing the sign bit with andps |
| 25 | [`ch18_25_fneg_bitmask.asm`](examples/ch18_floating_point/ch18_25_fneg_bitmask.asm) | fneg via bitmask -- flipping the sign bit with xorps |
| 26 | [`ch18_26_circle_area.asm`](examples/ch18_floating_point/ch18_26_circle_area.asm) | Circle area -- pi * r^2 in double precision |
| 27 | [`ch18_27_celsius_to_f.asm`](examples/ch18_floating_point/ch18_27_celsius_to_f.asm) | Celsius to Fahrenheit -- F = C * 9 / 5 + 32 |
| 28 | [`ch18_28_dot_product.asm`](examples/ch18_floating_point/ch18_28_dot_product.asm) | Dot product -- sum of a[i]*b[i] over two double arrays |

## Parallel Processing (book ch. 19)

*fork/wait4, child exit codes, WEXITSTATUS decoding* — directory `examples/ch19_parallel/` (4 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch19_01_fork_child_exit.asm`](examples/ch19_parallel/ch19_01_fork_child_exit.asm) | fork() -- child exits with its own code, parent collects it via wait4() |
| 2 | [`ch19_02_fork_two_children.asm`](examples/ch19_parallel/ch19_02_fork_two_children.asm) | fork() twice -- two children with different exit codes, parent waits for both |
| 3 | [`ch19_03_fork_print_roles.asm`](examples/ch19_parallel/ch19_03_fork_print_roles.asm) | fork() -- each process announces its role on stdout |
| 4 | [`ch19_04_waitpid_wexitstatus.asm`](examples/ch19_parallel/ch19_04_waitpid_wexitstatus.asm) | wait4() status word -- separating "exited" from "was killed" |

## Interrupts & Signals (book ch. 20)

*SIGFPE from div-by-zero, SIGALRM from alarm(), SIGTRAP from int3* — directory `examples/ch20_interrupts/` (3 programs)

| # | Program | Demonstrates |
|---|---------|-------------|
| 1 | [`ch20_01_sigfpe_child.asm`](ch20_interrupts/ch20_01_sigfpe_child.asm) | Hardware interrupt demo -- integer divide error raises SIGFPE (8) |
| 2 | [`ch20_02_sigalrm_child.asm`](ch20_interrupts/ch20_02_sigalrm_child.asm) | Software interrupt demo -- alarm() timer raises SIGALRM (14) |
| 3 | [`ch20_03_sigtrap_int3.asm`](ch20_interrupts/ch20_03_sigtrap_int3.asm) | Breakpoint interrupt -- int3 raises SIGTRAP (5) |

**Total: 342 assembly source files** (the six `ch14` projects count as
one program each but contain several sources; plus shared `.inc` macro and
`io.asm` files, and two `.gdb` debugger command scripts).

## Layout

```
docs/SPEC.md          style contract every example follows + test manifest format
docs/reference/       three gold-standard reference programs
scripts/build.sh      assemble + link everything into bin/
scripts/test.sh       run every example against its tests.txt manifest
examples/chNN_*/      one directory per book chapter/topic
```

## Source

Ed Jorgensen, *x86-64 Assembly Language Programming with Ubuntu*,
Version 1.1.40, January 2020 (free license: CC BY-NC-SA).
The original PDF is in this repository's root directory.

# AI 
- All three remaining agents hit a hard 5-hour usage limit (resets 23:51 tonight) — no more subagents for a while. I'll write the remaining ~85 files myself in the main thread. Finishing ch20 first, then ch13, ch18, ch16/17, ch14:

- ch20 fully restored (8/14/5). Now writing ch13 system services myself — batch 1, the console-output basics:

- Batch 2 — stdin reading and atoi (ch13_06 through ch13_10):

- Batch 3 — itoa and printInt (ch13_11 through ch13_14):

- Batch 4 — the read+compute programs (ch13_15 through ch13_18):

- Batch 5 — the file-operation examples (ch13_19 through ch13_23):

- All 26 ch13 files written. Fixing the known newline issue in ch13_21 (reads back "ABCD" without newline), then building and testing the chapter:

- The failures expose a manifest-format flaw: `read -r name kind expect ...` splits on any whitespace, so expected values containing spaces get truncated ("Hello World\n" → "Hello"). I'll rewrite test.sh's parser to split the expect field on 2+ spaces (the column alignment) instead of single spaces:

- The parser needs a trim fix (kind captured leading whitespace), and there are real program bugs to chase (ch13_12 emits a garbage byte; ch13_18's output is mangled). Fixing the parser first, then debugging programs directly:

- Found the real bugs, all mine: (1) every printInt computes the write length *before* counting the newline byte; (2) printInt clobbers `rbx` (divisor) which callers still hold — that's why ch13_18 looped to 10; (3) ch13_12's `inc r9` for the '-' sign makes popLoop pop one garbage digit; (4) ch13_16 assumes two reads, but a pipe delivers both lines in one read. Patching all of them:

- Three files (13/14/15) use a slightly different printInt variant — patching them individually:

- Now fixing ch13_16's two-read assumption (pipes deliver both lines at once — parse both numbers from a single read):

- The wrapped output makes failures hard to read — let me debug the parser directly on the manifest:

- The stdin field is dropped: my awk guard is `n > 2` but stdin is f[2] when n == 2. One-character fix:

- Found it — classic: the `syscall` instruction itself clobbers `rcx` (and r11). ch13_14 keeps an operand in rcx across the printInt call. Moving operands to callee-saved registers:

- The build ran from the wrong directory. Rebuilding properly:

- ch13 complete — 28/28 checks pass. Now writing ch18 floating point (28 files), batch 1:

- `dd arrLen` stores the integer bits 8, which as a float is a denormal ~1e-44 — it must be `dd 8.0`:

- ch13 and ch18 both fully pass. Now ch16 command-line arguments — batch 1:

- ch16 passes 8/8. Now ch17 buffering (4 files):

- ch17 passes 4/4. Final batch — the six ch14 multi-source projects. Project 1 (sum/average across files):

- Project 1 verified. Projects 2 and 3:

- Projects 2 and 3 verified. Projects 4 (string utils) and 5 (C calls asm):

- Project 4 works, but I placed `demoStr` inside `.text` — sloppy for a tutorial. Moving it to `.data`, then projects 5 and 6 (C interop):

- `gcc` links crt1.o which defines its own `_start` and wants `main`. Since the C helper is pure arithmetic (no libc calls), the clean fix is compiling it with `gcc -c` and linking with plain `ld`:

- All six projects verified. Now the full global build and test of the entire collection:

- **All 333 programs build and all 335 test checks pass.** Now checking for stray artifacts and writing the README master index:

- Clean. Now generating the README master index directly from each file's header:

- Fixing the README links (they're missing the `examples/` prefix):

- Everything passes. Final spot-checks and project memory update:

- The collection is complete: **333 example programs** covering the entire book, all assembled with YASM, linked, executed, and verified by an automated test suite — **335/335 checks pass**.

## What was built

- I read the PDF (*x86-64 Assembly Language Programming with Ubuntu*, Ed Jorgensen v1.1.40) and generated examples for every instructional chapter, in the book's exact dialect — YASM/NASM Intel syntax, `section .data/.bss/.text`, `_start`, raw Linux syscalls, no libc:

| Directory | Programs | Topic |
|---|---|---|
| `ch02`–`ch04`, `ch06` | 36 | data sizes, two's complement, IEEE-754 bits, program format, debugger scripts |
| `ch07` (4 dirs) | 148 | mov/xchg/movzx/lea, arithmetic (mul/div/128-bit), logical/shift/rotate, jumps/cmov/setcc/loop |
| `ch08`–`ch09` | 32 | addressing modes, arrays, the process stack |
| `ch11`–`ch12` | 38 | macros, the full calling convention, recursion, sorting, searching |
| `ch13`–`ch14`, `ch16`–`ch17` | 44 | syscalls, atoi/itoa, file I/O, multi-file projects, C interop, argv/envp, buffering |
| `ch18`–`ch20` | 35 | SSE floating point, fork/wait4, signals (SIGFPE/SIGALRM/SIGTRAP) |

- Each file is self-contained with a header stating what it demonstrates, the book section, build commands, and expected result. Start with the master index: [README.md](/home/gygy/my_projects/Assembly_Lang/x86_64_Assembly_my_project/05_Intel_asm_tutorials/02_x86_64_assembly_Tutorials/README.md). Build/verify everything with `make test`; a single example with `yasm -f elf64 … && ld …`.

## Notes from the process

- **Toolchain**: yasm wasn't installed and sudo needs a password, so I unpacked the yasm .deb into `~/asm-tools` — `scripts/build.sh` handles this automatically.
- **Verification caught real bugs** (and fixed them): my own flag-clobbering mistakes (`xor` after `cmp` before `setcc`), `syscall` clobbering `rcx`, an itoa newline off-by-one, and a `dd 8` vs `dd 8.0` constant bug — good lessons that are now documented in the affected examples' comments. A few of the book-faithful spec values were also corrected where the hardware disagrees (e.g. `0x7FFFFFFF+1` sets OF, not CF).
- Mid-run, subagent rate limits forced me to write ~120 of the programs (ch13, ch16–ch18, ch14, ch19/20, ch07 control part 2) directly myself — all verified the same way.
- Nothing is committed to git yet; say the word if you'd like a commit.
