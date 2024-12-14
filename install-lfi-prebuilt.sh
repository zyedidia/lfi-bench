#!/bin/sh

wget https://github.com/zyedidia/lfi-llvm-toolchain/releases/download/prebuilt-toolchains/aarch64-lfi-clang.tar.gz
wget https://github.com/zyedidia/lfi-llvm-toolchain/releases/download/prebuilt-toolchains/aarch64-lfi-stores-clang.tar.gz
wget https://github.com/zyedidia/lfi-llvm-toolchain/releases/download/prebuilt-toolchains/aarch64-native-clang.tar.gz

tar -xf aarch64-lfi-clang.tar.gz
tar -xf aarch64-lfi-stores-clang.tar.gz
tar -xf aarch64-native-clang.tar.gz

sudo mv aarch64-lfi-clang /opt
sudo mv aarch64-lfi-stores-clang /opt
sudo mv aarch64-native-clang /opt
