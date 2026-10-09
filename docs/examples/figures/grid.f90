program grid
!< Figure: the points of a grid inside the tetrahedron, found by their signed distances to the four faces.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
integer, parameter :: n = 14          ! grid points per direction
type(view_object)  :: view            ! the direction of view
type(vector)       :: o               ! the origin
type(vector)       :: p(4)            ! the vertices
integer            :: face(3,4)       ! the vertices of each face, counter-clockwise seen from outside
type(vector)       :: g               ! a grid point
logical            :: inside          ! is g inside?
integer            :: i, j, k, f, u   ! counters, data file

p = [o, ex, ey, ez]
face = reshape([1,3,2, 1,2,4, 1,4,3, 2,3,4], [3,4])
call view%look(azimuth=25._R8P, elevation=22._R8P)
call view%axes('grid', 1.35_R8P)
open(newunit=u, file='grid.edges.dat')
do i = 1, 3
   do j = i + 1, 4
      call view%segment(u, p(i), p(j))
   enddo
enddo
close(u)
open(newunit=u, file='grid.points.dat')
do k = 1, n
   do j = 1, n
      do i = 1, n
         g = ((i - 0.5_R8P) * ex + (j - 0.5_R8P) * ey + (k - 0.5_R8P) * ez) / n
         inside = .true.
         do f = 1, 4
            inside = inside .and. g%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f))) <= 0._R8P
         enddo
         if (inside) call view%point(u, g)
      enddo
   enddo
enddo
close(u)
call view%frame('grid')
endprogram grid
