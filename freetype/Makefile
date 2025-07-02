# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 2
WARMUP ?= 0

TARGET_DIR := freetype

$(TARGET_DIR):
	git clone git@github.com:freetype/freetype.git

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) --install-prefix $(LFI_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) --install-prefix $(STORES_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) --install-prefix $(NATIVE_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DLIB_DIR=../build-lfi -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL)
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DLIB_DIR=../build-lfi-stores -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL)
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DLIB_DIR=../build-native -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL)
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose

bench: freetype-benchmark.csv

freetype-benchmark.csv: build-benchmarks font.ttf
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv freetype-benchmark.csv \
		-n 'LFI' 'lfi-run -p -- build-lfi-bench/benchmark font.ttf 200' \
		-n 'LFI-stores' 'lfi-run -p -- build-lfi-stores-bench/benchmark font.ttf 200' \
		-n 'Native' 'build-native-bench/benchmark font.ttf 200'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -f *.csv
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench

.PHONY: bench clean
