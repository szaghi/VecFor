!run accurate_products accurate_products
program accurate_products
!< Cookbook: cross and dot products whose terms nearly cancel, with the operators and with the accurate functions.
use penf, only : R8P
use vecfor, only : crossproduct_accurate, dotproduct_accurate, ex, ey, ez, vector
implicit none
type(vector) :: a, b, c
real(R8P)    :: k

k = 2._R8P**27                                        ! (k + 1)**2 needs 55 bits: it is rounded
a = (k + 1) * ex + k * ey                             ! a and b nearly parallel
b = k * ex + (k + 1) * ey
print '(A,F12.1)', 'z of a x b, exact     ', 2 * k + 1
c = a .cross. b                ; print '(A,F12.1)', 'z of a .cross. b      ', c%z
c = crossproduct_accurate(a, b) ; print '(A,F12.1)', 'crossproduct_accurate ', c%z
a = (k + 1) * ex + k * ey + ez
b = (k + 1) * ex - k * ey + ez
print '(A,F12.1)', 'a . b, exact          ', 2 * k + 2
print '(A,F12.1)', 'a .dot. b             ', a .dot. b
print '(A,F12.1)', 'dotproduct_accurate   ', dotproduct_accurate(a, b)
endprogram accurate_products
