program rotate_matrix
!< Cookbook: a rotation matrix, computed once and applied many times; two rotations composed.
use penf, only : R8P
use vecfor, only : ex, ey, ez, rotation_matrix, vector
implicit none
type(vector) :: v(3), w
real(R8P)    :: r(3,3), rz(3,3), rx(3,3), pi
integer      :: i

pi = acos(-1._R8P)
r = rotation_matrix(axis=ex + ey + ez, angle=2 * pi / 3)
v = [ex, ey, ez]
do i = 1, 3
   w = r .matrix. v(i)                                    ! a new vector
   print '(A,I0,A,3F8.4)', 'v', i, ' rotated  ', w%x, w%y, w%z
   call v(i)%rotate(matrix=r)                             ! in place: the same
enddo
print '(A,3F8.4)', 'v1 in place ', v(1)%x, v(1)%y, v(1)%z
rz = rotation_matrix(axis=ez, angle=pi / 2)
rx = rotation_matrix(axis=ex, angle=pi / 2)
w = matmul(rx, rz) .matrix. ex                            ! first about z, then about x
print '(A,3F8.4)', 'ex, z then x', w%x, w%y, w%z
endprogram rotate_matrix
