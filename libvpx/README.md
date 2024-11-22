# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
Benchmark 1: lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm
  Time (mean ± σ):      1.508 s ±  0.000 s    [User: 1.272 s, System: 0.237 s]
  Range (min … max):    1.508 s …  1.509 s    5 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm
  Time (mean ± σ):      1.419 s ±  0.000 s    [User: 1.219 s, System: 0.200 s]
  Range (min … max):    1.419 s …  1.419 s    5 runs
 
Benchmark 3: ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm
  Time (mean ± σ):      1.099 s ±  0.000 s    [User: 0.950 s, System: 0.149 s]
  Range (min … max):    1.099 s …  1.100 s    5 runs
 
Summary
  ./build-native/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm ran
    1.29 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm
    1.37 ± 0.00 times faster than lfi-run -- ./build-lfi/vpxdec --threads=1 -o /dev/null vpx-benchdata/elephants-dream.webm
```

Summary:

* LFI-full: 37% overhead
* LFI-stores: 29% overhead
