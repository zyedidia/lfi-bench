# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 1

TARGET_DIR := libwebp

all: bench

$(TARGET_DIR):
	git clone https://github.com/webmproject/libwebp.git

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

image.png:
	wget -O image.png https://svs.gsfc.nasa.gov/vis/a010000/a013000/a013043/frames/4096x2048_2x1_30p/Gaia/sub-warped-gaia-000000.png

image.webp: build-native image.png
	build-native/cwebp -q 100 image.png -o image.webp

bench: webp-decode.csv webp-encode.csv

webp-decode.csv: build-native build-lfi build-lfi-stores image.webp
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv webp-decode.csv \
		-n 'LFI' 'lfi-run -- build-lfi/dwebp image.webp -o /dev/null' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/dwebp image.webp -o /dev/null' \
		-n 'Native' 'build-native/dwebp image.webp -o /dev/null'

webp-encode.csv: build-native build-lfi build-lfi-stores image.png
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv webp-encode.csv \
		-n 'LFI' 'lfi-run -- build-lfi/cwebp image.png -o /dev/null' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/cwebp image.png -o /dev/null' \
		-n 'Native' 'build-native/cwebp image.png -o /dev/null'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) image.png image.webp
		rm -f *.csv

.PHONY: all bench clean
