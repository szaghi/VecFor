# The tetrahedron of the tutorial: outward unit normals, a probe point q and its foot on the slanted face.
set terminal svg size 640,480
set output 'hero.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.12 noborder
plot 'hero.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#9ca0b0' lw 1, \
     'hero.axlabels.dat' u 1:2:3 w labels center tc '#9ca0b0', \
     'hero.faces.dat' u 1:2 w filledcurves closed lc rgb '#179299', \
     'hero.edges.dat' u 1:2 w lines lc rgb '#179299' lw 2, \
     'hero.normals.dat' u 1:2:3:4 w vectors filled head lc rgb '#ea76cb' lw 2, \
     'hero.distance.dat' u 1:2 w lines lc rgb '#fe640b' lw 2 dt 2, \
     'hero.probe.dat' u 1:2 w points pt 7 ps 1.2 lc rgb '#fe640b', \
     'hero.vertices.dat' u 1:2:3 w labels right offset -0.6,0, \
     'hero.probelabels.dat' u 1:2:3 w labels left offset 0.8,0 tc '#fe640b'
