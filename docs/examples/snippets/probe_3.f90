program probe
!< Tutorial, chapter 3: lengths, directions and angles of the edges.
use penf, only : R8P
use vecfor, only : angle, ex, ey, ez, normL2, vector
implicit none
type(vector) :: o           ! the origin
type(vector) :: p(4)        ! the vertices
type(vector) :: a, b        ! two edges from p2
type(vector) :: u           ! a unit vector
type(vector) :: n           ! a normal
real(R8P)    :: deg         ! degrees per radian

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
deg = 180._R8P / acos(-1._R8P)
a = p(3) - p(2)
b = p(4) - p(2)
print '(A,F8.4)', 'length of p2->p3      ', a%normL2()
print '(A,F8.4)', 'squared length        ', a%sq_norm()
print '(A,F8.4)', 'length, free function ', normL2(b)
u = a%normalized()                    ! a unit vector along a; a is unchanged
call u%printf(prefix='direction of p2->p3 = ')
print '(A,F8.4)', 'its length            ', u%normL2()
call a%normalize                      ! a itself becomes a unit vector
call a%printf(prefix='a, normalized       = ')
a = p(3) - p(2)
print '(A,F8.4)', 'a . b                 ', a .dot. b
print '(A,F8.4)', 'p1->p2 . p1->p3       ', (p(2) - p(1)) .dot. (p(3) - p(1))
print '(A,F8.4)', 'angle at p2 [deg]     ', a%angle(b) * deg
print '(A,F8.4)', 'angle at p1 [deg]     ', angle(p(2) - p(1), p(3) - p(1)) * deg
n = a .cross. b                       ! orthogonal to a and b, as long as the area of their parallelogram
call n%printf(prefix='a x b = ')
print '(A,F8.4)', 'area of p2 p3 p4      ', 0.5_R8P * n%normL2()
endprogram probe
