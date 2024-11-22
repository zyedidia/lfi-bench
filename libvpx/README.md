# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
Benchmark 1: lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      9.219 s ±  0.001 s    [User: 8.996 s, System: 0.223 s]
  Range (min … max):    9.218 s …  9.220 s    3 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      8.772 s ±  0.002 s    [User: 8.512 s, System: 0.260 s]
  Range (min … max):    8.770 s …  8.773 s    3 runs
 
  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet system without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.
 
Benchmark 3: ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      8.627 s ±  0.002 s    [User: 8.383 s, System: 0.244 s]
  Range (min … max):    8.625 s …  8.629 s    3 runs
 
Summary
  ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm ran
    1.02 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
    1.07 ± 0.00 times faster than lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
```

Summary:

* LFI-full: 6.9% overhead
* LFI-stores: 1.7% overhead
