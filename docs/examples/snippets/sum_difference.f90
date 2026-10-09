program sum_difference
!< Cookbook: sum, difference, negation.
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, b, v

a = ex + 2 * ey
b = 3 * ex - ez
v = a + b  ; call v%printf(prefix='a + b = ')
v = a - b  ; call v%printf(prefix='a - b = ')
v = -a     ; call v%printf(prefix='-a    = ')
v = +a     ; call v%printf(prefix='+a    = ')
endprogram sum_difference
