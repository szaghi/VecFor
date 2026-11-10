# rotate(axis=, angle=): ex turns about the diagonal on a cone, twelve steps of 30 degrees.
set terminal svg size 560,420
set output 'rotation.svg'
unset border
unset xtics
unset ytics
unset key
plot 'rotation.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#716868' lw 1, \
     'rotation.axlabels.dat' u 1:2:3 w labels center tc '#716868', \
     'rotation.path.dat' u 1:2 w lines lc rgb '#c92a2a' lw 1.5 dt 2, \
     'rotation.steps.dat' u 1:2:3:4 w vectors filled head lc rgb '#1f1a1a' lw 1.5, \
     'rotation.axis.dat' u 1:2:3:4 w vectors filled head lc rgb '#1f4f8a' lw 2, \
     'rotation.labels.dat' u 1:2:3 w labels left offset 0.8,0 tc '#1f4f8a'
