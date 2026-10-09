program componentwise
!< Cookbook: the product and the quotient of two vectors, component by component.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, s, v

a = 2 * ex + 3 * ey + 4 * ez
s = 2 * ex + ey + ez                ! a scale factor for each axis
v = a * s ; call v%printf(prefix='a * s = ')
v = a / s ; call v%printf(prefix='a / s = ')
endprogram componentwise
