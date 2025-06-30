#include <turbojpeg.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>
#include <cstdlib>

void benchmark_decode_image(const char* filename, int iterations) {
    std::cout << "Decoding " << filename << " " << iterations << " times..." << std::endl;

    std::ifstream file(filename, std::ios::binary | std::ios::ate);
    if (!file.is_open()) {
        std::cout << "Failed to open " << filename << std::endl;
        return;
    }

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);

    std::vector<unsigned char> buffer(size);
    if (!file.read(reinterpret_cast<char*>(buffer.data()), size)) {
        std::cout << "Failed to read " << filename << std::endl;
        return;
    }
    file.close();

    tjhandle handle = tjInitDecompress();
    if (!handle) {
        std::cout << "Failed to initialize TurboJPEG decompressor: " << tjGetErrorStr() << std::endl;
        return;
    }

    int width, height, jpegSubsamp, jpegColorspace;
    if (tjDecompressHeader3(handle, buffer.data(), size, &width, &height, &jpegSubsamp, &jpegColorspace) < 0) {
        std::cout << "Failed to read JPEG header for " << filename << ": " << tjGetErrorStr() << std::endl;
        tjDestroy(handle);
        return;
    }

    std::cout << "Image dimensions: " << width << "x" << height << std::endl;

    if (width <= 0 || height <= 0 || width > 16384 || height > 16384) {
        std::cout << "Skipping " << filename << " - invalid or too large dimensions" << std::endl;
        tjDestroy(handle);
        return;
    }

    size_t bufferSize = width * height * 3;
    std::vector<unsigned char> imgBuffer(bufferSize);

    for (int i = 0; i < iterations; i++) {
        if (tjDecompress2(handle, buffer.data(), size, imgBuffer.data(), width, 0, height, TJPF_RGB, 0) < 0) {
            std::cout << "Failed to decode " << filename << " (iteration " << i << "): " << tjGetErrorStr() << std::endl;
        }
    }

    tjDestroy(handle);
}

int main(int argc, char* argv[]) {
    int iterations = 10;

    if (argc > 1) {
        iterations = std::atoi(argv[1]);
        if (iterations <= 0) {
            std::cout << "Invalid number of iterations: " << argv[1] << std::endl;
            return 1;
        }
    }

    std::cout << "Running JPEG decoding benchmark with " << iterations << " iterations..." << std::endl;

    auto start = std::chrono::high_resolution_clock::now();

    benchmark_decode_image("image.jpg", iterations);
    benchmark_decode_image("test.jpeg", iterations);

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);

    std::cout << "Completed in " << duration.count() << "ms" << std::endl;
    return 0;
}