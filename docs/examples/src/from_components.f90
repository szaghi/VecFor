!run from_components from_components
program from_components
!< Cookbook: a vector from its components.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: a, b, c, d

a%x = 1._R8P ; a%y = 2._R8P ; a%z = 3._R8P   ! component by component
b = 1 * ex + 2 * ey + 3 * ez                  ! from the versors
d = vector(1._R8P, 2._R8P, 3._R8P)            ! the structure constructor: x, y, z
call a%printf(prefix='a = ')
call b%printf(prefix='b = ')
call d%printf(prefix='d = ')
call c%printf(prefix='c = ')                  ! never set: (0, 0, 0)
endprogram from_components
