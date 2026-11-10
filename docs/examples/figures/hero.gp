# The tetrahedron of the tutorial: outward unit normals, a probe point q and its foot on the slanted face.
set terminal svg size 640,480
set output 'hero.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.12 noborder
plot 'hero.axes.dat' u 1:2:3:4 w vectors filled head lc rgb '#716868' lw 1, \
     'hero.axlabels.dat' u 1:2:3 w labels center tc '#716868', \
     'hero.faces.dat' u 1:2 w filledcurves closed lc rgb '#1f1a1a', \
     'hero.edges.dat' u 1:2 w lines lc rgb '#1f1a1a' lw 2, \
     'hero.normals.dat' u 1:2:3:4 w vectors filled head lc rgb '#c92a2a' lw 2, \
     'hero.distance.dat' u 1:2 w lines lc rgb '#1f4f8a' lw 2 dt 2, \
     'hero.probe.dat' u 1:2 w points pt 7 ps 1.2 lc rgb '#1f4f8a', \
     'hero.vertices.dat' u 1:2:3 w labels right offset -0.6,0, \
     'hero.probelabels.dat' u 1:2:3 w labels left offset 0.8,0 tc '#1f4f8a'
