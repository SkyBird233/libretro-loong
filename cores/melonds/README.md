---
core-name: melonds
docs: https://docs.libretro.com/library/melonds/
---

# melonDS

Tested games:
- Legend of Zelda, The - Phantom Hourglass
  - Playable with incorrect touch screen mouse mapping.

## JIT support

melonDS uses its own ARM JIT with machine-code emitters borrowed from Dolphin. Those emitters support x86-64 and AArch64, but not LoongArch64, so melonDS silently uses the interpreter on LoongArch64.
