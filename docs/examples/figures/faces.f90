program faces
!< Figure: the normals of a triangle and of a quadrilateral, as long as the face is large and of unit length.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view ! the direction of view
type(vector)      :: q(4) ! the quadrilateral, counter-clockwise seen from above
type(vector)      :: t(3) ! the triangle, counter-clockwise seen from above
type(vector)      :: c    ! a centroid
integer           :: u    ! data file

q = [0 * ex, 1.4_R8P * ex + 0.3_R8P * ez, 1.4_R8P * ex + ey + 0.3_R8P * ez, ey]
t = [1.8_R8P * ey, 1.2_R8P * ex + 1.8_R8P * ey + 0.2_R8P * ez, 2.8_R8P * ey]
call view%look(azimuth=-60._R8P, elevation=30._R8P)
open(newunit=u, file='faces.faces.dat')
call view%polygon(u, q)
call view%polygon(u, t)
close(u)
open(newunit=u, file='faces.area.dat')
c = (q(1) + q(2) + q(3) + q(4)) / 4
call view%arrow(u, c, c + face_normal4(pt1=q(1), pt2=q(2), pt3=q(3), pt4=q(4)))
c = (t(1) + t(2) + t(3)) / 3
call view%arrow(u, c, c + face_normal3(pt1=t(1), pt2=t(2), pt3=t(3)))
close(u)
open(newunit=u, file='faces.unit.dat')
c = (q(1) + q(2) + q(3) + q(4)) / 4
call view%arrow(u, c, c + face_normal4(pt1=q(1), pt2=q(2), pt3=q(3), pt4=q(4), norm='y'))
c = (t(1) + t(2) + t(3)) / 3
call view%arrow(u, c, c + face_normal3(pt1=t(1), pt2=t(2), pt3=t(3), norm='y'))
close(u)
open(newunit=u, file='faces.labels.dat')
call view%label(u, q(1), 'pt1') ; call view%label(u, q(2), 'pt2')
call view%label(u, q(3), 'pt3') ; call view%label(u, q(4), 'pt4')
call view%label(u, t(1), 'pt1') ; call view%label(u, t(2), 'pt2') ; call view%label(u, t(3), 'pt3')
close(u)
call view%frame('faces')
endprogram faces
