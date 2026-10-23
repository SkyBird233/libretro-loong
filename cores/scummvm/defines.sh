# The generic Unix platform does not infer the target's pointer size.
export BUILD_64BIT=1

# ScummVM otherwise uses host ar/ranlib when creating its dependency archives.
export TOOLSET=loongarch64-linux-gnu-
