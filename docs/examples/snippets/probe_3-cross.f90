n = a .cross. b                       ! orthogonal to a and b, as long as the area of their parallelogram
call n%printf(prefix='a x b = ')
print '(A,F8.4)', 'area of p2 p3 p4      ', 0.5_R8P * n%normL2()
