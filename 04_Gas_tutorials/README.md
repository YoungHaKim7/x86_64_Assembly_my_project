# GNU Assembler (GAS) Basics

- Default Syntax: Uses AT&T syntax where source precedes destination (e.g., `movl $1, %eax`), though Intel syntax can be enabled.

- Role in Toolchain: Translates human-readable assembly source files (`.s` or `.S`) into machine code object files (`.o`).

- Use Cases: Frequently used in low-level programming, operating systems, and the Linux kernel.


# GNU Assembler (as) 완전 가이드

- GAS 문법을 단순 명령어 목록이 아닌 커널 코드 작성 관점으로 설명합니다. `.section`·`.type`·`.size`·재배치(Relocation) 지시자 의미, 매크로(Macro)/조건 조립으로 반복 코드 관리, CFI 기반 언와인드 정보 생성, x86·AArch64·RISC-V별 calling convention 차이, C 코드 inline asm과의 제약 조건 연결, 부트 코드·트랩 핸들러(Handler)·저수준 컨텍스트 전환 루틴 작성 시 흔한 오류와 점검법까지 상세히 정리합니다.

- https://www.minzkn.com/linuxkernel/pages/gnu-as.html