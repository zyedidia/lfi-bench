# zlib

Download and build source code:

```
./download-source.sh
./build.sh
```

Generate the benchmark data:

```
./gen-testdata.sh
```

Execute handrolled benchmarks

```
./bench.sh
```

# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
+ hyperfine lfi-run -- build-lfi/compress_file lfi-run -- build-lfi-stores/compress_file build-native/compress_file
Benchmark 1: lfi-run -- build-lfi/compress_file
  Time (mean ± σ):     308.0 ms ±   1.1 ms    [User: 306.5 ms, System: 1.2 ms]
  Range (min … max):   306.2 ms … 309.8 ms    10 runs

Benchmark 2: lfi-run -- build-lfi-stores/compress_file
  Time (mean ± σ):     280.9 ms ±   3.7 ms    [User: 278.3 ms, System: 2.4 ms]
  Range (min … max):   276.3 ms … 288.6 ms    10 runs

Benchmark 3: build-native/compress_file
  Time (mean ± σ):     271.9 ms ±   2.8 ms    [User: 268.2 ms, System: 3.2 ms]
  Range (min … max):   267.4 ms … 275.7 ms    10 runs

Summary
  build-native/compress_file ran
    1.03 ± 0.02 times faster than lfi-run -- build-lfi-stores/compress_file
    1.13 ± 0.01 times faster than lfi-run -- build-lfi/compress_file
+ hyperfine lfi-run -- build-lfi/decompress_file lfi-run -- build-lfi-stores/decompress_file build-native/decompress_file
Benchmark 1: lfi-run -- build-lfi/decompress_file
  Time (mean ± σ):      42.0 ms ±   0.6 ms    [User: 39.1 ms, System: 2.6 ms]
  Range (min … max):    40.6 ms …  43.6 ms    69 runs

Benchmark 2: lfi-run -- build-lfi-stores/decompress_file
  Time (mean ± σ):      37.4 ms ±   0.9 ms    [User: 34.6 ms, System: 2.5 ms]
  Range (min … max):    36.5 ms …  39.7 ms    77 runs

Benchmark 3: build-native/decompress_file
  Time (mean ± σ):      37.1 ms ±   0.7 ms    [User: 34.8 ms, System: 1.8 ms]
  Range (min … max):    36.5 ms …  39.0 ms    77 runs

Summary
  build-native/decompress_file ran
    1.01 ± 0.03 times faster than lfi-run -- build-lfi-stores/decompress_file
    1.13 ± 0.03 times faster than lfi-run -- build-lfi/decompress_file
```
