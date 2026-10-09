!run io_error io_error
program io_error
!< Cookbook: an I/O error caught, instead of stopping the program.
use vecfor, only : vector
implicit none
type(vector)       :: v
integer            :: u, ios
character(len=200) :: msg

open(newunit=u, file='bad.txt', status='replace')
write(u, '(A)') '    1.0000    2.0000      oops'
rewind(u)
call v%load_from_file(unit=u, fmt='(3F10.4)', iostat=ios, iomsg=msg)
print '(A,I0)', 'iostat: ', ios
print '(2A)',   'iomsg:  ', trim(msg)
call v%load_from_file(unit=u, fmt='(3F10.4)', iostat=ios, iomsg=msg)
print '(A,I0,2A)', 'at the end: iostat ', ios, ', ', trim(msg)
close(u)
endprogram io_error
