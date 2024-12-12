#include <stdio.h>
#include <stdlib.h>
#include <zlib.h>

#define CHUNK 16384  // Buffer size for reading/writing

void decompress_file(const char *input_file, const char *output_file) {
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
    if (inflateInit(&strm) != Z_OK) {
        fprintf(stderr, "Failed to initialize decompression\n");
        fclose(source);
        fclose(dest);
        exit(EXIT_FAILURE);
    }

    unsigned char in[CHUNK];
    unsigned char out[CHUNK];
    int ret;

    do {
        strm.avail_in = fread(in, 1, CHUNK, source);
        if (ferror(source)) {
            fprintf(stderr, "Error reading input file\n");
            inflateEnd(&strm);
            fclose(source);
            fclose(dest);
            exit(EXIT_FAILURE);
        }
        if (strm.avail_in == 0) break;
        strm.next_in = in;

        do {
            strm.avail_out = CHUNK;
            strm.next_out = out;
            ret = inflate(&strm, Z_NO_FLUSH);
            if (ret == Z_STREAM_ERROR || ret == Z_DATA_ERROR || ret == Z_MEM_ERROR) {
                fprintf(stderr, "Decompression error: %d\n", ret);
                inflateEnd(&strm);
                fclose(source);
                fclose(dest);
                exit(EXIT_FAILURE);
            }
            size_t have = CHUNK - strm.avail_out;
            if (fwrite(out, 1, have, dest) != have || ferror(dest)) {
                fprintf(stderr, "Error writing output file\n");
                inflateEnd(&strm);
                fclose(source);
                fclose(dest);
                exit(EXIT_FAILURE);
            }
        } while (strm.avail_out == 0);

    } while (ret != Z_STREAM_END);

    inflateEnd(&strm);
    fclose(source);
    fclose(dest);

    if (ret == Z_STREAM_END) {
        printf("File '%s' decompressed successfully to '%s'\n", input_file, output_file);
    } else {
        fprintf(stderr, "Incomplete decompression\n");
        exit(EXIT_FAILURE);
    }
}

int main() {
    const char *input_file = "bigfile.txt.gz";
    const char *output_file = "bigfile_decompressed.txt";

    decompress_file(input_file, output_file);

    return 0;
}
