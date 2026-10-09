!run lengths lengths
program lengths
!< Cookbook: the length and the squared length of a vector.
use vecfor, only : ex, ey, ez, normL2, sq_norm, vector
implicit none
type(vector) :: a

a = 2 * ex + 3 * ey + 6 * ez
print '(A,F6.2)', 'a%normL2()  = ', a%normL2()
print '(A,F6.2)', 'normL2(a)   = ', normL2(a)
print '(A,F6.2)', 'a%sq_norm() = ', a%sq_norm()
print '(A,F6.2)', 'sq_norm(a)  = ', sq_norm(a)
endprogram lengths
