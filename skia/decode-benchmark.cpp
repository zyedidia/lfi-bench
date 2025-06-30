#include "include/core/SkStream.h"
#include "include/core/SkData.h"
#include "include/codec/SkCodec.h"
#include "include/core/SkBitmap.h"
#include "include/core/SkImageInfo.h"
#include <memory>
#include <iostream>
#include <chrono>
#include <cstdlib>

void benchmark_decode_image(const char* filename, int iterations) {
    std::cout << "Decoding " << filename << " " << iterations << " times..." << std::endl;
    
    // Load the file data once
    auto data = SkData::MakeFromFileName(filename);
    if (!data) {
        std::cout << "Failed to load " << filename << std::endl;
        return;
    }
    
    // Create codec from data to check image info first
    auto codec = SkCodec::MakeFromData(data);
    if (!codec) {
        std::cout << "Failed to create codec for " << filename << std::endl;
        return;
    }
    
    // Get image info and validate dimensions
    SkImageInfo info = codec->getInfo();
    std::cout << "Image dimensions: " << info.width() << "x" << info.height() << std::endl;
    
    // Check for reasonable dimensions (avoid huge memory allocations)
    if (info.width() <= 0 || info.height() <= 0 || 
        info.width() > 16384 || info.height() > 16384) {
        std::cout << "Skipping " << filename << " - invalid or too large dimensions" << std::endl;
        return;
    }
    
    for (int i = 0; i < iterations; i++) {
        // Create codec from data for each iteration
        auto iterCodec = SkCodec::MakeFromData(data);
        if (!iterCodec) {
            std::cout << "Failed to create codec for " << filename << " (iteration " << i << ")" << std::endl;
            continue;
        }
        
        // Create bitmap for decoded data
        SkBitmap bitmap;
        if (!bitmap.tryAllocPixels(info)) {
            std::cout << "Failed to allocate bitmap for " << filename << " (iteration " << i << ")" << std::endl;
            continue;
        }
        
        // Decode the image
        SkCodec::Result result = iterCodec->getPixels(info, bitmap.getPixels(), bitmap.rowBytes());
        
        if (result != SkCodec::kSuccess) {
            std::cout << "Failed to decode " << filename << " (iteration " << i << ")" << std::endl;
        }
    }
}

int main(int argc, char* argv[]) {
    int iterations = 10; // default
    
    if (argc > 1) {
        iterations = std::atoi(argv[1]);
        if (iterations <= 0) {
            std::cout << "Invalid number of iterations: " << argv[1] << std::endl;
            return 1;
        }
    }
    
    std::cout << "Running image decoding benchmark with " << iterations << " iterations..." << std::endl;
    
    auto start = std::chrono::high_resolution_clock::now();
    
    // Decode each image the specified number of times
    benchmark_decode_image("image.jpg", iterations);
    benchmark_decode_image("image.png", iterations);
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    std::cout << "Completed in " << duration.count() << "ms" << std::endl;
    return 0;
}