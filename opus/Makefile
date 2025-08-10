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

# Set CMake flags for static linking and enable programs
CMAKE_FLAGS := -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static-pie" -DOPUS_BUILD_PROGRAMS=ON

# Include common CMake build targets
include ../targets.mk

bench: opus-encode.csv opus-decode.csv

# Encode benchmark
opus-encode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	../hyperfine.py --name opus-encode --cmd "./{BUILD_DIR}/opus_demo -e voip 48000 2 96000 opus-benchdata/music_orig.wav /dev/null" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

# Decode benchmark
opus-decode.csv: opus-benchdata build-native build-lfi build-lfi-stores
	../hyperfine.py --name opus-decode --cmd "./{BUILD_DIR}/opus_demo -d 48000 2 opus-benchdata/music_orig.opus /dev/null" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) opus-benchdata
		rm -f *.csv

.PHONY: all bench clean
