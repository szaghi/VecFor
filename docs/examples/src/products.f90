!run products products
program products
!< Cookbook: dot product, cross product, triple product.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, b, c, v

a = ex + 2 * ey
b = 3 * ex + ey
c = ez
print '(A,F6.2)', 'a . b         = ', a .dot. b
v = a .cross. b ; call v%printf(prefix='a x b         = ')
v = b .cross. a ; call v%printf(prefix='b x a         = ')
v = a .cross. a ; call v%printf(prefix='a x a         = ')
print '(A,F6.2)', 'a . (b x c)   = ', a .dot. (b .cross. c)
endprogram products
