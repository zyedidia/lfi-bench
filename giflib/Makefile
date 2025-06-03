RUNS   ?= 5
WARMUP ?= 1

JOBS := $(shell nproc)

TARGET_DIR:= giflib

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

#install:

image.gif:
	wget -O image.gif https://svs.gsfc.nasa.gov/vis/a010000/a014100/a014132/BHW_Binary_Black_Holes_Accretion_Disk.gif

bench: build-native build-lfi build-lfi-stores image.gif
	hyperfine --runs $(RUNS) --export-csv giftest.csv \
		-n 'LFI' 'lfi-run -- build-lfi/gif2rgb image.gif > /dev/null' \
		-n 'LFI-stores' 'lfi-run -- build-lfi-stores/gif2rgb image.gif > /dev/null' \
		-n 'Native' 'build-native/gif2rgb image.gif > /dev/null'

clean:
	rm -rf $(TARGET_DIR) build-native build-lfi build-lfi-stores image.gif giflib.tar.gz

.PHONY: all bench clean
