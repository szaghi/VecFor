program line
!< Figure: the distance of a point from the line through two points.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view   ! the direction of view
type(vector)      :: p2, p3 ! the points of the line
type(vector)      :: q      ! a point
type(vector)      :: f      ! the foot of q on the line
type(vector)      :: m      ! a point of the line
integer           :: u      ! data file

p2 = ex
p3 = ey
q = 0.8_R8P * ex + 0.6_R8P * ey + 0.8_R8P * ez
f = p2 + ((q - p2) .paral. (p3 - p2))
m = 0.3_R8P * p2 + 0.7_R8P * p3
call view%look(azimuth=20._R8P, elevation=25._R8P)
call view%axes('line', 1.3_R8P)
open(newunit=u, file='line.line.dat')
call view%segment(u, p2 - 0.4_R8P * (p3 - p2), p3 + 0.4_R8P * (p3 - p2))
close(u)
open(newunit=u, file='line.distance.dat')
call view%segment(u, q, f)
close(u)
open(newunit=u, file='line.points.dat')
call view%point(u, p2) ; call view%point(u, p3) ; call view%point(u, m)
close(u)
open(newunit=u, file='line.probe.dat')
call view%point(u, q)
close(u)
open(newunit=u, file='line.labels.dat')
call view%label(u, p2, 'pt1') ; call view%label(u, p3, 'pt2') ; call view%label(u, m, 'collinear')
close(u)
open(newunit=u, file='line.probelabels.dat')
call view%label(u, q, 'self') ; call view%label(u, (q + f) / 2, 'distance_to_line')
close(u)
call view%frame('line')
endprogram line
