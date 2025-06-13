# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 2

TARGET_DIR := fdk-aac

all: bench

$(TARGET_DIR):
	git clone https://github.com/mstorsjo/fdk-aac.git

fdk-aac-benchdata:
	wget https://github.com/zyedidia/lfi-bench/releases/download/benchdata/opus-benchdata.tar.gz
	tar -xf opus-benchdata.tar.gz
	mkdir -p fdk-aac-benchdata
	mv opus-benchdata/music_orig.wav fdk-aac-benchdata/music.wav
	rm -rf opus-benchdata opus-benchdata.tar.gz
	ffmpeg -i fdk-aac-benchdata/music.wav -t 30 -c copy fdk-aac-benchdata/music_medium.wav 2>/dev/null

build-lfi: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi -DCMAKE_TOOLCHAIN_FILE=$(LFI_TOOLCHAIN) \
		-DBUILD_PROGRAMS=ON -DBUILD_SHARED_LIBS=OFF
	cmake --build build-lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-lfi-stores -DCMAKE_TOOLCHAIN_FILE=$(STORES_TOOLCHAIN) \
		-DBUILD_PROGRAMS=ON -DBUILD_SHARED_LIBS=OFF
	cmake --build build-lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cmake -S $(TARGET_DIR) -B build-native -DCMAKE_TOOLCHAIN_FILE=$(NATIVE_TOOLCHAIN) \
		-DBUILD_PROGRAMS=ON -DBUILD_SHARED_LIBS=OFF
	cmake --build build-native -j $(JOBS)

bench: fdk-aac-encode.csv

fdk-aac-encode.csv: fdk-aac-benchdata build-native build-lfi build-lfi-stores
	hyperfine --export-csv fdk-aac-encode.csv --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/aac-enc -r 128000 fdk-aac-benchdata/music_medium.wav /dev/null' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/aac-enc -r 128000 fdk-aac-benchdata/music_medium.wav /dev/null' \
		-n 'Native' './build-native/aac-enc -r 128000 fdk-aac-benchdata/music_medium.wav /dev/null'

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) fdk-aac-benchdata
	rm -f *.csv

.PHONY: all bench clean