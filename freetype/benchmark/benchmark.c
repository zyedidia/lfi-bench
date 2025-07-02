#include <ft2build.h>
#include FT_FREETYPE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TEST_STRING "The quick brown fox jumps over the lazy dog 0123456789"

int main(int argc, char* argv[]) {
    if (argc < 2 || argc > 3) {
        fprintf(stderr, "Usage: %s <font-file> [iterations]\n", argv[0]);
        return 1;
    }

    int iterations = 100; // default
    if (argc == 3) {
        iterations = atoi(argv[2]);
        if (iterations <= 0) {
            fprintf(stderr, "Error: iterations must be positive\n");
            return 1;
        }
    }

    FT_Library library;
    FT_Face face;

    // Initialize FreeType
    if (FT_Init_FreeType(&library)) {
        fprintf(stderr, "Error initializing FreeType\n");
        return 1;
    }

    // Load font
    if (FT_New_Face(library, argv[1], 0, &face)) {
        fprintf(stderr, "Error loading font: %s\n", argv[1]);
        FT_Done_FreeType(library);
        return 1;
    }

    // Main benchmark loop
    for (int iter = 0; iter < iterations; iter++) {
        // Test multiple font sizes
        for (int size = 8; size <= 48; size += 4) {
            FT_Set_Pixel_Sizes(face, 0, size);

            // Render all ASCII printable characters
            for (int c = 32; c < 127; c++) {
                FT_Load_Char(face, c, FT_LOAD_RENDER);
            }

            // Render a string with kerning
            FT_Bool use_kerning = FT_HAS_KERNING(face);
            FT_UInt previous = 0;

            for (const char* p = TEST_STRING; *p; p++) {
                FT_UInt glyph_index = FT_Get_Char_Index(face, *p);

                if (use_kerning && previous && glyph_index) {
                    FT_Vector delta;
                    FT_Get_Kerning(face, previous, glyph_index, FT_KERNING_DEFAULT, &delta);
                }

                FT_Load_Glyph(face, glyph_index, FT_LOAD_RENDER);
                previous = glyph_index;
            }
        }
    }

    printf("Done with %d itterations...\n", iterations);
    // Cleanup
    FT_Done_Face(face);
    FT_Done_FreeType(library);

    return 0;
}
