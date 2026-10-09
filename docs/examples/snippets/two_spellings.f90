program two_spellings
!< Cookbook: a method of the vector, or a free function: the same result.
use penf, only : R8P
use vecfor, only : angle, distance_to_line, ex, ey, ez, face_normal3, is_collinear, normL2, normalized, sq_norm, vector
implicit none
type(vector) :: v, u, w

v = 3 * ex + 4 * ey
print '(A,2F8.4)', 'normL2:           ', v%normL2(), normL2(v)
print '(A,2F8.4)', 'sq_norm:          ', v%sq_norm(), sq_norm(v)
print '(A,2F8.4)', 'angle:            ', v%angle(ex), angle(v, ex)
print '(A,2F8.4)', 'distance_to_line: ', ez%distance_to_line(pt1=ex, pt2=ey), distance_to_line(ez, pt1=ex, pt2=ey)
print '(A,2L2)',   'is_collinear:     ', v%is_collinear(pt1=ex, pt2=ey), is_collinear(v, pt1=ex, pt2=ey)
u = v%normalized() ; w = normalized(v)
print '(A,L2)',    'normalized:       ', u == w
u = v%face_normal3(pt1=ex, pt2=ey, pt3=ez) ; w = face_normal3(pt1=ex, pt2=ey, pt3=ez)
print '(A,L2)',    'face_normal3:     ', u == w
endprogram two_spellings
