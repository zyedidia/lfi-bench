# zstd

Download and build source code:

```
./download-source.sh
./build.sh
```

Generate the benchmark data:

```
./gen-testdata.sh
```

Execute builtin zstd compression benchmark

```
./bench.sh
```

# Results

## Apple M2

Expected results on an Apple M2 with the core frequency pinned to 3.096GHz:

```
+ ./build-native/programs/zstd -b1 bigfile.txt
 1#bigfile.txt       :  10100000 ->   7576511 (x1.333), 1533.8 MB/s, 1234.6 MB/s
+ lfi-run -- ./build-lfi-stores/programs/zstd -b1 bigfile.txt
warning: verification disabled
 1#bigfile.txt       :  10100000 ->   7576511 (x1.333), 1346.8 MB/s, 1234.6 MB/s
+ lfi-run -- ./build-lfi/programs/zstd -b1 bigfile.txt
warning: verification disabled
 1#bigfile.txt       :  10100000 ->   7576511 (x1.333), 1130.0 MB/s, 1113.0 MB/s
```
