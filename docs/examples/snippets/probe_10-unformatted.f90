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
