program plus_number
!< Cookbook: a number added to or subtracted from every component.
use penf, only : R8P
use vecfor, only : ex, ey, vector
implicit none
type(vector) :: a, v

a = ex + 2 * ey
v = a + 1         ; call v%printf(prefix='a + 1   = ')
v = 1 + a         ; call v%printf(prefix='1 + a   = ')
v = a - 0.5_R8P   ; call v%printf(prefix='a - 0.5 = ')
v = 0.5_R8P - a   ; call v%printf(prefix='0.5 - a = ')
endprogram plus_number
