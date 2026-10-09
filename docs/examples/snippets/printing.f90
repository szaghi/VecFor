program printing
!< Cookbook: printing a vector, with a prefix, a separator and a suffix, on any unit.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v
integer      :: u, ios

v = 0.5_R8P * ex - 2 * ey + ez / 3
call v%printf
call v%printf(prefix='v = (', sep=', ', suffix=')')
call v%printf(prefix='', sep=' ')
print '(A,3F8.3)', 'a format of your own:', v%x, v%y, v%z
open(newunit=u, file='vector.txt', status='replace')
call v%printf(unit=u, prefix='in a file: ', iostat=ios)
close(u)
endprogram printing
