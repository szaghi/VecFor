!run reflect reflect
program reflect
!< Cookbook: a velocity reflected by a wall, by components or by a mirror.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v, n, r1, r2

v = 2 * ex - 3 * ey + ez
n = ey                                   ! the normal of the wall, any length
r1 = v - 2 * (v .paral. n)
r2 = v
call r2%mirror(normal=n)
call r1%printf(prefix='v - 2 (v .paral. n) = ')
call r2%printf(prefix='v mirrored          = ')
endprogram reflect
