!run quadrilateral quadrilateral
program quadrilateral
!< Cookbook: the normal and the area of a quadrilateral.
use vecfor, only : ex, ey, ez, face_normal4, vector
implicit none
type(vector) :: q(4), n

q = [0 * ex, 4 * ex, 4 * ex + 3 * ey, 3 * ey]          ! a 4 x 3 rectangle, counter-clockwise seen from +z
n = face_normal4(pt1=q(1), pt2=q(2), pt3=q(3), pt4=q(4))           ; call n%printf(prefix='normal      = ')
print '(A,F6.2)', 'area        = ', n%normL2()
n = face_normal4(pt1=q(1), pt2=q(2), pt3=q(3), pt4=q(4), norm='y') ; call n%printf(prefix='unit normal = ')
q(3) = q(3) + ez                                       ! one corner lifted: no longer flat
n = face_normal4(pt1=q(1), pt2=q(2), pt3=q(3), pt4=q(4), norm='y') ; call n%printf(prefix='warped      = ')
endprogram quadrilateral
