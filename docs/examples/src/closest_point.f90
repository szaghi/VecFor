!run closest_point closest_point
program closest_point
!< Cookbook: the point of a triangle closest to a point, and the feature of the triangle it lies on.
use penf, only : R8P
use vecfor, only : closest_point_triangle, ex, ey, ez, normL2, vector
implicit none
type(vector) :: o, p(3), q
integer      :: feature, i

p(1) = 0.2_R8P * ex + 0.2_R8P * ey + ez               ! above the face
p(2) = ex + ey + ez                                   ! beyond the edge from ex to ey
p(3) = -ex - ey                                       ! beyond the vertex o
do i = 1, 3
   call closest_point_triangle(p(i), o, ex, ey, q, feature)
   print '(A,I1,A,3F6.2,A,F7.4)', 'feature ', feature, ', q =', q%x, q%y, q%z, ', distance ', normL2(p(i) - q)
enddo
endprogram closest_point
