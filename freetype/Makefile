# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 2
WARMUP ?= 0

TARGET_DIR := freetype

$(TARGET_DIR):
	git clone git@github.com:freetype/freetype.git

# Include common CMake build targets
include ../targets.mk

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DLIB_DIR=../build-lfi -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL)
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DLIB_DIR=../build-lfi-stores -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL)
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DLIB_DIR=../build-native -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL)
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose

bench: freetype-benchmark.csv

freetype-benchmark.csv: build-benchmarks font.ttf
	../hyperfine.py --name freetype-benchmark --cmd "{BUILD_DIR}-bench/benchmark font.ttf 200" --targets "$(HYPERFINE_TARGETS)" --run-command-flags="-p" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -f *.csv
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench

.PHONY: bench clean
