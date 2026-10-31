# 문제 풀면서 지식을 익히자
- https://www.wasilzafar.com/pages/series/assembly-mastery/asm-part06-masm.html

# 기본적인 상식
- In x86-64 assembly, which register traditionally holds the return value of a function
  - `RAX`
 
- Match each x86-64 instruction to its purpose:
  - Tap left → tap matching right
    - SYSCALL - Transition to kernel mode for OS service
    - CPUID - Query processor features and identity
    - RDTSC - Read high-resolution timestamp counter
    - MFENCE - Memory fence — serialize all memory operations


## q) Should security researchers publish working exploits that use assembly-level techniques (ROP chains, shellcode)?

- A researcher discovers a kernel vulnerability and writes a proof-of-concept exploit with ROP chain. Publishing it: educates defenders, proves severity to vendors, but also gives attackers a ready-made weapon.

- Publish immediately — full disclosure forces vendors to patch quickly
Full disclosure — pressure creates action

- Never publish exploit code — only describe the vulnerability class
Minimum disclosure — reduce weaponization risk

- Coordinate with vendor (90 days), then publish — with working PoC
Responsible disclosure — balance pressure and safety

- Publish after patch is widely deployed (6+ months)
Conservative — ensure most users are safe first

### My position: Coordinate with the vendor (90 days), then publish with a carefully designed working PoC.

Recommended: Responsible disclosure

### Why?

Kernel vulnerabilities are particularly dangerous because they can potentially provide attackers with elevated privileges.

A working ROP-chain or shellcode PoC has two sides:

Benefits of publication

- Demonstrates the actual severity of the vulnerability.
- Helps security researchers reproduce and understand the issue.
- Enables defenders to develop detection mechanisms.
- Provides evidence that a vulnerability is exploitable, not merely theoretical.

Risks of publication

- Attackers can adapt the PoC into real-world exploits.
- Unpatched systems become immediate targets.
- Kernel exploitation can lead to privilege escalation and system compromise.
- ROP chains and shellcode can significantly reduce the effort required to weaponize a vulnerability.

### My preferred disclosure process

| Stage             | Action                                                    |
| ----------------- | --------------------------------------------------------- |
| Day 0             | Report vulnerability privately to the vendor.             |
| Day 1–30          | Share technical details and a controlled PoC.             |
| Day 30–90         | Help validate the patch and test mitigations.             |
| Day 90            | Publish technical research and PoC if appropriate.        |
| After publication | Monitor exploitation and communicate mitigation guidance. |

### Should working exploit code be published?

I would distinguish between three levels:

1. Technical explanation: Publish the vulnerability mechanics, affected components, and root cause.
2. Controlled PoC: Publish reproducible evidence demonstrating the vulnerability without unnecessarily enabling widespread exploitation.
3. Weaponized exploit: Avoid publishing a turnkey exploit that makes compromising unpatched systems straightforward.

A 90-day deadline should not be absolute. If exploitation is already occurring in the wild, or the vendor cannot provide a meaningful mitigation, disclosure needs a case-by-case risk assessment.

### Final position

I would choose:

Coordinate with vendor (90 days), then publish — with working PoC.

The objective of security research should be to improve security, not simply to demonstrate technical capability.

The key principle: Transparency should empower defenders without unnecessarily equipping attackers.
