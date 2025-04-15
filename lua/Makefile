RUNS   ?= 2
WARMUP ?= 1

LFI        ?= /opt/aarch64-lfi-clang
LFI_STORES ?= /opt/aarch64-lfi-stores-clang
NATIVE     ?= /opt/aarch64-native-clang

all: bench

lua:
	git clone https://github.com/lua/lua
	mv lua-makefile lua/makefile

benchmarks:
	git clone https://github.com/gligneul/Lua-Benchmarks benchmarks

build-lfi: lua
	mkdir -p build-lfi
	make -C lua LDFLAGS="-static-pie" CC=$(LFI)/bin/clang -B -j8
	mv lua/lua build-lfi

build-lfi-stores: lua
	mkdir -p build-lfi-stores
	make -C lua LDFLAGS="-static-pie" CC=$(LFI_STORES)/bin/clang -B -j8
	mv lua/lua build-lfi-stores

build-native: lua
	mkdir -p build-native
	make -C lua LDFLAGS="-static-pie" CC=$(NATIVE)/bin/clang -B -j8
	mv lua/lua build-native

BENCH_1 = benchmarks/ack.lua 3 10
NAME_1 = ack.csv

BENCH_2 = benchmarks/fixpoint-fact.lua 3000
NAME_2 = fixpoint-fact.csv

BENCH_3 = benchmarks/heapsort.lua 10 250000
NAME_3 = heapsort.csv

BENCH_4 = benchmarks/mandel.lua
NAME_4 = mandelbrot.csv

BENCH_5 = benchmarks/qt.lua
NAME_5 = juliaset.csv

BENCH_6 = benchmarks/queen.lua 12
NAME_6 = queen.csv

BENCH_7 = benchmarks/sieve.lua 5000
NAME_7 = sieve.csv

BENCH_8 = benchmarks/binary-trees.lua 15
NAME_8 = binary.csv

BENCH_9 = benchmarks/n-body.lua 1000000
NAME_9 = n-body.csv

BENCH_10 = benchmarks/fannkuch-redux.lua 10
NAME_10 = fannkuch.csv

BENCH_11 = benchmarks/fasta.lua 2500000
NAME_11 = fasta.csv

BENCH_12 = benchmarks/k-nucleotide.lua < fasta1000000.txt
NAME_12 = k-nucleotide.csv

BENCH_13 = benchmarks/spectral-norm.lua 1000
NAME_13 = spectral-norm.csv

CSV =   $(NAME_1) \
		$(NAME_2) \
		$(NAME_3) \
		$(NAME_4) \
		$(NAME_5) \
		$(NAME_6) \
		$(NAME_7) \
		$(NAME_8) \
		$(NAME_9) \
		$(NAME_10) \
		$(NAME_11) \
		$(NAME_12) \
		$(NAME_13) \

define run_bench =
	@echo "Running benchmark $(1): $(2)"; \
	hyperfine --export-csv $(1) --runs $(RUNS) --warmup $(WARMUP) \
		-n 'LFI' 'lfi-run -- ./build-lfi/lua $(2)' \
		-n 'LFI-stores' 'lfi-run -- ./build-lfi-stores/lua $(2)' \
		-n 'Native' './build-native/lua $(2)'
endef

bench: build-native build-lfi build-lfi-stores benchmarks
	./build-native/lua benchmarks/fasta.lua 1000000 > fasta1000000.txt

	$(call run_bench, $(NAME_1), $(BENCH_1))
	$(call run_bench, $(NAME_2), $(BENCH_2))
	$(call run_bench, $(NAME_3), $(BENCH_3))
	$(call run_bench, $(NAME_4), $(BENCH_4))
	$(call run_bench, $(NAME_5), $(BENCH_5))
	$(call run_bench, $(NAME_6), $(BENCH_6))
	$(call run_bench, $(NAME_7), $(BENCH_7))
	$(call run_bench, $(NAME_8), $(BENCH_8))
	$(call run_bench, $(NAME_9), $(BENCH_9))
	$(call run_bench, $(NAME_10), $(BENCH_10))
	$(call run_bench, $(NAME_11), $(BENCH_11))
	$(call run_bench, $(NAME_12), $(BENCH_12))
	$(call run_bench, $(NAME_13), $(BENCH_13))

MACHINE=aarch64/m2

consolidate:
	mkdir -p results/$(MACHINE)
	go run ../results/consolidate.go -config LFI $(CSV) > results/$(MACHINE)/lfi.csv
	go run ../results/consolidate.go -config LFI-stores $(CSV) > results/$(MACHINE)/lfi-stores.csv

.PHONY: all bench consolidate

.NOTPARALLEL:
