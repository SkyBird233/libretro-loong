# MAME compiled with GCC will crash on loading games.
USECLANG=true

# Deepin beige v1.2.0 ships an old GCC whose LoongArch crtbeginS.o uses the
# range-limited R_LARCH_B26 relocation. LLD places MAME's large .text section
# between crtbeginS.o and the PLT, putting the target out of range. Use BFD as
# a workaround:
# https://github.com/gcc-mirror/gcc/commit/ae14d7d04da8c6cb542269722638071f999f94d8
LINKER=bfd
