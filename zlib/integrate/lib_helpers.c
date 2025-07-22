#include "zlib.h"

int zlib_deflateInit(z_streamp strm, int level){
	return deflateInit(strm, level); 
}

int zlib_deflate(z_streamp strm, int flush){
	return deflate(strm, flush);
}

int zlib_deflateEnd(z_streamp strm) {
	return deflateEnd(strm);
}

int zlib_inflate(z_streamp strm, int flush){
	return inflate(strm, flush);
}

int zlib_inflateInit(z_streamp strm){
	return inflateInit(strm);
}

int zlib_inflateEnd(z_streamp strm) {
	return inflateEnd(strm);
}



