# GAS 는 GNU공식 assembler이다.

- GAS (GNU Assembler) is primarily chosen because it is the default backend assembler for the GNU Compiler Collection (GCC) and LLVM/Clang, making it the foundational tool for building Unix-like operating systems, including Linux.
  - https://en.wikipedia.org/wiki/GNU_Assembler

# x86 Assembly/Interfacing with Linux

- https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux

# Linux Kernel ABI docs

- https://docs.kernel.org/admin-guide/abi-stable.html

# Rust’s asm! defaults to Intel syntax.

- AT&T syntax & Intel syntax(asm)
  - https://github.com/YoungHaKim7/rust_os_x86_64/commit/b80f5dff395fbad72cc357dbf053199a9bfb9121

<hr />

# GNU Assembler (GAS) Basics

- Default Syntax: Uses AT&T syntax where source precedes destination (e.g., `movl $1, %eax`), though Intel syntax can be enabled.

- Role in Toolchain: Translates human-readable assembly source files (`.s` or `.S`) into machine code object files (`.o`).

- Use Cases: Frequently used in low-level programming, operating systems, and the Linux kernel.


# GNU Assembler (as) 완전 가이드

- GAS 문법을 단순 명령어 목록이 아닌 커널 코드 작성 관점으로 설명합니다. `.section`·`.type`·`.size`·재배치(Relocation) 지시자 의미, 매크로(Macro)/조건 조립으로 반복 코드 관리, CFI 기반 언와인드 정보 생성, x86·AArch64·RISC-V별 calling convention 차이, C 코드 inline asm과의 제약 조건 연결, 부트 코드·트랩 핸들러(Handler)·저수준 컨텍스트 전환 루틴 작성 시 흔한 오류와 점검법까지 상세히 정리합니다.

- https://www.minzkn.com/linuxkernel/pages/gnu-as.html

### GNU Binutils 도구 (Analysis Tools)
- https://www.minzkn.com/linuxkernel/pages/elf.html#elf-tools

### 어셈블리 종합 문서
- https://www.minzkn.com/linuxkernel/pages/assembly.html

## 디버깅 GDB
- https://www.minzkn.com/linuxkernel/pages/gdb.html

# GNU Assembler Examples
- https://cs.lmu.edu/~ray/notes/gasexamples/
