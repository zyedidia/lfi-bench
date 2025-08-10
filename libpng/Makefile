# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 2
WARMUP ?= 1

TARGET_DIR := libpng

all: bench

$(TARGET_DIR):
	git clone https://github.com/pnggroup/libpng.git 

# Include common CMake build targets
include ../targets.mk

image.png:
	wget -O image.png https://svs.gsfc.nasa.gov/vis/a010000/a013000/a013043/frames/4096x2048_2x1_30p/Gaia/sub-warped-gaia-000000.png 

bench: pngtest.csv

pngtest.csv: build-native build-lfi build-lfi-stores image.png
	../hyperfine.py --name pngtest --cmd "{BUILD_DIR}/pngtest image.png" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP) --setup="cat image.png > /dev/null"

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) image.png
	rm -f *.csv

.PHONY: all bench clean
