program angles
!< Cookbook: the angle between two vectors, in radians and degrees.
use penf, only : R8P
use vecfor, only : angle, ex, ey, vector
implicit none
type(vector) :: a, b
real(R8P)    :: deg

deg = 180._R8P / acos(-1._R8P)
a = ex
b = ex + ey
print '(A,F8.4)', 'a%angle(b)         [rad] ', a%angle(b)
print '(A,F8.4)', 'angle(a, b)        [deg] ', angle(a, b) * deg
print '(A,F8.4)', 'a and 3a           [deg] ', angle(a, 3 * a) * deg
print '(A,F8.4)', 'a and -a           [deg] ', angle(a, -a) * deg
print '(A,F8.4)', 'a and ey           [deg] ', angle(a, ey) * deg
endprogram angles
