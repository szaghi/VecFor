program concyclic
!< Figure: the circle through the vertices of the slanted face, and the point opposite to p2 on it.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view    ! the direction of view
type(vector)      :: o       ! the origin
type(vector)      :: p(4)    ! the vertices
type(vector)      :: c       ! the centre of the circle
type(vector)      :: r       ! from the centre to a point of the circle
type(vector)      :: a       ! the point opposite to p2
integer           :: i, u    ! counter, data file

p = [o, ex, ey, ez]
c = (p(2) + p(3) + p(4)) / 3
a = 2 * c - p(2)
call view%look(azimuth=40._R8P, elevation=30._R8P)
call view%axes('concyclic', 1.3_R8P)
open(newunit=u, file='concyclic.face.dat')
call view%polygon(u, p(2:4))
close(u)
open(newunit=u, file='concyclic.circle.dat')
r = p(2) - c
do i = 0, 120
   call view%point(u, c + r)
   call r%rotate(axis=ex + ey + ez, angle=acos(-1._R8P) / 60)
enddo
close(u)
open(newunit=u, file='concyclic.points.dat')
call view%point(u, p(2)) ; call view%point(u, p(3)) ; call view%point(u, p(4))
close(u)
open(newunit=u, file='concyclic.a.dat')
call view%point(u, a)
close(u)
open(newunit=u, file='concyclic.labels.dat')
call view%label(u, p(2), 'p2') ; call view%label(u, p(3), 'p3') ; call view%label(u, p(4), 'p4')
close(u)
open(newunit=u, file='concyclic.alabel.dat')
call view%label(u, a, 'a')
close(u)
call view%frame('concyclic')
endprogram concyclic
