program scaling
!< Cookbook: a vector times or divided by a number, of any integer or real kind, on either side of *.
use penf, only : I8P, R4P, R8P
use vecfor, only : ex, ey, vector
implicit none
type(vector) :: a, v

a = 2 * ex + 4 * ey
v = 3 * a        ; call v%printf(prefix='3 * a      = ')
v = a * 0.5_R8P  ; call v%printf(prefix='a * 0.5    = ')
v = a / 4        ; call v%printf(prefix='a / 4      = ')
v = 2_I8P * a    ; call v%printf(prefix='2_I8P * a  = ')
v = a * 0.1_R4P  ; call v%printf(prefix='a * 0.1_R4P = ')
v = a * 0.1_R8P  ; call v%printf(prefix='a * 0.1_R8P = ')
endprogram scaling
