---
core-name: rvvm
docs: https://docs.libretro.com/library/rvvm/
---

# RVVM

Tested with archriscv-2026-01-07-4g.zip

## JIT support

RVVM uses its own RVJIT tracing compiler. RVJIT has x86-64, AArch64, and RISC-V backends, but no LoongArch64 backend, so RVVM silently disables it and uses the interpreter.
