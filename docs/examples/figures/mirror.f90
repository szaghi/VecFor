program mirror
!< Figure: a tetrahedron and its mirror image across the plane through the origin of normal (1,1,0).
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view    ! the direction of view
type(vector)      :: o       ! the origin
type(vector)      :: p(4)    ! the vertices
type(vector)      :: s(4)    ! the vertices of the image
type(vector)      :: n       ! the normal of the mirror
type(vector)      :: w       ! a direction in the mirror
integer           :: i, j, u ! counters, data file

p = [o, ex, ey, ez] + (0.25_R8P * ex + 0.25_R8P * ey)
n = ex + ey
w = normalized(ex - ey)
s = p
do i = 1, 4
   call s(i)%mirror(normal=n)
enddo
call view%look(azimuth=-60._R8P, elevation=25._R8P)
open(newunit=u, file='mirror.plane.dat')
call view%polygon(u, [-1.2_R8P * w - 0.2_R8P * ez, 1.2_R8P * w - 0.2_R8P * ez, 1.2_R8P * w + 1.2_R8P * ez, &
                      -1.2_R8P * w + 1.2_R8P * ez])
close(u)
open(newunit=u, file='mirror.body.dat')
do i = 1, 3
   do j = i + 1, 4
      call view%segment(u, p(i), p(j))
   enddo
enddo
close(u)
open(newunit=u, file='mirror.image.dat')
do i = 1, 3
   do j = i + 1, 4
      call view%segment(u, s(i), s(j))
   enddo
enddo
close(u)
open(newunit=u, file='mirror.n.dat')
call view%arrow(u, o, normalized(n))
close(u)
open(newunit=u, file='mirror.labels.dat')
call view%label(u, p(2), 'p2') ; call view%label(u, s(2), 'p2 mirrored')
call view%label(u, normalized(n), 'normal')
close(u)
call view%frame('mirror')
endprogram mirror
