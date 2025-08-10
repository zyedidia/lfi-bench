# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 3
WARMUP ?= 1

TARGET_DIR := expat

all: bench

$(TARGET_DIR):
	git clone https://github.com/libexpat/libexpat
	ln -s libexpat/expat expat

# Include common CMake build targets
include ../targets.mk

bench: expat.csv

expat.csv: build-native build-lfi build-lfi-stores
	../hyperfine.py --name expat --cmd "{BUILD_DIR}/tests/runtests" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) libexpat
	rm -f *.csv

.PHONY: all bench clean
