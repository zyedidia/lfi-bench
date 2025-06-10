# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS ?= 10
WARMUP ?= 5

TARGET_DIR := zstd

all: bench

$(TARGET_DIR):
	git clone https://github.com/facebook/zstd.git

build-lfi: $(TARGET_DIR)
	meson setup build-lfi $(TARGET_DIR)/build/meson --cross-file $(LFI_MESON) -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: $(TARGET_DIR)
	meson setup build-lfi-stores $(TARGET_DIR)/build/meson --cross-file $(STORES_MESON) -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: $(TARGET_DIR)
	meson setup build-native $(TARGET_DIR)/build/meson --cross-file $(NATIVE_MESON) -Ddefault_library=static
	ninja -C build-native

bigfile.txt:
	tr -dc "A-Za-z 0-9" < /dev/urandom | fold -w100|head -n 100000 > bigfile.txt

bench: zstd-compress.csv zstd-decompress.csv

zstd-compress.csv: build-native build-lfi build-lfi-stores bigfile.txt
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zstd-compress.csv \
		-n 'LFI' 'lfi-run -- build-lfi/programs/zstd -f bigfile.txt -o /tmp/test_lfi.zst' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/programs/zstd -f bigfile.txt -o /tmp/test_lfi_stores.zst' \
		-n 'Native' 'build-native/programs/zstd -f bigfile.txt -o /tmp/test_native.zst'

zstd-decompress.csv: build-native build-lfi build-lfi-stores bigfile.txt
	# Create compressed file for decompression benchmark
	build-native/programs/zstd -f bigfile.txt -o bigfile.txt.zst
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zstd-decompress.csv \
		-n 'LFI' 'lfi-run -- build-lfi/programs/zstd -df bigfile.txt.zst -o /tmp/test_lfi_out.txt' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/programs/zstd -df bigfile.txt.zst -o /tmp/test_lfi_stores_out.txt' \
		-n 'Native' 'build-native/programs/zstd -df bigfile.txt.zst -o /tmp/test_native_out.txt'

clean:
	rm -f bigfile.txt bigfile.txt.zst *.csv
	rm -f /tmp/test_*.zst /tmp/test_*_out.txt
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)

.PHONY: all bench clean
