program cross
!< Figure: two vectors, the parallelogram they span and their cross product.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view ! the direction of view
type(vector)      :: o    ! the origin
type(vector)      :: a, b ! two vectors
integer           :: u    ! data file

a = 1.2_R8P * ex + 0.2_R8P * ey
b = 0.3_R8P * ex + 1.0_R8P * ey
call view%look(azimuth=-35._R8P, elevation=25._R8P)
call view%axes('cross', 1.4_R8P)
open(newunit=u, file='cross.area.dat')
call view%polygon(u, [o, a, a + b, b])
close(u)
open(newunit=u, file='cross.ab.dat')
call view%arrow(u, o, a)
call view%arrow(u, o, b)
close(u)
open(newunit=u, file='cross.axb.dat')
call view%arrow(u, o, a .cross. b)
close(u)
open(newunit=u, file='cross.labels.dat')
call view%label(u, a, 'a')
call view%label(u, b, 'b')
call view%label(u, a .cross. b, 'a .cross. b')
close(u)
call view%frame('cross')
endprogram cross
