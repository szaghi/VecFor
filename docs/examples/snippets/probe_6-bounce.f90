r = vt - vn                                     ! a slip wall: the normal component reverses
print '(A,3F8.4)', 'v before the bounce    ', v%x, v%y, v%z
print '(A,3F8.4)', 'v after the bounce     ', r%x, r%y, r%z
print '(A,2F8.4)', 'speed before and after ', v%normL2(), r%normL2()
print '(A,2F8.4)', 'v . n before and after ', v .dot. n, r .dot. n
