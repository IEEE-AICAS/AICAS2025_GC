set title "bloat_34"
set palette negative rgbformula 21,22,23
set cbrange [0:2]
set yrange [240:0]
set size ratio 2.82353
set view map
splot "bloat_34.dat" using 1:2:3 with image
pause -1
