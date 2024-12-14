MACHINE ?= current

all:
	@echo "available targets: build bench, consolidate, plot"

build:
	make -C coremark build-lfi build-lfi-stores build-native
	make -C dav1d build-lfi build-lfi-stores build-native
	make -C libjpeg-turbo build-lfi build-lfi-stores build-native
	make -C libvpx build-lfi build-lfi-stores build-native
	make -C opus build-lfi build-lfi-stores build-native
	make -C zlib build-lfi build-lfi-stores build-native

bench:
	make -C coremark
	make -C dav1d
	make -C libjpeg-turbo
	make -C libvpx
	make -C opus
	make -C zlib

clean:
	make -C coremark clean
	make -C dav1d clean
	make -C libjpeg-turbo clean
	make -C libvpx clean
	make -C opus clean
	make -C zlib clean

CSV = coremark/*.csv \
	dav1d/*.csv \
	libjpeg-turbo/*.csv \
	libvpx/*.csv \
	opus/*.csv \
	zlib/*.csv

consolidate:
	mkdir -p results/$(MACHINE)
	go run results/consolidate.go -config LFI $(CSV) > results/$(MACHINE)/lfi.csv
	go run results/consolidate.go -raw -config LFI $(CSV) > results/$(MACHINE)/lfi-raw.csv
	go run results/consolidate.go -config LFI-stores $(CSV) > results/$(MACHINE)/lfi-stores.csv
	go run results/consolidate.go -raw -config LFI-stores $(CSV) > results/$(MACHINE)/lfi-stores-raw.csv
	go run results/consolidate.go -raw -config Native $(CSV) > results/$(MACHINE)/native-raw.csv

plot:
	cd results/$(MACHINE) && gnuplot plot.gp

.PHONY: bench consolidate plot build clean
