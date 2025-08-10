# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 1
WARMUP ?= 1

TARGET_DIR := libwebp

all: bench

$(TARGET_DIR):
	git clone https://github.com/webmproject/libwebp.git

# Include common CMake build targets
include ../targets.mk

image.png:
	wget -O image.png https://svs.gsfc.nasa.gov/vis/a010000/a013000/a013043/frames/4096x2048_2x1_30p/Gaia/sub-warped-gaia-000000.png

image.webp: build-native image.png
	build-native/cwebp -q 100 image.png -o image.webp

bench: webp-decode.csv webp-encode.csv

# Decode benchmark
webp-decode.csv: build-native build-lfi build-lfi-stores image.webp
	../hyperfine.py --name webp-decode --cmd "{BUILD_DIR}/dwebp image.webp -o /dev/null" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

# Encode benchmark
webp-encode.csv: build-native build-lfi build-lfi-stores image.png
	../hyperfine.py --name webp-encode --cmd "{BUILD_DIR}/cwebp image.png -o /dev/null" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) image.png image.webp
		rm -f *.csv

.PHONY: all bench clean
