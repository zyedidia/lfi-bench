#!/bin/sh

wget https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-clang.tar.gz
wget https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-lfi-stores-clang.tar.gz
wget https://github.com/lfi-project/lfi-llvm-toolchain/releases/download/v0.9/aarch64-native-clang.tar.gz

tar -xf aarch64-lfi-clang.tar.gz
tar -xf aarch64-lfi-stores-clang.tar.gz
tar -xf aarch64-native-clang.tar.gz

sudo mv aarch64-lfi-clang /opt
sudo mv aarch64-lfi-stores-clang /opt
sudo mv aarch64-native-clang /opt
