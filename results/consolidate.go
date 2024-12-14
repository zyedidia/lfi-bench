package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

type Benchmark struct {
	Name   string
	Mean   float64
	StdDev float64
	Min    float64
	Max    float64
}

func parseFloat(s string) float64 {
	f, err := strconv.ParseFloat(s, 64)
	if err != nil {
		log.Fatal(err)
	}
	return f
}

func readCSV(path string) [][]string {
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	r := csv.NewReader(f)
	records, err := r.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	return records
}

func calcOverhead(bench string, benches map[string][]Benchmark, w io.Writer) {
	config := benches[bench]
	geomean := 1.0
	n := 0
	for i, b := range config {
		nativeMean := benches["Native"][i].Mean
		overhead := (b.Mean - nativeMean) / nativeMean
		fmt.Fprintf(w, "%s,%.3f\n", b.Name, overhead*100)
		geomean *= (1 + overhead)
		n++
	}
	geomean = math.Pow(geomean, 1.0/float64(n)) - 1
	fmt.Fprintf(w, "geomean,%.3f\n", geomean*100)
}

func main() {
	config := flag.String("config", "LFI", "Configuration to consolidate (LFI,LFI-stores)")

	flag.Parse()
	args := flag.Args()

	benches := make(map[string][]Benchmark)

	for _, a := range args {
		records := readCSV(a)
		for _, r := range records {
			if r[0] == "command" {
				continue
			}
			benches[r[0]] = append(benches[r[0]], Benchmark{
				Name:   strings.TrimSuffix(filepath.Base(a), filepath.Ext(a)),
				Mean:   parseFloat(r[1]),
				StdDev: parseFloat(r[2]),
				Min:    parseFloat(r[6]),
				Max:    parseFloat(r[7]),
			})
		}
	}

	calcOverhead(*config, benches, os.Stdout)
}
