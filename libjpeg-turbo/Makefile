# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 0

TARGET_DIR := libjpeg-turbo

all: bench

$(TARGET_DIR):
	git clone git@github.com:libjpeg-turbo/libjpeg-turbo.git

# Override install prefix format for libjpeg-turbo
CMAKE_INSTALL_PREFIX_LFI = -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL)
CMAKE_INSTALL_PREFIX_STORES = -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL)
CMAKE_INSTALL_PREFIX_NATIVE = -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL)

# Include common CMake build targets
include ../targets.mk

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DLIBJPEG_DIR=../build-lfi
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DLIBJPEG_DIR=../build-lfi-stores
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DLIBJPEG_DIR=../build-native
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose
	touch $@

build-integrate: build-lfi
	$(MAKE) -C integrate all

bench: libjpeg-decode.csv

decode-bench: libjpeg-decode.csv

# JPEG decode benchmark
libjpeg-decode.csv: build-benchmarks
	../hyperfine.py --name libjpeg-decode --cmd "./{BUILD_DIR}-bench/decode-benchmark 100" --targets "$(HYPERFINE_TARGETS)" --run-command-flags="-p" --runs $(RUNS) --warmup $(WARMUP) --setup="cat image.jpg test.jpeg > /dev/null"

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench
	rm -f *.csv build-benchmarks
