program rotate_axis
!< Cookbook: a rotation about an axis through the origin; the angle in radians, counter-clockwise about the axis.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v
real(R8P)    :: pi

pi = acos(-1._R8P)
v = ex
call v%rotate(axis=ez, angle=pi / 2)
print '(A,3F8.4)', 'ex, 90 deg about z      ', v%x, v%y, v%z
v = ex
call v%rotate(axis=-3 * ez, angle=pi / 2)                  ! the axis need not be a unit vector
print '(A,3F8.4)', 'ex, 90 deg about -z     ', v%x, v%y, v%z
v = ex + ez
call v%rotate(axis=ez, angle=pi)
print '(A,3F8.4)', 'ex + ez, 180 deg about z', v%x, v%y, v%z
endprogram rotate_axis
