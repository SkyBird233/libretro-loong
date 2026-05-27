#!/bin/bash

set -e

echo "===== $1"

BASE_DIR="$(pwd)"/libretro-super
CORE_DIR="$(pwd)"/cores/"$1"

TARGET='loongarch64-linux-gnu'
export ARCH=loongarch64

if [[ -f "$CORE_DIR"/defines.sh ]]; then
  echo "=== Reading defines ..."
  source "$CORE_DIR"/defines.sh
fi

if [[ "$USECLANG" = true ]]; then
  echo "Using Clang for $TARGET ..."
  export CC="clang"
  export CXX="clang++"
  export CXX11="clang++"
  export CXX17="clang++"
  export CFLAGS="$CFLAGS --target=$TARGET"
  export CXXFLAGS="$CXXFLAGS --target=$TARGET"
  export LDFLAGS="$LDFALGS --target=$TARGET -fuse-ld=lld"
  export AR="llvm-ar"
  export RANLIB="llvm-ranlib"
  export NM="llvm-nm"
else
  echo "Using GCC for $TARGET ..."
  export CC="$TARGET-gcc"
  export CXX="$TARGET-g++"
  export CXX11="$CXX"
  export CXX17="$CXX"
fi

if [[ "$SCCACHE_GHA_ENABLED" = true ]]; then
  echo "Enabling sccache ..."
  export CC="sccache $CC"
  export CXX="sccache $CXX"
  export CXX11="sccache $CXX11"
  export CXX17="sccache $CXX17"
fi

if [[ -f "$CORE_DIR"/prepare.sh ]]; then
  echo "=== Preparing $1 ..."
  set -x
  source "$CORE_DIR"/prepare.sh
  set +x
fi

if [[ -d "$CORE_DIR"/patches ]]; then
  echo "=== Patching $1 ..."
  cd $BASE_DIR/libretro-"$1"
  git apply -v "$CORE_DIR"/patches/*
fi

echo "=== Building $1 ..."
cd $BASE_DIR 
./libretro-build.sh "$1"

if [[ "$SCCACHE_GHA_ENABLED" = true ]]; then
  echo "=== sccache stats"
  sccache --show-stats
fi

OUTPUT="$BASE_DIR"/dist/unix/"$1"_libretro.so
if [[ ! -f "$OUTPUT" ]]; then
  "Missing output: $OUTPUT"
  exit 1
fi
