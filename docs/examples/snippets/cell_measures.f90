program cell_measures
!< Cookbook: the area of a triangle, the signed volume of a tetrahedron, the vector area of a polygon.
use vecfor, only : ex, ey, ez, polygon_vector_area, tetrahedron_volume, triangle_area, vector
implicit none
type(vector) :: o, l(6), t(4), s
integer      :: face(3,4), f

print '(A,F7.4)', 'area of o, ex, ey          ', triangle_area(o, ex, ey)
print '(A,F7.4)', 'volume of o, ex, ey, ez    ', tetrahedron_volume(o, ex, ey, ez)
print '(A,F7.4)', 'volume of o, ey, ex, ez    ', tetrahedron_volume(o, ey, ex, ez)
l = [o, 2 * ex, 2 * ex + ey, ex + ey, ex + 2 * ey, 2 * ey]        ! an L-shaped hexagon on z = 0, area 3
s = polygon_vector_area(l) ; call s%printf(prefix='vector area of the L       = ')
t = [o, ex, ey, ez]
face = reshape([1, 3, 2,  1, 2, 4,  1, 4, 3,  2, 3, 4], [3, 4])  ! counter-clockwise seen from outside
s = 0
do f = 1, 4
   s = s + polygon_vector_area(t(face(:,f)))
enddo
call s%printf(prefix='sum over a closed surface  = ')
endprogram cell_measures
