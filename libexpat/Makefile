# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := expat

all: bench

$(TARGET_DIR):
	git clone https://github.com/libexpat/libexpat
	ln -s libexpat/expat expat

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

bench: expat.csv

expat.csv: build-native build-lfi build-lfi-stores
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv expat.csv \
		-n 'LFI' 'lfi-run -- build-lfi/tests/runtests' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/tests/runtests' \
		-n 'Native' 'build-native/tests/runtests'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) libexpat
		rm -f *.csv

.PHONY: all bench clean
