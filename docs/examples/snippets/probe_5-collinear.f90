m = (p(2) + p(3)) / 2                          ! the midpoint: exact in floating point
print '(A,L1)',    'midpoint on the line p2 p3:   ', m%is_collinear(pt1=p(2), pt2=p(3))
m = 0.3_R8P * p(2) + 0.7_R8P * p(3)            ! 0.3 and 0.7 are not exact in binary
print '(A,ES8.1)', 'distance of m from the line:  ', m%distance_to_line(pt1=p(2), pt2=p(3))
print '(A,L1)',    'm on the line p2 p3:          ', m%is_collinear(pt1=p(2), pt2=p(3))
print '(A,L1)',    'with a tolerance of 1e-12:    ', m%is_collinear(pt1=p(2), pt2=p(3), tolerance=1.e-12_R8P)
m = m + 1.e-9_R8P * ez
print '(A,L1)',    '1e-9 off, tolerance of 1e-12: ', m%is_collinear(pt1=p(2), pt2=p(3), tolerance=1.e-12_R8P)
