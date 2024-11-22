#!/bin/sh

set -ex

rm -rf build-lfi
mkdir -p build-lfi
cd build-lfi
LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=/opt/aarch64-lfi-clang/bin/llvm-ar CC=/opt/aarch64-lfi-clang/bin/clang CXX=/opt/aarch64-lfi-clang/bin/clang++ ../libvpx/configure
make
cd ..

rm -rf build-lfi-stores
mkdir -p build-lfi-stores
cd build-lfi-stores
LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=/opt/aarch64-lfi-stores-clang/bin/llvm-ar CC=/opt/aarch64-lfi-stores-clang/bin/clang CXX=/opt/aarch64-lfi-stores-clang/bin/clang++ ../libvpx/configure
make
cd ..

rm -rf build-native
mkdir -p build-native
cd build-native
LDFLAGS="-static-pie" CROSS=aarch64-unknown-linux-musl- AR=/opt/aarch64-native-clang/bin/llvm-ar CC=/opt/aarch64-native-clang/bin/clang CXX=/opt/aarch64-native-clang/bin/clang++ ../libvpx/configure
make
cd ..
