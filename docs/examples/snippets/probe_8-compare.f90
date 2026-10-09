print '(A,I0)', 'points within 0.5 of the origin  ', count(g < 0.5_R8P)
i = maxloc(normL2(g), dim=1)
print '(A,3F8.4)', 'the farthest point from the origin', g(i)%x, g(i)%y, g(i)%z
print '(A,L1)', 'g(1) shorter than g(2): ', g(1) < g(2)
