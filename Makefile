MACHINE ?= current

all:
	@echo "available targets: bench, consolidate, plot"

bench:
	make -C coremark
	make -C dav1d
	make -C libjpeg-turbo
	make -C libvpx
	make -C opus
	make -C zlib

consolidate:
	mkdir -p results/$(MACHINE)
	go run results/consolidate.go -config LFI \
		coremark/*.csv \
		dav1d/*.csv \
		libjpeg-turbo/*.csv \
		libvpx/*.csv \
		opus/*.csv \
		zlib/*.csv > results/$(MACHINE)/lfi.csv
	go run results/consolidate.go -config LFI-stores \
		coremark/*.csv \
		dav1d/*.csv \
		libjpeg-turbo/*.csv \
		libvpx/*.csv \
		opus/*.csv \
		zlib/*.csv > results/$(MACHINE)/lfi-stores.csv

plot:
	@echo "TODO"

.PHONY: bench consolidate plot
