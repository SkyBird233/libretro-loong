unset HOST_CC

export CC="clang"
export CXX="clang++"
export CXX11="clang++"
export CXX17="clang++"
export CFLAGS="--target=loongarch64-linux-gnu"
export CXXFLAGS="--target=loongarch64-linux-gnu"
export LDFLAGS="--target=loongarch64-linux-gnu -fuse-ld=lld"
export AR="llvm-ar"
export RANLIB="llvm-ranlib"
export NM="llvm-nm"

export CFLAGS="$CFLAGS -mcmodel=medium"
