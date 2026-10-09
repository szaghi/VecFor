!as probe
!run probe_6 probe
program probe
!< Tutorial, chapter 6: a velocity at the slanted face, its normal and tangential components, a slip wall.
use penf, only : R8P
use vecfor, only : ex, ey, ez, face_normal3, vector
implicit none
type(vector) :: p(4)     ! the vertices
type(vector) :: n        ! the outward normal of the slanted face
type(vector) :: v        ! the velocity of a particle hitting the face
type(vector) :: vn       ! its normal component
type(vector) :: vt       ! its tangential component
type(vector) :: r        ! its velocity after the bounce

p(2) = ex ; p(3) = ey ; p(4) = ez
n = face_normal3(pt1=p(2), pt2=p(3), pt3=p(4))   ! not a unit vector: only its direction matters
v = -2 * ex - ey + 0.5_R8P * ez
!region split
vn = v .paral. n
vt = v .ortho. n
call vn%printf(prefix='normal component     = ')
call vt%printf(prefix='tangential component = ')
print '(A,ES9.1)', 'vn . vt                ', vn .dot. vt
!endregion split
!region bounce
r = vt - vn                                     ! a slip wall: the normal component reverses
print '(A,3F8.4)', 'v before the bounce    ', v%x, v%y, v%z
print '(A,3F8.4)', 'v after the bounce     ', r%x, r%y, r%z
print '(A,2F8.4)', 'speed before and after ', v%normL2(), r%normL2()
print '(A,2F8.4)', 'v . n before and after ', v .dot. n, r .dot. n
!endregion bounce
endprogram probe
