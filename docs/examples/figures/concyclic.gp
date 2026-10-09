# is_concyclic: a, p4, p2, p3 lie on one circle, in this order.
set terminal svg size 560,420
set output 'concyclic.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.12 noborder
plot 'concyclic.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'concyclic.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'concyclic.face.dat' u 1:2 w filledcurves closed lc rgb '#179299', \
     'concyclic.circle.dat' u 1:2 w lines lc rgb '#ea76cb' lw 2, \
     'concyclic.points.dat' u 1:2 w points pt 7 ps 1 lc rgb '#179299', \
     'concyclic.a.dat' u 1:2 w points pt 7 ps 1.2 lc rgb '#fe640b', \
     'concyclic.labels.dat' u 1:2:3 w labels left offset 0.8,0, \
     'concyclic.alabel.dat' u 1:2:3 w labels right offset -0.8,0 tc '#fe640b'
