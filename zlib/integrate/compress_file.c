#include <stdio.h>
#include <stdlib.h>
#include <zlib.h>

#include "zlib_box.h"

#define CHUNK 16384  // Buffer size for reading/writing

void compress_file(const char *input_file, const char *output_file) {
    FILE *source = fopen(input_file, "rb");
    if (!source) {
        perror("Failed to open input file");
        exit(EXIT_FAILURE);
    }

    FILE *dest = fopen(output_file, "wb");
    if (!dest) {
        perror("Failed to open output file");
        fclose(source);
        exit(EXIT_FAILURE);
    }

    z_stream strm = {0};
    if (LFI_CALL(deflateInit, &strm, Z_DEFAULT_COMPRESSION) != Z_OK) {
        fprintf(stderr, "Failed to initialize compression\n");
        fclose(source);
        fclose(dest);
        exit(EXIT_FAILURE);
    }

    unsigned char in[CHUNK];
    unsigned char out[CHUNK];
    int flush;

    do {
        strm.avail_in = fread(in, 1, CHUNK, source);
        if (ferror(source)) {
            fprintf(stderr, "Error reading input file\n");
            deflateEnd(&strm);
            fclose(source);
            fclose(dest);
            exit(EXIT_FAILURE);
        }
        flush = feof(source) ? Z_FINISH : Z_NO_FLUSH;
        strm.next_in = in;

        do {
            strm.avail_out = CHUNK;
            strm.next_out = out;
            LFI_CALL(deflate, &strm, flush);
            size_t have = CHUNK - strm.avail_out;
            if (fwrite(out, 1, have, dest) != have || ferror(dest)) {
                fprintf(stderr, "Error writing output file\n");
                LFI_CALL(deflateEnd, &strm);
                fclose(source);
                fclose(dest);
                exit(EXIT_FAILURE);
            }
        } while (strm.avail_out == 0);

    } while (flush != Z_FINISH);

    LFI_CALL(deflateEnd, &strm);
    fclose(source);
    fclose(dest);
    printf("File '%s' compressed successfully to '%s'\n", input_file, output_file);
}

int main() {
    const char *input_file = "bigfile.txt";
    const char *output_file = "bigfile.txt.gz";

    compress_file(input_file, output_file);

    return 0;
}
