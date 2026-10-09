open(newunit=u, file='vertices.raw', access='stream', form='unformatted', status='replace')
do i = 1, 4
   call p(i)%save_into_file(unit=u)
enddo
print '(A,I0)', 'bytes per vector: ', o%iolen()
call r(1)%load_from_file(unit=u, pos=2 * int(o%iolen(), int64) + 1)   ! the third vector, straight away
call r(1)%printf(prefix='third vector = ')
