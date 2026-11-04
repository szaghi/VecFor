!run point_location point_location
program point_location
!< Cookbook: is a point inside a tetrahedron; interpolation in a triangle by barycentric coordinates.
use penf, only : R8P
use vecfor, only : barycentric_tetrahedron, barycentric_triangle, ex, ey, ez, vector
implicit none
type(vector) :: o, p
real(R8P)    :: l4(4), l3(3), f(3)

p = 0.2_R8P * ex + 0.3_R8P * ey + 0.1_R8P * ez
l4 = barycentric_tetrahedron(p, o, ex, ey, ez)
print '(A,4F7.3,A,L1)', 'p:', l4, '  inside: ', all(l4 >= 0)
p = 0.5_R8P * (ex + ey + ez)
l4 = barycentric_tetrahedron(p, o, ex, ey, ez)
print '(A,4F7.3,A,L1)', 'q:', l4, '  inside: ', all(l4 >= 0)
f = [1._R8P, 2._R8P, 4._R8P]                          ! a field at the vertices o, ex, ey
p = 0.25_R8P * ex + 0.5_R8P * ey
l3 = barycentric_triangle(p, o, ex, ey)
print '(A,3F7.3,A,F7.3)', 'r:', l3, '  f(r) = ', sum(l3 * f)
endprogram point_location
