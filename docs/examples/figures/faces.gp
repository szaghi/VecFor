# face_normal4 and face_normal3: a normal as long as the face is large (crimson), and the unit normal, norm='y' (indigo).
set terminal svg size 640,400
set output 'faces.svg'
unset border
unset xtics
unset ytics
unset key
set style fill transparent solid 0.15 noborder
plot 'faces.faces.dat' u 1:2 w filledcurves closed lc rgb '#1f1a1a', \
     'faces.faces.dat' u 1:2 w lines lc rgb '#1f1a1a' lw 2, \
     'faces.area.dat' u 1:2:3:4 w vectors filled head lc rgb '#c92a2a' lw 2, \
     'faces.unit.dat' u 1:2:3:4 w vectors filled head lc rgb '#1f4f8a' lw 2, \
     'faces.labels.dat' u 1:2:3 w labels center offset 0,-1
