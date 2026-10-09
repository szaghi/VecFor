!run binary_file binary_file
program binary_file
!< Cookbook: vectors saved to and loaded from an unformatted file: the exact bits.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v, w
integer      :: u

v = ex / 3 + ey / 7 - ez / 11
open(newunit=u, file='v.bin', form='unformatted', status='replace')
call v%save_into_file(unit=u)
rewind(u)
call w%load_from_file(unit=u)
close(u)
print '(A,L1)', 'loaded == saved: ', w == v
call w%printf(prefix='w = ')
endprogram binary_file
