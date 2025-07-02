#include <turbojpeg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>
#include "jpeg.h"


void benchmark_decode_image(const char* filename, int iterations) {
    printf("Decoding %s %d times...\n", filename, iterations);

    struct stat st;
    if (stat(filename, &st) != 0) {
        printf("Failed to stat %s\n", filename);
        exit(1);
    }
    long size = st.st_size;

    FILE* file = fopen(filename, "rb");
    if (!file) {
        printf("Failed to open %s\n", filename);
        exit(1);
    }

    printf("1\n");
    unsigned char* buffer = jpeg_malloc(size);
    if (!buffer) {
        printf("Failed to allocate memory for %s\n", filename);
        fclose(file);
        exit(1);
    }

    if (fread(buffer, 1, size, file) != size) {
        printf("Failed to read %s\n", filename);
        free(buffer);
        exit(1);
    }
    fclose(file);

    printf("2\n");

    tjhandle handle = tjInitDecompress();

    printf("2.5\n");
    if (!handle) {
        printf("Failed to initialize TurboJPEG decompressor: %s\n", tjGetErrorStr());
        free(buffer);
        exit(1);
    }
    int * args = (int *)jpeg_malloc(sizeof(int) * 4);

    if (tjDecompressHeader3(handle, buffer, size, &args[0], &args[1], &args[2], &args[3]) < 0) {
        printf("Failed to read JPEG header for %s: %s\n", filename, tjGetErrorStr());
        exit(1);
    }

    printf("3\n");
    int width = args[0];
    int height = args[1];
    int jpegSubsamp = args[2];
    int jpegColorspace = args[3];

    printf("Image dimensions: %dx%d\n", width, height);

    if (width <= 0 || height <= 0 || width > 16384 || height > 16384) {
        printf("Skipping %s - invalid or too large dimensions\n", filename);
        exit(1);
    }

    size_t bufferSize = width * height * 3;
    unsigned char* imgBuffer = jpeg_malloc(bufferSize);
    if (!imgBuffer) {
        printf("Failed to allocate image buffer for %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < iterations; i++) {
        if (tjDecompress2(handle, buffer, size, imgBuffer, width, 0, height, TJPF_RGB, 0) < 0) {
            printf("Failed to decode %s (iteration %d): %s\n", filename, i, tjGetErrorStr());
        }
    }

    printf("4\n");
}

int main(int argc, char* argv[]) {
    int iterations = 10;

    if (argc > 1) {
        iterations = atoi(argv[1]);
        if (iterations <= 0) {
            printf("Invalid number of iterations: %s\n", argv[1]);
            exit(1);
        }
    }

    /* printf("Running JPEG decoding benchmark with %d iterations...\n", iterations); */

    /* clock_t start = clock(); */

    benchmark_decode_image("image.jpg", iterations);
    benchmark_decode_image("test.jpeg", iterations);

    /* clock_t end = clock(); */
    /* double duration = ((double)(end - start)) / CLOCKS_PER_SEC * 1000; */

    /* printf("Completed in %.0fms\n", duration); */
    /* return 0; */
}
