program mirror_matrix_reuse
!< Cookbook: a mirror matrix, computed once and applied many times.
use penf, only : R8P
use vecfor, only : ex, ey, ez, mirror_matrix, vector
implicit none
type(vector) :: v(2)
real(R8P)    :: m(3,3)
integer      :: i

m = mirror_matrix(normal=ex + ey + ez)
print '(A,3F8.4)', 'M  ', m(1,:)
print '(A,3F8.4)', '   ', m(2,:)
print '(A,3F8.4)', '   ', m(3,:)
v = [ex + ey + ez, ex - ey]
do i = 1, 2
   call v(i)%mirror(matrix=m)
   print '(A,I0,A,3F8.4)', 'v', i, ' mirrored ', v(i)%x, v(i)%y, v(i)%z
enddo
endprogram mirror_matrix_reuse
