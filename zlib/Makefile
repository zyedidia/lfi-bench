# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 10
WARMUP ?= 1

TARGET_DIR := zlib
CMAKE_FLAGS := -DZLIB_BUILD_TESTING=off

all: bench

$(TARGET_DIR):
	git clone https://github.com/madler/zlib.git

# Include common CMake build targets
include ../targets.mk

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DZLIB_DIR=../build-lfi -DZLIB_INCLUDE=../zlib
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DZLIB_DIR=../build-lfi-stores -DZLIB_INCLUDE=../zlib
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DZLIB_DIR=../build-native -DZLIB_INCLUDE=../zlib
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose
	touch $@

bench: zlib-compress.csv zlib-decompress.csv

zlib-compress.csv: build-benchmarks bigfile.txt
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zlib-compress.csv \
		-n 'LFI' 'lfi-run -- build-lfi-bench/compress_file' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores-bench/compress_file' \
		-n 'Native' 'build-native-bench/compress_file'

zlib-decompress.csv: build-benchmarks bigfile.txt
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zlib-decompress.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi-bench/decompress_file' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores-bench/decompress_file' \
		-n 'Native' 'build-native-bench/decompress_file'

clean:
	rm -f *.csv
	rm -f bigfile.txt.gz bigfile_decompressed.txt build-benchmarks
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench

.PHONY: clean 
