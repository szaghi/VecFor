c = o
do i = 1, 4
   c = c + p(i)
enddo
c = c / 4                             ! a vector divided by an integer
call c%printf(prefix='centroid     = ')
