program triangle
!< Cookbook: the normal and the area of a triangle.
use vecfor, only : ex, ey, ez, face_normal3, vector
implicit none
type(vector) :: a, b, c, n

a = 0 * ex ; b = 4 * ex ; c = 3 * ey                         ! counter-clockwise seen from +z
n = face_normal3(pt1=a, pt2=b, pt3=c)          ; call n%printf(prefix='normal        = ')
print '(A,F6.2)', 'area          = ', n%normL2()
n = face_normal3(pt1=a, pt2=b, pt3=c, norm='y') ; call n%printf(prefix='unit normal   = ')
n = face_normal3(pt1=a, pt2=c, pt3=b, norm='y') ; call n%printf(prefix='b and c swapped = ')
n = n%face_normal3(pt1=a, pt2=b, pt3=c)          ; call n%printf(prefix='type-bound    = ')
endprogram triangle
