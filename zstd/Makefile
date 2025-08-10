# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS ?= 5
WARMUP ?= 0

TARGET_DIR := zstd

all: bench

$(TARGET_DIR):
	git clone https://github.com/facebook/zstd.git

# Set CMake source directory to the cmake subdirectory
CMAKE_SOURCE_DIR := $(TARGET_DIR)/build/cmake
CMAKE_FLAGS := -DZSTD_BUILD_PROGRAMS=ON -DZSTD_BUILD_SHARED=OFF -DCMAKE_EXE_LINKER_FLAGS="-static-pie"

# Include common CMake build targets
include ../targets.mk

bench: build-native build-lfi-stores build-lfi bigfile.txt
	mkdir -p /tmp/$(USER)
	build-native/programs/zstd -f bigfile.txt -o bigfile.txt.zst
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zstd-decompress.csv \
		-n 'LFI' 'lfi-run -- build-lfi/programs/zstd -df bigfile.txt.zst -o /tmp/$(USER)/test_lfi_out.txt' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/programs/zstd -df bigfile.txt.zst -o /tmp/$(USER)/test_lfi_stores_out.txt' \
		-n 'Native' 'lfi-run -- build-native/programs/zstd -df bigfile.txt.zst -o /tmp/$(USER)/test_native_out.txt'
	# mkdir -p /tmp/$(USER)
	# # hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv zstd-compress.csv \
	# # 	-n 'LFI' 'lfi-run -- build-lfi/programs/zstd -f bigfile.txt -o /tmp/$(USER)/test_lfi.zst' \
	# # 	-n 'LFI-stores' 'lfi-run -- build-lfi-stores/programs/zstd -f bigfile.txt -o /tmp/$(USER)/test_lfi_stores.zst' \
	# # 	-n 'Native' 'lfi-run -- build-native/programs/zstd -f bigfile.txt -o /tmp/$(USER)/test_native.zst'

clean:
	rm -f bigfile.txt.zst *.csv
	rm -f /tmp/$(USER)/test_*.zst /tmp/$(USER)/test_*_out.txt
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)

.PHONY: all bench clean
