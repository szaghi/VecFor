program concyclic_points
!< Cookbook: are four points on one circle? The order matters.
use penf, only : R8P
use vecfor, only : ex, ey, ez, is_concyclic, vector
implicit none
type(vector) :: a, b, c, d

a = ex ; b = ey ; c = -1 * ex ; d = -1 * ey               ! the unit circle, counter-clockwise
print '(A,L1)', 'a, b, c, d in order:         ', a%is_concyclic(pt1=b, pt2=c, pt3=d)
print '(A,L1)', 'a, c, b, d out of order:     ', a%is_concyclic(pt1=c, pt2=b, pt3=d)
d = -1 * ey + 0.1_R8P * ez                                 ! lifted off the plane
print '(A,L1)', 'd lifted by 0.1:             ', is_concyclic(a, pt1=b, pt2=c, pt3=d)
d = cos(4._R8P) * ex + sin(4._R8P) * ey                    ! on the circle, up to the rounding of cos and sin
print '(A,L1)', 'a, b, c, (cos 4, sin 4):     ', a%is_concyclic(pt1=b, pt2=c, pt3=d)
print '(A,L1)', 'the same, within 1e-12:      ', a%is_concyclic(pt1=b, pt2=c, pt3=d, tolerance=1.e-12_R8P)
endprogram concyclic_points
