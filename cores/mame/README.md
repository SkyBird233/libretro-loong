---
core-name: mame
docs: https://docs.libretro.com/guides/softwarelist-getting-started/
---

# MAME

Note that this core takes more than 6h to compile in GitHub Actions, so tools like sccache are necessary.

Tested games:
- Konami '88
- Donkey Kong.

## JIT support

MAME uses its own UML dynamic-recompiler framework with bundled AsmJit for native code generation. Its native backends support x86, x86-64, and AArch64, but not LoongArch64, which falls back to the portable C backend instead of JIT.
