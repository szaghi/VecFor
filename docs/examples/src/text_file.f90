!run text_file text_file && cat points.txt
program text_file
!< Cookbook: vectors saved to and loaded from a text file, with a format.
use penf, only : R8P
use vecfor, only : ex, ey, ez, normL2, vector
implicit none
type(vector) :: p(3), q
integer      :: u, i

p = [ex, 2 * ey, ex + ey + ez / 3]
open(newunit=u, file='points.txt', status='replace')
do i = 1, 3
   call p(i)%save_into_file(unit=u, fmt='(3F10.5)')
enddo
rewind(u)
do i = 1, 3
   call q%load_from_file(unit=u, fmt='(3F10.5)')
   print '(A,I0,A,L1,A,ES8.1)', 'point ', i, ' read back equal: ', q == p(i), ', difference ', normL2(q - p(i))
enddo
close(u)
endprogram text_file
