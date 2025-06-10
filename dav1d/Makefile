# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 0

TARGET_DIR := dav1d

all: bench

$(TARGET_DIR):
	git clone https://github.com/zyedidia/dav1d -b lfi

dav1d-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/dav1d-benchdata.tar.gz
	tar -xf dav1d-benchdata.tar.gz
	rm -f dav1d-benchdata.tar.gz

build-lfi: $(TARGET_DIR)
	meson setup build-lfi $(TARGET_DIR) --cross-file $(LFI_MESON) -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: $(TARGET_DIR)
	meson setup build-lfi-stores $(TARGET_DIR) --cross-file $(STORES_MESON) -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: $(TARGET_DIR)
	meson setup build-native $(TARGET_DIR) --cross-file $(NATIVE_MESON) -Ddefault_library=static
	ninja -C build-native

bench: dav1d.csv

dav1d.csv: build-native build-lfi build-lfi-stores dav1d-benchdata
	hyperfine --export-csv dav1d.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- build-lfi/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1' \
		-n 'Native' 'build-native/tools/dav1d -i dav1d-benchdata/Bosphorus_3840x2160_120fps_420_8bit.ivf -o /dev/null --threads 1'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) dav1d-benchdata
		rm -f *.csv

.PHONY: all bench clean
