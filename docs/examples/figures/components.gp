# A slip wall: the velocity v is split into its components normal and tangential to the face; the normal one reverses.
set terminal svg size 560,420
set output 'components.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.15 noborder
plot 'components.face.dat' u 1:2 w filledcurves closed lc rgb '#179299', \
     'components.face.dat' u 1:2 w lines lc rgb '#179299' lw 2, \
     'components.n.dat' u 1:2:3:4 w vectors filled head lc rgb '#ea76cb' lw 2, \
     'components.split.dat' u 1:2:3:4 w vectors filled head lc rgb '#8839ef' lw 1.5 dt 2, \
     'components.v.dat' u 1:2:3:4 w vectors filled head lc rgb '#fe640b' lw 2, \
     'components.r.dat' u 1:2:3:4 w vectors filled head lc rgb '#40a02b' lw 2, \
     'components.labels.dat' u 1:2:3 w labels left offset 0.8,0
