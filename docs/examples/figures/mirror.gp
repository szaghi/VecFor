# mirror(normal=): a tetrahedron (teal) and its image (pink) across the plane of normal (1,1,0).
set terminal svg size 560,420
set output 'mirror.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.12 noborder
plot 'mirror.plane.dat' u 1:2 w filledcurves closed lc rgb '#9ca0b0', \
     'mirror.body.dat' u 1:2 w lines lc rgb '#179299' lw 2, \
     'mirror.image.dat' u 1:2 w lines lc rgb '#ea76cb' lw 2, \
     'mirror.n.dat' u 1:2:3:4 w vectors filled head lc rgb '#fe640b' lw 2, \
     'mirror.labels.dat' u 1:2:3 w labels left offset 0.8,0
