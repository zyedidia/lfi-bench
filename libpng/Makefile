RUNS   ?= 1
WARMUP ?= 1

JOBS := $(shell nproc)
PARENT_DIR := $(shell dirname $(shell pwd))
LFI_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-clang/usr
STORES_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-lfi-stores-clang/usr
NATIVE_INSTALL := $(PARENT_DIR)/benchmark-lib/aarch64-native-clang/usr

TARGET_DIR:= libpng

all: bench

$(TARGET_DIR):
	git clone https://github.com/pnggroup/libpng.git 

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi.cmake --install-prefix $(LFI_INSTALL)
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-lfi-stores.cmake --install-prefix $(STORES_INSTALL)
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=../../toolchains/aarch64-native.cmake --install-prefix $(NATIVE_INSTALL)
	cmake --build build-native -j $(JOBS)

install: build-lfi build-lfi-stores build-lfi-native
	cmake --install build-lfi
	cmake --install build-lfi-stores
	cmake --install build-native

image.png:
	wget -O image.png https://svs.gsfc.nasa.gov/vis/a010000/a013000/a013043/frames/4096x2048_2x1_30p/Gaia/sub-warped-gaia-000000.png 

bench: build-native build-lfi build-lfi-stores image.png
	cat image.png > /dev/null #pull it into buffer cache
	hyperfine --runs $(RUNS) --export-csv pngtest.csv \
		-n 'LFI' 'lfi-run -- build-lfi/pngtest image.png' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/pngtest image.png' \
		-n 'Native' 'build-native/pngtest image.png'

clean:
	rm -rf $(TARGET_DIR) build-native build-lfi build-lfi-stores

.PHONY: all bench clean
