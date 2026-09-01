---
core-name: dolphin
docs: https://docs.libretro.com/library/dolphin/
---

# Dolphin

Tested games:
- DeSmuME Wii

## JIT support

Dolphin uses its own PowerPC JIT and machine-code emitters. It has x86-64 and AArch64 CPU backends, but no LoongArch64 backend, so this core is patched to use the generic interpreter build.
