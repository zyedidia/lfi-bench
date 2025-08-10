# Include shared configuration
include ../common.mk

# Benchmark-specific configuration
RUNS   ?= 5
WARMUP ?= 1

TARGET_DIR := giflib

$(TARGET_DIR):
	wget -O giflib.tar.gz https://sourceforge.net/projects/giflib/files/giflib-5.2.2.tar.gz
	tar xzvf giflib.tar.gz
	mv -f giflib-5.2.2 giflib

build-lfi: $(TARGET_DIR)
	cp -r $(TARGET_DIR) build-lfi
	cp makefiles/Makefile.lfi build-lfi
	cd build-lfi; make -f Makefile.lfi -j $(JOBS)

build-lfi-stores: $(TARGET_DIR)
	cp -r $(TARGET_DIR) build-lfi-stores
	cp makefiles/Makefile.lfi-stores build-lfi-stores
	cd build-lfi-stores; make -f Makefile.lfi-stores -j $(JOBS)

build-native: $(TARGET_DIR)
	cp -r $(TARGET_DIR) build-native
	cp makefiles/Makefile.native build-native
	cd build-native; make -f Makefile.native -j $(JOBS)

install:
	cd build-lfi; make -f Makefile.lfi install
	cd build-lfi-stores; make -f Makefile.lfi-stores install
	cd build-native; make -f Makefile.native install

image.gif:
	wget -O image.gif https://svs.gsfc.nasa.gov/vis/a010000/a014100/a014132/BHW_Binary_Black_Holes_Accretion_Disk.gif

bench: giftest.csv

# GIF decode benchmark
giftest.csv: build-native build-lfi build-lfi-stores image.gif
	../hyperfine.py --name giftest --cmd "{BUILD_DIR}/gif2rgb image.gif > /dev/null" --targets "$(HYPERFINE_TARGETS)" --runs $(RUNS) --warmup $(WARMUP)

clean:
	rm -rf $(BUILD_DIRS) $(TARGET_DIR) image.gif giflib.tar.gz
		rm -f *.csv

.PHONY: all bench clean
