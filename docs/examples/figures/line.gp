# distance_to_line: from self to the line through pt1 and pt2; is_collinear: a point on that line.
set terminal svg size 560,420
set output 'line.svg'
unset border
unset xtics
unset ytics
unset key
plot 'line.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'line.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'line.line.dat' u 1:2 w lines lc rgb '#179299' lw 2, \
     'line.distance.dat' u 1:2 w lines lc rgb '#fe640b' lw 2 dt 2, \
     'line.points.dat' u 1:2 w points pt 7 ps 1 lc rgb '#179299', \
     'line.probe.dat' u 1:2 w points pt 7 ps 1.2 lc rgb '#fe640b', \
     'line.labels.dat' u 1:2:3 w labels left offset 0.8,-0.6, \
     'line.probelabels.dat' u 1:2:3 w labels left offset 0.8,0 tc '#fe640b'
