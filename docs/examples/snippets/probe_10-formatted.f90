open(newunit=u, file='vertices.txt', status='replace')
do i = 1, 4
   call p(i)%save_into_file(unit=u, fmt='(3F6.2)')
enddo
close(u)
