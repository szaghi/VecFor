# rotate(axis=, angle=): ex turns about the diagonal on a cone, twelve steps of 30 degrees.
set terminal svg size 560,420
set output 'rotation.svg'
unset border
unset xtics
unset ytics
unset key
plot 'rotation.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'rotation.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'rotation.path.dat' u 1:2 w lines lc rgb '#ea76cb' lw 1.5 dt 2, \
     'rotation.steps.dat' u 1:2:3:4 w vectors filled head lc rgb '#179299' lw 1.5, \
     'rotation.axis.dat' u 1:2:3:4 w vectors filled head lc rgb '#fe640b' lw 2, \
     'rotation.labels.dat' u 1:2:3 w labels left offset 0.8,0 tc '#fe640b'
