# The grid points inside the tetrahedron: every signed distance to the faces is negative.
set terminal svg size 560,420
set output 'grid.svg'
unset border
unset xtics
unset ytics
unset key
plot 'grid.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#716868' lw 1, \
     'grid.axlabels.dat' u 1:2:3 w labels center tc '#716868', \
     'grid.points.dat' u 1:2 w points pt 7 ps 0.35 lc rgb '#c92a2a', \
     'grid.edges.dat' u 1:2 w lines lc rgb '#1f1a1a' lw 2
