# CoreMark

Download and build source code:

```
./download-source.sh
./build.sh
```

Execute the benchmark with Hyperfine:

```
./bench.sh
```

# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
Benchmark 1: lfi-run -- ./build-lfi/coremark 0x0 0x0 0x66 800000 7 1 2000
  Time (abs ≡):        104.816 s               [User: 104.795 s, System: 0.020 s]
 
Benchmark 2: lfi-run -- ./build-lfi-stores/coremark 0x0 0x0 0x66 800000 7 1 2000
  Time (abs ≡):        100.722 s               [User: 100.701 s, System: 0.020 s]
 
Benchmark 3: ./build-native/coremark 0x0 0x0 0x66 800000 7 1 2000
  Time (abs ≡):        100.456 s               [User: 100.431 s, System: 0.024 s]
 
Summary
  ./build-native/coremark 0x0 0x0 0x66 800000 7 1 2000 ran
    1.00 times faster than lfi-run -- ./build-lfi-stores/coremark 0x0 0x0 0x66 800000 7 1 2000
    1.04 times faster than lfi-run -- ./build-lfi/coremark 0x0 0x0 0x66 800000 7 1 2000
```

Summary:

* LFI-full: 4.3% overhead
* LFI-stores: 0.3% overhead
