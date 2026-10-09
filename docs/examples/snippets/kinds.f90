program kinds
!< Cookbook: vectors of each precision, their versors and their free functions.
use penf, only : R4P, R8P
use vecfor, only : angle_R4P, ex_R4P, ey_R4P, ex_R8P, normL2_R8P, vector, vector_R4P, vector_R8P, vector_R16P
implicit none
type(vector_R4P)  :: a      ! real(R4P) components
type(vector_R8P)  :: b      ! real(R8P) components
type(vector_R16P) :: c      ! real(R16P) components
type(vector)      :: d      ! the default: real(R8P) components, but not the type vector_R8P

a = ex_R4P + ey_R4P
b = 3 * ex_R8P
print '(A,ES14.7)', 'angle_R4P(a, ex_R4P) = ', angle_R4P(a, ex_R4P)
print '(A,ES14.7)', 'normL2_R8P(b)        = ', normL2_R8P(b)
print '(A,3I4)', 'kinds of a, b, c:      ', kind(a%x), kind(b%x), kind(c%x)
d%x = b%x ; d%y = b%y ; d%z = b%z             ! d = b does not compile: two different types
call d%printf(prefix='d = ')
endprogram kinds
