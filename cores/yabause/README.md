---
core-name: yabause
docs: https://docs.libretro.com/library/yabause/
---

# Yabause

Tested games:
- Panzer Dragon Saga

## JIT support

Yabause contains an Ari64-derived SH-2 dynamic recompiler and a second JIT borrowed from Play! CodeGen. Their available backends cover x86, x86-64, ARM, and AArch64, but not LoongArch64; the libretro build disables both and uses the interpreter.
