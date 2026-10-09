program to_plane
!< Cookbook: the signed distance of a point from a plane, and the vector from the plane to the point.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, b, c, p, q, d

a = ez ; b = ex + ez ; c = ey + ez                       ! the plane z = 1, normal +z
p = 2 * ex + 3 * ey + 4 * ez
print '(A,F6.2)', 'above:            ', p%distance_to_plane(pt1=a, pt2=b, pt3=c)
q = 2 * ex - 3 * ez
print '(A,F6.2)', 'below:            ', q%distance_to_plane(pt1=a, pt2=b, pt3=c)
print '(A,F6.2)', 'points swapped:   ', p%distance_to_plane(pt1=a, pt2=c, pt3=b)
d = p%distance_vectorial_to_plane(pt1=a, pt2=b, pt3=c) ; call d%printf(prefix='vectorial:        ')
d = p%projection_onto_plane(pt1=a, pt2=b, pt3=c)       ; call d%printf(prefix='projection:       ')
endprogram to_plane
