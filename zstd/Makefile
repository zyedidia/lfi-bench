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

bench: build-native build-lfi-stores build-lfi bigfile.txt zstd-decompress.csv

bigfile.txt:
	dd if=/dev/zero of=bigfile.txt bs=1M count=100

# Setup: create compressed file using native build
zstd-decompress.csv: build-native build-lfi-stores build-lfi bigfile.txt
	mkdir -p /tmp/$(USER)
	build-native/programs/zstd -f bigfile.txt -o bigfile.txt.zst
	../hyperfine.py --name zstd-decompress --cmd "{BUILD_DIR}/programs/zstd -df bigfile.txt.zst -o /tmp/$(USER)/test_{BUILD_DIR}_out.txt" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

# Note: Compress benchmark is commented out in original, keeping that way
# zstd-compress.csv: build-native build-lfi-stores build-lfi bigfile.txt  
# 	mkdir -p /tmp/$(USER)
# 	../hyperfine.py --name zstd-compress --cmd "{BUILD_DIR}/programs/zstd -f bigfile.txt -o /tmp/$(USER)/test_{BUILD_DIR}.zst" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -f bigfile.txt.zst *.csv
	rm -f /tmp/$(USER)/test_*.zst /tmp/$(USER)/test_*_out.txt
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)

.PHONY: all bench clean
