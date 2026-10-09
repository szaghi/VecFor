program quickstart
!< Quick start: a triangle in space, its normal and area, a point above it, its distance and its foot.
use penf, only : R8P
use vecfor, only : angle, ex, ey, ez, face_normal3, vector
implicit none
type(vector) :: a, b, c ! the corners of a triangle
type(vector) :: n       ! its normal
type(vector) :: q       ! a point
type(vector) :: foot    ! its projection onto the plane of the triangle

a = ex
b = ey
c = ez
n = face_normal3(pt1=a, pt2=b, pt3=c)                 ! as long as the triangle is large
call n%printf(prefix='normal   = ')
print '(A,F7.4)', 'area     = ', n%normL2()
print '(A,F7.4)', 'angle    = ', angle(b - a, c - a) * 180 / acos(-1._R8P)
q = 0.8_R8P * ex + 0.6_R8P * ey + 0.8_R8P * ez
print '(A,F7.4)', 'distance = ', q%distance_to_plane(pt1=a, pt2=b, pt3=c)
foot = q%projection_onto_plane(pt1=a, pt2=b, pt3=c)
print '(A,3F7.4)', 'foot     = ', foot%x, foot%y, foot%z
endprogram quickstart
