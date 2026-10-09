program paral_ortho
!< Cookbook: the components of a vector parallel and orthogonal to another one.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, d, z, v

a = 2 * ex + 3 * ey + ez
d = 5 * ex                         ! only the direction of d matters
v = a .paral. d ; call v%printf(prefix='a .paral. d = ')
v = a .ortho. d ; call v%printf(prefix='a .ortho. d = ')
v = (a .paral. d) + (a .ortho. d) ; call v%printf(prefix='their sum   = ')
v = a .paral. z ; call v%printf(prefix='a .paral. 0 = ')
endprogram paral_ortho
