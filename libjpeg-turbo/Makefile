# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 0

TARGET_DIR := libjpeg-turbo

all: bench

$(TARGET_DIR):
	git clone git@github.com:libjpeg-turbo/libjpeg-turbo.git

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL) -DCMAKE_BUILD_TYPE=Release
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

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

libjpeg-decode.csv: build-benchmarks
	cat image.jpg test.jpeg > /dev/null
	hyperfine --export-csv libjpeg-decode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -p -- ./build-lfi-bench/decode-benchmark 100' \
		-n 'LFI-stores' 'lfi-run -p -- ./build-lfi-stores-bench/decode-benchmark 100' \
		-n 'Native' './build-native-bench/decode-benchmark 100'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)
	rm -rf build-lfi-bench build-lfi-stores-bench build-native-bench
	rm -f *.csv build-benchmarks
