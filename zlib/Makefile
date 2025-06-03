WARMUP ?= 5

JOBS := $(shell nproc)
PARENT_DIR := $(shell dirname $(shell pwd))
LFI_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-clang/usr
STORES_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-stores-clang/usr
NATIVE_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-native-clang/usr

LFI_TOOLCHAIN := ../../toolchains/aarch64-lfi.cmake
STORES_TOOLCHAIN := ../../toolchains/aarch64-lfi-stores.cmake
NATIVE_TOOLCHAIN := ../../toolchains/aarch64-native.cmake

TARGET_DIR := zlib
CMAKE_FLAGS := -DZLIB_BUILD_TESTING=off

all: bench

$(TARGET_DIR):
	git clone https://github.com/madler/zlib.git

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) --install-prefix $(LFI_INSTALL)
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) --install-prefix $(STORES_INSTALL)
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) --install-prefix $(NATIVE_INSTALL)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

bigfile.txt:
	tr -dc "A-Za-z 0-9" < /dev/urandom | fold -w100|head -n 100000 > bigfile.txt

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DZLIB_DIR=../build-lfi -DZLIB_INCLUDE=../zlib
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DZLIB_DIR=../build-lfi-stores -DZLIB_INCLUDE=../zlib
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DZLIB_DIR=../build-native -DZLIB_INCLUDE=../zlib
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose


bench: build-benchmarks bigfile.txt
	hyperfine --warmup $(WARMUP) --export-csv zlib-compress.csv \
		-n 'LFI' 'lfi-run -- build-lfi-bench/compress_file' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores-bench/compress_file' \
		-n 'Native' 'build-native-bench/compress_file'
	hyperfine --warmup $(WARMUP) --export-csv zlib-decompress.csv \
		-n 'LFI' 'lfi-run -- build-lfi-bench/decompress_file' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores-bench/decompress_file' \
		-n 'Native' 'build-native-bench/decompress_file'

clean:
	rm -f *.csv
	rm -f bigfile.txt bigfile.txt.gz bigfile_decompressed.txt
	rm -rf build-lfi build-lfi-stores build-native zlib
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench

.PHONY: bench clean all
