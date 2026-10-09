program arrays
!< Cookbook: whole arrays of vectors at once.
use penf, only : R8P
use vecfor, only : ex, ey, ez, normL2, vector
implicit none
type(vector) :: p(5), c
integer      :: i

do i = 1, 5
   p(i) = i * ex + (6 - i) * ey               ! five points on a line
enddo
print '(A,5F6.2)', 'x of the points   ', p%x                       ! a component of every vector
print '(A,5F6.2)', 'their lengths     ', normL2(p)                 ! elemental functions: one result each
print '(A,5F6.2)', 'distances from ez ', p%distance_to_line(pt1=0 * ex, pt2=ez)
p = p + ez                                                          ! elemental operators
print '(A,5F6.2)', 'z after + ez      ', p%z
print '(A,I0)',    'longer than 5     ', count(p > 5)
c = sum(p%x) * ex + sum(p%y) * ey + sum(p%z) * ez                   ! no sum(p): sum the components
call c%printf(prefix='their sum         ')
endprogram arrays
