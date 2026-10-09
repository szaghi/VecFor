!run direct_access direct_access
program direct_access
!< Cookbook: a direct access file of vectors, its record length from iolen.
use penf, only : R8P
use vecfor, only : ex, ey, iolen, vector
implicit none
type(vector) :: v
integer      :: u, i

open(newunit=u, file='points.dat', access='direct', form='unformatted', recl=iolen(v), status='replace')
do i = 1, 10
   v = i * ex - i * ey
   write(u, rec=i) v%x, v%y, v%z                    ! save_into_file has no rec=: write the components
enddo
read(u, rec=4) v%x, v%y, v%z
call v%printf(prefix='record 4: ')
close(u)
endprogram direct_access
