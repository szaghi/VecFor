h = g%distance_to_plane(pt1=p(2), pt2=p(3), pt3=p(4))
print '(A,I0,A)', 'distances of ', n, ' points'
print '(A,I0)',    'points outside            ', count(d > 0._R8P)
print '(A,ES9.1)', 'largest difference to host', maxval(abs(d - h))
