# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 2
WARMUP ?= 1

TARGET_DIR := libpng

all: bench

$(TARGET_DIR):
	git clone https://github.com/pnggroup/libpng.git 

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

build-benchmarks: build-lfi build-lfi-stores build-native
	cmake -S benchmark -B build-lfi-bench -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) -DLIB_DIR=../build-lfi
	cmake -S benchmark -B build-lfi-stores-bench -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) -DLIB_DIR=../build-lfi-stores
	cmake -S benchmark -B build-native-bench -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) -DLIB_DIR=../build-native
	cmake --build build-lfi-bench --verbose
	cmake --build build-lfi-stores-bench --verbose
	cmake --build build-native-bench --verbose
	touch $@

image.png:
	wget -O image.png https://svs.gsfc.nasa.gov/vis/a010000/a013000/a013043/frames/4096x2048_2x1_30p/Gaia/sub-warped-gaia-000000.png 

bench: pngtest.csv

pngtest.csv: build-native build-lfi build-lfi-stores image.png
	cat image.png > /dev/null #pull it into buffer cache
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv pngtest.csv \
		-n 'LFI' 'lfi-run -- build-lfi/pngtest image.png' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/pngtest image.png' \
		-n 'Native' 'build-native/pngtest image.png'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) image.png
		rm -f *.csv

.PHONY: all bench clean
