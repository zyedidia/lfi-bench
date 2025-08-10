# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 4
WARMUP ?= 1

TARGET_DIR := brotli
CMAKE_FLAGS := -DBROTLI_BUILD_TOOLS=ON -DBUILD_TESTING=OFF

all: bench

$(TARGET_DIR):
	git clone https://github.com/google/brotli.git

# Override install prefix format for brotli
CMAKE_INSTALL_PREFIX_LFI = -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL)
CMAKE_INSTALL_PREFIX_STORES = -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL)
CMAKE_INSTALL_PREFIX_NATIVE = -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL)

# Include common CMake build targets
include ../targets.mk

# Create compressed file for decompression benchmark
bigfile.txt.br: build-native bigfile.txt
	build-native/brotli -o bigfile.txt.br bigfile.txt

bench: brotli-compress.csv brotli-decompress.csv

brotli-compress.csv: build-lfi build-lfi-stores build-native bigfile.txt
	../hyperfine.py --name brotli-compress --cmd "{BUILD_DIR}/brotli -o bigfile.txt.br bigfile.txt" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP) --setup="rm -f bigfile.txt.br"

brotli-decompress.csv: build-lfi build-lfi-stores build-native bigfile.txt.br
	../hyperfine.py --name brotli-decompress --cmd "{BUILD_DIR}/brotli -d -o bigfile_decompressed.txt bigfile.txt.br" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP) --setup="rm -f bigfile_decompressed.txt"

clean:
	rm -f *.csv
	rm -f bigfile.txt bigfile.txt.br bigfile_decompressed.txt
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)

.PHONY: clean all bench install
