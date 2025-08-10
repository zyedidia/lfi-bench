# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := libhevc

all: bench

$(TARGET_DIR):
	git clone https://github.com/ittiam-systems/libhevc.git

# Add libhevc-specific flags
CMAKE_FLAGS := -DSYSTEM_PROCESSOR="aarch64" -DSYSTEM_NAME="Linux"

# Include common CMake build targets
include ../targets.mk

example.yuv:
	ffmpeg -f lavfi -i testsrc2=duration=5:size=3840x2160:rate=30 -pix_fmt yuv420p example.yuv

example.hevc:
	ffmpeg -f rawvideo -pix_fmt yuv420p -s:v 3840x2160 -r 30 -i example.yuv -c:v libx265 -preset medium -crf 23 example.hevc

bench-encode: build-lfi build-lfi-stores build-native example.yuv
	cat example.* > /dev/null #warmup cache
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv hevcenc.csv \
		-n 'LFI' 'lfi-run -- build-lfi/hevcenc --input example.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/hevcenc --input example.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30' \
		-n 'Native' 'build-native/hevcenc --input example.yuv --output /dev/null --src_width 352 --src_height 288 --num_frames_to_encode 30'
bench: bench-encode example.hevc
	hyperfine --runs $(RUNS) --warmup $(WARMUP) --export-csv hevcdec.csv \
		-n 'LFI' 'lfi-run -- build-lfi/hevcdec --input example.hevc --output /dev/null' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/hevcdec --input example.hevc --output /dev/null' \
		-n 'Native' 'build-native/hevcdec --input example.hevc --output /dev/null'

clean:
	rm -f *.csv
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) example.yuv example.hevc

.PHONY: all bench clean install example-data
