# Two vectors, the parallelogram they span and their cross product: as long as the parallelogram is large.
set terminal svg size 560,420
set output 'cross.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.15 noborder
plot 'cross.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'cross.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'cross.area.dat' u 1:2 w filledcurves closed lc rgb '#179299', \
     'cross.ab.dat' u 1:2:3:4 w vectors filled head lc rgb '#179299' lw 2, \
     'cross.axb.dat' u 1:2:3:4 w vectors filled head lc rgb '#ea76cb' lw 2, \
     'cross.labels.dat' u 1:2:3 w labels left offset 0.8,0
