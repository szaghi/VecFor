!as probe
!run probe_10-file probe && cat vertices.txt
program probe
!< Tutorial, chapter 10: printing, saving and loading the vertices.
use, intrinsic :: iso_fortran_env, only : int64
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector)       :: o        ! the origin
type(vector)       :: p(4)     ! the vertices
type(vector)       :: r(4)     ! the vertices read back
integer            :: u        ! a file
integer            :: i        ! counter
integer            :: ios      ! I/O status
character(len=200) :: msg      ! I/O message

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
!region printf
call p(2)%printf(prefix='p2 = ')
call p(2)%printf(prefix='p2 = [', sep='; ', suffix=']')
!endregion printf
!region unformatted
open(newunit=u, file='vertices.bin', form='unformatted', status='replace')
do i = 1, 4
   call p(i)%save_into_file(unit=u)          ! binary: the exact bits
enddo
rewind(u)
do i = 1, 4
   call r(i)%load_from_file(unit=u)
enddo
close(u)
print '(A,L1)', 'read back equal: ', all(r == p)
!endregion unformatted
!region formatted
open(newunit=u, file='vertices.txt', status='replace')
do i = 1, 4
   call p(i)%save_into_file(unit=u, fmt='(3F6.2)')
enddo
close(u)
!endregion formatted
!region stream
open(newunit=u, file='vertices.raw', access='stream', form='unformatted', status='replace')
do i = 1, 4
   call p(i)%save_into_file(unit=u)
enddo
print '(A,I0)', 'bytes per vector: ', o%iolen()
call r(1)%load_from_file(unit=u, pos=2 * int(o%iolen(), int64) + 1)   ! the third vector, straight away
call r(1)%printf(prefix='third vector = ')
!endregion stream
!region error
call r(1)%load_from_file(unit=u, pos=4 * int(o%iolen(), int64) + 1, iostat=ios, iomsg=msg)
print '(A,I0,2A)', 'reading past the end: iostat = ', ios, ', ', trim(msg)
close(u)
!endregion error
endprogram probe
