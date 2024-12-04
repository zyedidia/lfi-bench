#!/bin/sh

set -e

cp Makefile.in libjpeg-turbo-benchmark/benchmark/Makefile

cd libjpeg-turbo-benchmark/benchmark
CC=/opt/aarch64-native-clang/bin/clang CXX=/opt/aarch64-native-clang/bin/clang++ make test_bytes.h -B
CC=/opt/aarch64-native-clang/bin/clang CXX=/opt/aarch64-native-clang/bin/clang++ make ../build_release/image_change_quality
cd ../../
mkdir -p build-native
cp libjpeg-turbo-benchmark/build_release/image_change_quality build-native

cd libjpeg-turbo-benchmark/benchmark
RUN=lfi-run CC=/opt/aarch64-lfi-clang/bin/clang CXX=/opt/aarch64-lfi-clang/bin/clang++ make test_bytes.h -B
RUN=lfi-run CC=/opt/aarch64-lfi-clang/bin/clang CXX=/opt/aarch64-lfi-clang/bin/clang++ make ../build_release/image_change_quality
cd ../../
mkdir -p build-lfi
cp libjpeg-turbo-benchmark/build_release/image_change_quality build-lfi

cd libjpeg-turbo-benchmark/benchmark
RUN=lfi-run CC=/opt/aarch64-lfi-stores-clang/bin/clang CXX=/opt/aarch64-lfi-stores-clang/bin/clang++ make test_bytes.h -B
RUN=lfi-run CC=/opt/aarch64-lfi-stores-clang/bin/clang CXX=/opt/aarch64-lfi-stores-clang/bin/clang++ make ../build_release/image_change_quality
cd ../../
mkdir -p build-lfi-stores
cp libjpeg-turbo-benchmark/build_release/image_change_quality build-lfi-stores
