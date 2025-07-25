include ../../common.mk

all:
	nm -g --defined-only ../build-lfi/libz.so | cut -f3 -d' ' > symbols.txt
	$(LFI_CC) -static-pie -Wl,--whole-archive  ../build-lfi/libz.a -Wl,--no-whole-archive -o zlib.lfi -O2 -lboxrt -Wl,--export-dynamic -I ../zlib
	$(LFI_BIND) -gen-trampolines lib_trampolines.S -gen-init lib_init.c \
		-lib-path $(shell pwd)/zlib.lfi -lib zlib_box -symbols-file symbols.txt zlib.lfi
	$(CC) -g lib_init.c lib_trampolines.S compress_file.c -I ../zlib/src /opt/lfi/lib/liblfi.a -o compress_file -I/opt/lfi/include
	$(CC) -g lib_init.c lib_trampolines.S decompress_file.c -I ../zlib/src /opt/lfi/lib/liblfi.a -o decompress_file -I/opt/lfi/include
clean:
	rm -f lib_init.* lib_trampolines.S zlib.h symbols.txt compress_file decompress_file zlib.lfi
