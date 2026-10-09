program compare
!< Cookbook: comparing two vectors; by length, and == also by direction.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, b, c

a = 3 * ex
b = 3 * ey                               ! as long as a, another direction
c = 2 * ex + 2 * ey + 2 * ez             ! longer
print '(A,L1)', 'a == b  ', a == b
print '(A,L1)', 'a /= b  ', a /= b
print '(A,L1)', 'a <= b  ', a <= b
print '(A,L1)', 'a >= b  ', a >= b
print '(A,L1)', 'a <  c  ', a < c
print '(A,L1)', 'c >  b  ', c > b
print '(A,L1)', 'a == 3 ex ', a == 3 * ex
endprogram compare
