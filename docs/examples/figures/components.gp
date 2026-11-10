# A slip wall: the velocity v is split into its components normal and tangential to the face; the normal one reverses.
set terminal svg size 560,420
set output 'components.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.15 noborder
plot 'components.face.dat' u 1:2 w filledcurves closed lc rgb '#1f1a1a', \
     'components.face.dat' u 1:2 w lines lc rgb '#1f1a1a' lw 2, \
     'components.n.dat' u 1:2:3:4 w vectors filled head lc rgb '#1f1a1a' lw 2, \
     'components.split.dat' u 1:2:3:4 w vectors filled head lc rgb '#716868' lw 1.5 dt 2, \
     'components.v.dat' u 1:2:3:4 w vectors filled head lc rgb '#1f4f8a' lw 2, \
     'components.r.dat' u 1:2:3:4 w vectors filled head lc rgb '#c92a2a' lw 2, \
     'components.labels.dat' u 1:2:3 w labels left offset 0.8,0
