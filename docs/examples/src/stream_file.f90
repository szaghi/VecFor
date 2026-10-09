!run stream_file stream_file
program stream_file
!< Cookbook: the n-th vector of a stream file, read straight away.
use, intrinsic :: iso_fortran_env, only : int64
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v
integer      :: u, i
integer      :: bytes

open(newunit=u, file='points.raw', access='stream', form='unformatted', status='replace')
do i = 1, 10
   v = i * ex + i**2 * ey
   call v%save_into_file(unit=u)
enddo
bytes = v%iolen()                                   ! the file storage units of one vector
print '(A,I0)', 'bytes per vector: ', bytes
call v%load_from_file(unit=u, pos=6 * int(bytes, int64) + 1)
call v%printf(prefix='vector 7: ')
close(u)
endprogram stream_file
