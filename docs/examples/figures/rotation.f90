program rotation
!< Figure: ex rotated about the diagonal (1,1,1), a twelfth of a turn at a time: ey after a third of a turn, ez after two.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view ! the direction of view
type(vector)      :: o    ! the origin
type(vector)      :: v    ! the rotated vector
type(vector)      :: axis ! the axis of rotation
integer           :: i, u ! counter, data file

axis = ex + ey + ez
call view%look(azimuth=-35._R8P, elevation=20._R8P)
call view%axes('rotation', 1.3_R8P)
open(newunit=u, file='rotation.axis.dat')
call view%arrow(u, o, 1.1_R8P * axis)
close(u)
open(newunit=u, file='rotation.path.dat')
v = ex
do i = 0, 120
   call view%point(u, v)
   call v%rotate(axis=axis, angle=acos(-1._R8P) / 60)
enddo
close(u)
open(newunit=u, file='rotation.steps.dat')
v = ex
do i = 1, 12
   call view%arrow(u, o, v)
   call v%rotate(axis=axis, angle=acos(-1._R8P) / 6)
enddo
close(u)
open(newunit=u, file='rotation.labels.dat')
call view%label(u, 1.1_R8P * axis, 'axis')
close(u)
call view%frame('rotation')
endprogram rotation
