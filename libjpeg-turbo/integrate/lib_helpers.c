#include "turbojpeg.h"

int jpeg_decompress(tjhandle handle, const unsigned char *jpegBuf,
        unsigned long jpegSize, unsigned char *dstBuf,
        int width, int height) {
    return tjDecompress2(handle, jpegBuf, jpegSize, dstBuf, width, 0, height,
            TJPF_RGB, 0);
}
