MACHINE ?= current

BENCH=coremark \
	  dav1d \
	  libjpeg-turbo \
	  libvpx \
	  opus \
	  zlib \
	  sqlite

CSV = $(patsubst %,%/*.csv,$(BENCH))

all:
	@echo "available targets: build bench, consolidate, plot"

build:
	for bench in $(BENCH) ; do \
		$(MAKE) -C $$bench build-lfi build-lfi-stores build-native ; \
	done

bench:
	for bench in $(BENCH) ; do \
		$(MAKE) -C $$bench bench ; \
	done

clean:
	for bench in $(BENCH) ; do \
		$(MAKE) -C $$bench clean ; \
	done

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
