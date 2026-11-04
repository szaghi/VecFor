!run unit_vector_checked unit_vector_checked
program unit_vector_checked
!< Cookbook: a unit vector only where the vector has a direction; the degenerate case reported.
use penf, only : R8P
use vecfor, only : ex, ey, normalized, normalized_checked, vector
implicit none
type(vector) :: a, u
logical      :: ok

a = 3 * ex + 4 * ey
call normalized_checked(a, u, ok)
print '(A,L1)', 'ok = ', ok ; call u%printf(prefix='u  = ')
a = 1.e-9_R8P * ex                                     ! too short to trust its direction
call normalized_checked(a, u, ok, min_norm=1.e-6_R8P)
print '(A,L1)', 'ok = ', ok ; call u%printf(prefix='u  = ')
u = normalized(a) ; call u%printf(prefix='normalized(a) = ')
endprogram unit_vector_checked
