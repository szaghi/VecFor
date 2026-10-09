program components
!< Figure: a velocity hitting the slanted face, its normal and tangential components, the velocity after the bounce.
use penf, only : R8P
use sketch, only : view_object
use vecfor
implicit none
type(view_object) :: view       ! the direction of view
type(vector)      :: o          ! the origin
type(vector)      :: p(4)       ! the vertices
type(vector)      :: n          ! the unit normal of the slanted face
type(vector)      :: c          ! where the particle hits the face
type(vector)      :: v, vn, vt  ! the velocity and its components, scaled by 0.4
integer           :: u          ! data file

p = [o, ex, ey, ez]
n = face_normal3(pt1=p(2), pt2=p(3), pt3=p(4), norm='y')
c = (p(2) + p(3) + p(4)) / 3
v = 0.4_R8P * (-2 * ex - ey + 0.5_R8P * ez)
vn = v .paral. n
vt = v .ortho. n
call view%look_from(n .cross. v)            ! the face edge-on, n and v in the plane of the page
open(newunit=u, file='components.face.dat')
call view%polygon(u, p(2:4))
close(u)
open(newunit=u, file='components.n.dat')
call view%arrow(u, c, c + 0.5_R8P * n)
close(u)
open(newunit=u, file='components.v.dat')
call view%arrow(u, c - v, c)
close(u)
open(newunit=u, file='components.split.dat')
call view%arrow(u, c, c + vt)
call view%arrow(u, c, c + vn)
close(u)
open(newunit=u, file='components.r.dat')
call view%arrow(u, c, c + vt - vn)
close(u)
open(newunit=u, file='components.labels.dat')
call view%label(u, c - v, 'v')
call view%label(u, c + vt, 'v .ortho. n')
call view%label(u, c + vn, 'v .paral. n')
call view%label(u, c + vt - vn, 'vt - vn')
call view%label(u, c + 0.5_R8P * n, 'n')
close(u)
call view%frame('components')
endprogram components
