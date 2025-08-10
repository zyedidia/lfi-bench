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

# Set CMake flags for static linking like the meson build and enable programs
CMAKE_FLAGS := -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static-pie" -DOPUS_BUILD_PROGRAMS=ON

# Include common CMake build targets
include ../targets.mk

bench: opus-encode.csv opus-decode.csv

opus-encode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv opus-encode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null' \
		-n 'Native' './build-native/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null'

opus-decode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv opus-decode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null' \
		-n 'Native' './build-native/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) opus-benchdata
		rm -f *.csv

.PHONY: all bench clean
