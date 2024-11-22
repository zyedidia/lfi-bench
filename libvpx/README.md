# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
Benchmark 1: lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      9.224 s ±  0.002 s    [User: 8.945 s, System: 0.276 s]
  Range (min … max):    9.221 s …  9.226 s    3 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      8.777 s ±  0.001 s    [User: 8.512 s, System: 0.262 s]
  Range (min … max):    8.776 s …  8.777 s    3 runs
 
Benchmark 3: ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
  Time (mean ± σ):      8.633 s ±  0.002 s    [User: 8.422 s, System: 0.208 s]
  Range (min … max):    8.632 s …  8.635 s    3 runs
 
Summary
  ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm ran
    1.02 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
    1.07 ± 0.00 times faster than lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/sample-30s.webm
```

Summary:

* LFI-full: 6.9% overhead
* LFI-stores: 1.7% overhead
