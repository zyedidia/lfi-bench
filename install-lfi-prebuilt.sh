#!/bin/sh

export LFI_ROOT=~/.lfi

wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-clang.tar.gz
wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-stores-clang.tar.gz
wget -c https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-native-clang.tar.gz

tar -xf aarch64-lfi-clang.tar.gz
tar -xf aarch64-lfi-stores-clang.tar.gz
tar -xf aarch64-native-clang.tar.gz

rm -rf $LFI_ROOT
mkdir -p $LFI_ROOT
mv aarch64-lfi-clang $LFI_ROOT
mv aarch64-lfi-stores-clang $LFI_ROOT
mv aarch64-native-clang $LFI_ROOT
