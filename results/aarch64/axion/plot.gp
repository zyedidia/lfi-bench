set term png
set output "axion.png"
set key samplen 1 spacing 1.1 font ",10"

set datafile separator ","
set style fill solid border -1
set xtics rotate by -45
set xtics scale 0
set yrange [0:30]
set ylabel "Percent increase over native runtime"
set title "LFI-bench - Google Axion (Arm Neoverse V2)"

plot "lfi.csv" using 2: xtic(1) with histogram title "LFI", \
     "lfi-stores.csv" using 2: xtic(1) with histogram title "LFI-stores"
