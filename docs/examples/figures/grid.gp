# The grid points inside the tetrahedron: every signed distance to the faces is negative.
set terminal svg size 560,420
set output 'grid.svg'
unset border
unset xtics
unset ytics
unset key
plot 'grid.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'grid.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'grid.points.dat' u 1:2 w points pt 7 ps 0.35 lc rgb '#ea76cb', \
     'grid.edges.dat' u 1:2 w lines lc rgb '#179299' lw 2
