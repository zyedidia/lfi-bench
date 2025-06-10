RUNS   ?= 3
WARMUP ?= 1

JOBS := $(shell nproc)
PARENT_DIR := $(shell dirname $(shell pwd))
LFI_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-clang/usr
STORES_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-stores-clang/usr
NATIVE_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-native-clang/usr

TARGET_DIR:= expat

all: bench

$(TARGET_DIR):
	git clone https://github.com/libexpat/libexpat
	ln -s libexpat/expat expat

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi.cmake --install-prefix $(LFI_INSTALL)
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi-stores.cmake --install-prefix $(STORES_INSTALL)
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-native.cmake --install-prefix $(NATIVE_INSTALL)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

bench: expat.csv

expat.csv: build-native build-lfi build-lfi-stores
	hyperfine --runs $(RUNS) --export-csv expat.csv \
		-n 'LFI' 'lfi-run -- build-lfi/tests/runtests' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/tests/runtests' \
		-n 'Native' 'build-native/tests/runtests'

clean:
	rm -rf $(TARGET_DIR) build-native build-lfi build-lfi-stores libexpat

.PHONY: all bench clean
