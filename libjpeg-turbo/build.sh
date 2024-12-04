#!/bin/sh

cd libjpeg-turbo-benchmark/benchmark
make test_bytes.h -B
make ../build_release/image_change_quality
cd ../../
mkdir -p build-native
cp libjpeg-turbo-benchmark/build_release/image_change_quality build-native
