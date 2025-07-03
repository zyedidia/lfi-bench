include ../../common.mk

all:
	nm -g --defined-only ../build-lfi/libturbojpeg.so | cut -f3 -d' ' > symbols.txt
	$(LFI_CC) lib_helpers.c -static-pie -Wl,--whole-archive  ../build-lfi/libturbojpeg.a -Wl,--no-whole-archive -o libturbojpeg.lfi -O2 -lboxrt -Wl,--export-dynamic -I ../libjpeg-turbo/src
	$(LFI_BIND) -gen-trampolines lib_trampolines.S -gen-init lib_init.c \
		-lib-path $(shell pwd)/libturbojpeg.lfi -lib jpeg -symbols jpeg_decompress -symbols-file symbols.txt libturbojpeg.lfi
	$(CC) -g lib_init.c lib_trampolines.S decode-benchmark.c -I ../libjpeg-turbo/src /opt/lfi/lib/liblfi.a -o benchmark -I/opt/lfi/include
clean:
	rm -f lib_init.* lib_trampolines.S jpeg.h symbols.txt benchmark libturbojpeg.lfi
