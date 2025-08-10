# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := libvpx

all: bench

$(TARGET_DIR):
	git clone https://github.com/webmproject/libvpx

build-lfi: $(TARGET_DIR)
	mkdir -p build-lfi
	cd build-lfi && LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=$(LFI_TOOLCHAIN_PATH)/bin/llvm-ar CC=$(LFI_TOOLCHAIN_PATH)/bin/clang CXX=$(LFI_TOOLCHAIN_PATH)/bin/clang++ ../$(TARGET_DIR)/configure
	make -C build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	mkdir -p build-lfi-stores
	cd build-lfi-stores && LDFLAGS="-static-pie" CROSS=aarch64-lfi-linux-musl- AR=$(STORES_TOOLCHAIN_PATH)/bin/llvm-ar CC=$(STORES_TOOLCHAIN_PATH)/bin/clang CXX=$(STORES_TOOLCHAIN_PATH)/bin/clang++ ../$(TARGET_DIR)/configure
	make -C build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	mkdir -p build-native
	cd build-native && LDFLAGS="-static-pie" CROSS=aarch64-unknown-linux-musl- AR=$(NATIVE_TOOLCHAIN_PATH)/bin/llvm-ar CC=$(NATIVE_TOOLCHAIN_PATH)/bin/clang CXX=$(NATIVE_TOOLCHAIN_PATH)/bin/clang++ ../$(TARGET_DIR)/configure
	make -C build-native -j $(JOBS)

vpx-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/vpx-benchdata.tar.gz
	tar -xf vpx-benchdata.tar.gz
	rm -f vpx-benchdata.tar.gz

bench: libvpx.csv

libvpx.csv: vpx-benchdata build-native build-lfi build-lfi-stores
	../hyperfine.py --name libvpx --cmd "./{BUILD_DIR}/vpxdec --threads=$(THREADS) -o /dev/null vpx-benchdata/sample-30s.webm" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) vpx-benchdata
	rm -f *.csv

.PHONY: all bench clean
