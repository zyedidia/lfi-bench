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

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(LFI_INSTALL)
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(STORES_INSTALL)
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) $(CMAKE_FLAGS) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DCMAKE_INSTALL_PREFIX=$(NATIVE_INSTALL)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

# Create compressed file for decompression benchmark
bigfile.txt.br: build-native bigfile.txt
	build-native/brotli -o bigfile.txt.br bigfile.txt

bench: brotli-compress.csv brotli-decompress.csv

brotli-compress.csv: build-lfi build-lfi-stores build-native bigfile.txt
	rm -f bigfile.txt.br  # Clean previous compressed file
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv brotli-compress.csv \
		--prepare 'rm -f bigfile.txt.br' \
		-n 'LFI' 'lfi-run -- build-lfi/brotli -o bigfile.txt.br bigfile.txt' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/brotli -o bigfile.txt.br bigfile.txt' \
		-n 'Native' 'build-native/brotli -o bigfile.txt.br bigfile.txt'

brotli-decompress.csv: build-lfi build-lfi-stores build-native bigfile.txt.br
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv brotli-decompress.csv \
		--prepare 'rm -f bigfile_decompressed.txt' \
		-n 'LFI' 'lfi-run -- build-lfi/brotli -d -o bigfile_decompressed.txt bigfile.txt.br' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/brotli -d -o bigfile_decompressed.txt bigfile.txt.br' \
		-n 'Native' 'build-native/brotli -d -o bigfile_decompressed.txt bigfile.txt.br'

clean:
	rm -f *.csv
	rm -f bigfile.txt bigfile.txt.br bigfile_decompressed.txt
	rm -rf $(BUILD_DIRS) $(TARGET_DIR)

.PHONY: clean all bench install
