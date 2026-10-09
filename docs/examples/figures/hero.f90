program hero
!< Figure: the tetrahedron of the tutorial, its outward normals, a probe point and its projection onto the slanted face.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view                         ! the direction of view
type(vector)      :: p(4)                         ! vertices
integer           :: face(3,4)                    ! vertices of each face, ordered so that the normal points outward
type(vector)      :: c                            ! face centroid
type(vector)      :: q                            ! probe point
type(vector)      :: f                            ! foot of the probe on the slanted face
integer           :: i, j, u                      ! counters, data file

p = [0*ex, ex, ey, ez]
face = reshape([1,3,2, 1,2,4, 1,4,3, 2,3,4], [3,4])
q = 0.8_R8P * ex + 0.6_R8P * ey + 0.8_R8P * ez
f = q%projection_onto_plane(pt1=p(2), pt2=p(3), pt3=p(4))
call view%look(azimuth=-20._R8P, elevation=20._R8P)

call view%axes('hero', 1.45_R8P)
open(newunit=u, file='hero.faces.dat')
do j = 1, 4
   call view%polygon(u, p(face(:,j)))
enddo
close(u)
open(newunit=u, file='hero.edges.dat')
do i = 1, 3
   do j = i + 1, 4
      call view%segment(u, p(i), p(j))
   enddo
enddo
close(u)
open(newunit=u, file='hero.normals.dat')
do j = 1, 4
   c = (p(face(1,j)) + p(face(2,j)) + p(face(3,j))) / 3
   call view%arrow(u, c, c + 0.45_R8P * face_normal3(pt1=p(face(1,j)), pt2=p(face(2,j)), pt3=p(face(3,j)), norm='y'))
enddo
close(u)
open(newunit=u, file='hero.vertices.dat')
do i = 1, 4
   call view%label(u, p(i), 'p'//achar(48 + i))
enddo
close(u)
open(newunit=u, file='hero.probe.dat')
call view%point(u, q)
call view%point(u, f)
close(u)
open(newunit=u, file='hero.probelabels.dat')
call view%label(u, q, 'q')
call view%label(u, f, 'foot')
close(u)
open(newunit=u, file='hero.distance.dat')
call view%segment(u, q, f)
close(u)
call view%frame('hero')
endprogram hero
