allocate(inside(size(g)), source=.true.)
do f = 1, 4
   dist = g%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))   ! every point, one call
   inside = inside .and. dist <= 0._R8P
enddo
print '(A,I0,A,I0)', 'points inside    ', count(inside), ' of ', size(g)
print '(A,F8.4,A,F8.4)', 'volume estimate  ', count(inside) / real(size(g), R8P), ', exact', 1._R8P / 6
