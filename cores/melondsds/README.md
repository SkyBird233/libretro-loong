---
core-name: melondsds
docs: https://docs.libretro.com/library/melonds_ds/
---

# melonDS DS

Tested games:
- Legend of Zelda, The - Phantom Hourglass
  - Playable, but freezes on exit (reproduced on x86-64).

## JIT support

melonDS DS uses the JIT from its melonDS dependency: a custom ARM JIT with machine-code emitters borrowed from Dolphin. Those emitters support x86-64 and AArch64, but not LoongArch64, so this core is patched to use the interpreter.
