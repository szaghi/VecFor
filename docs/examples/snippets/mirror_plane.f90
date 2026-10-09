program mirror_plane
!< Cookbook: the mirror image of a point across a plane, through the origin or not.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: p, n, o, m

p = 3 * ex + ey + 2 * ez
n = ex + ey                                    ! the plane x + y = 0
m = p
call m%mirror(normal=n)
print '(A,3F8.4)', 'across x + y = 0  ', m%x, m%y, m%z
o = 2 * ez                                     ! a point of the plane z = 2
m = p - o
call m%mirror(normal=ez)
m = m + o
print '(A,3F8.4)', 'across z = 2      ', m%x, m%y, m%z
endprogram mirror_plane
