# Results

## Apple M2

```
Benchmark 1: lfi-run -- ./build-lfi/image_change_quality
  Time (mean ± σ):      1.309 s ±  0.000 s    [User: 1.281 s, System: 0.028 s]
  Range (min … max):    1.308 s …  1.309 s    3 runs
 
Benchmark 2: lfi-run -- ./build-lfi-stores/image_change_quality
  Time (mean ± σ):      1.197 s ±  0.000 s    [User: 1.162 s, System: 0.035 s]
  Range (min … max):    1.196 s …  1.197 s    3 runs
 
Benchmark 3: ./build-native/image_change_quality
  Time (mean ± σ):      1.159 s ±  0.001 s    [User: 1.135 s, System: 0.024 s]
  Range (min … max):    1.158 s …  1.159 s    3 runs
 
Summary
  ./build-native/image_change_quality ran
    1.03 ± 0.00 times faster than lfi-run -- ./build-lfi-stores/image_change_quality
    1.13 ± 0.00 times faster than lfi-run -- ./build-lfi/image_change_quality
```
