program collinear
!< Cookbook: are three points on one line? Exact by default, within a tolerance if asked.
use penf, only : R8P
use vecfor, only : ex, ey, is_collinear, vector
implicit none
type(vector) :: a, b, p

a = ex ; b = ey
p = (a + b) / 2
print '(A,L1)', 'midpoint:                   ', p%is_collinear(pt1=a, pt2=b)
p = 0.1_R8P * a + 0.9_R8P * b
print '(A,L1)', '0.1 a + 0.9 b:              ', p%is_collinear(pt1=a, pt2=b)
print '(A,L1)', '0.1 a + 0.9 b, within 1e-12: ', is_collinear(p, pt1=a, pt2=b, tolerance=1.e-12_R8P)
p = 2 * a                                                  ! off the line
print '(A,L1)', '2 a, within 1e-12:          ', p%is_collinear(pt1=a, pt2=b, tolerance=1.e-12_R8P)
endprogram collinear
