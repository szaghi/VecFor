!as probe
!run probe_5 probe
program probe
!< Tutorial, chapter 5: a point and the tetrahedron, distances, projections, collinear and concyclic points.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: o          ! the origin
type(vector) :: p(4)       ! the vertices
integer      :: face(3,4)  ! the vertices of each face, counter-clockwise seen from outside
type(vector) :: q          ! the probe
type(vector) :: c          ! the centroid
type(vector) :: foot       ! the projection of the probe onto the slanted face
type(vector) :: d          ! a vectorial distance
type(vector) :: m          ! a point on an edge
type(vector) :: a          ! a point on the circle through the slanted face
real(R8P)    :: dist(4)    ! signed distances to the faces
integer      :: f          ! counter

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
face = reshape([1,3,2, 1,2,4, 1,4,3, 2,3,4], [3,4])
q = 0.8_R8P * ex + 0.6_R8P * ey + 0.8_R8P * ez
c = (p(1) + p(2) + p(3) + p(4)) / 4
!region planes
do f = 1, 4
   dist(f) = q%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))
enddo
print '(A,4F8.4)', 'q to the faces       ', dist
print '(A,L1)',    'q is inside:         ', all(dist <= 0._R8P)
do f = 1, 4
   dist(f) = c%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))
enddo
print '(A,4F8.4)', 'centroid to the faces', dist
print '(A,L1)',    'centroid is inside:  ', all(dist <= 0._R8P)
!endregion planes
!region foot
d = q%distance_vectorial_to_plane(pt1=p(2), pt2=p(3), pt3=p(4))
foot = q%projection_onto_plane(pt1=p(2), pt2=p(3), pt3=p(4))
print '(A,3F8.4)', 'from the face to q   ', d%x, d%y, d%z
print '(A,3F8.4)', 'foot of q            ', foot%x, foot%y, foot%z
print '(A,3F8.4)', 'foot + distance      ', foot%x + d%x, foot%y + d%y, foot%z + d%z
!endregion foot
!region line
print '(A,F8.4)', 'q to the line p2 p3  ', q%distance_to_line(pt1=p(2), pt2=p(3))
print '(A,F8.4)', 'q to the line p1 p4  ', q%distance_to_line(pt1=p(1), pt2=p(4))
!endregion line
!region collinear
m = (p(2) + p(3)) / 2                          ! the midpoint: exact in floating point
print '(A,L1)',    'midpoint on the line p2 p3:   ', m%is_collinear(pt1=p(2), pt2=p(3))
m = 0.3_R8P * p(2) + 0.7_R8P * p(3)            ! 0.3 and 0.7 are not exact in binary
print '(A,ES8.1)', 'distance of m from the line:  ', m%distance_to_line(pt1=p(2), pt2=p(3))
print '(A,L1)',    'm on the line p2 p3:          ', m%is_collinear(pt1=p(2), pt2=p(3))
print '(A,L1)',    'with a tolerance of 1e-12:    ', m%is_collinear(pt1=p(2), pt2=p(3), tolerance=1.e-12_R8P)
m = m + 1.e-9_R8P * ez
print '(A,L1)',    '1e-9 off, tolerance of 1e-12: ', m%is_collinear(pt1=p(2), pt2=p(3), tolerance=1.e-12_R8P)
!endregion collinear
!region concyclic
a = 2 * (p(2) + p(3) + p(4)) / 3 - p(2)        ! opposite to p2, on the circle through p2, p3, p4
print '(A,L1)', 'a, p4, p2, p3 on a circle: ', a%is_concyclic(pt1=p(4), pt2=p(2), pt3=p(3))
print '(A,L1)', 'a, p2, p4, p3 on a circle: ', a%is_concyclic(pt1=p(2), pt2=p(4), pt3=p(3))
!endregion concyclic
endprogram probe
