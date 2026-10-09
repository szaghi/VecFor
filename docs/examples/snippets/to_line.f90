program to_line
!< Cookbook: the distance of a point from a line.
use penf, only : R8P
use vecfor, only : distance_to_line, ex, ey, ez, vector
implicit none
type(vector) :: a, b, p

a = 0 * ex
b = 2 * ex                                     ! the x axis
p = 5 * ex + 3 * ey + 4 * ez
print '(A,F6.2)', 'p%distance_to_line(...) = ', p%distance_to_line(pt1=a, pt2=b)
print '(A,F6.2)', 'distance_to_line(p,...) = ', distance_to_line(p, pt1=a, pt2=b)
endprogram to_line
