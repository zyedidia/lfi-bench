# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 5
WARMUP ?= 2

TARGET_DIR := opus

all: bench

$(TARGET_DIR):
	wget https://github.com/xiph/opus/releases/download/v1.5.2/opus-1.5.2.tar.gz
	tar -xf opus-1.5.2.tar.gz
	rm -f opus-1.5.2.tar.gz
	mv opus-1.5.2 opus

opus-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/opus-benchdata.tar.gz
	tar -xf opus-benchdata.tar.gz
	rm -f opus-benchdata.tar.gz

build-lfi: $(TARGET_DIR)
	LDFLAGS="-static-pie" meson setup build-lfi $(TARGET_DIR) --cross-file $(LFI_MESON) -Ddefault_library=static
	ninja -C build-lfi

build-lfi-stores: $(TARGET_DIR)
	LDFLAGS="-static-pie" meson setup build-lfi-stores $(TARGET_DIR) --cross-file $(STORES_MESON) -Ddefault_library=static
	ninja -C build-lfi-stores

build-native: $(TARGET_DIR)
	LDFLAGS="-static-pie" meson setup build-native $(TARGET_DIR) --cross-file $(NATIVE_MESON) -Ddefault_library=static
	ninja -C build-native

build-ubsan: $(TARGET_DIR)
	LDFLAGS="-static-pie" meson setup build-ubsan $(TARGET_DIR) --cross-file $(UBSAN_MESON) -Ddefault_library=static
	ninja -C build-ubsan

bench: opus-encode.csv opus-decode.csv

opus-encode.csv: opus-benchdata build-native build-lfi build-lfi-stores build-ubsan
	hyperfine --export-csv opus-encode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'Native' './build-native/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'UBSan' './build-ubsan/src/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null'

opus-decode.csv: opus-benchdata build-native build-lfi build-lfi-stores build-ubsan
	hyperfine --export-csv opus-decode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'Native' './build-native/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'UBSan' './build-ubsan/src/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) opus-benchdata
		rm -f *.csv

.PHONY: all bench clean
