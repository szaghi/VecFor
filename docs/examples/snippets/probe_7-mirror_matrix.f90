m = mirror_matrix(normal=ex - ey)
s = p
do i = 1, 4
   call s(i)%mirror(matrix=m)
   call s(i)%mirror(matrix=m)                 ! twice: back where it was
enddo
call show('mirrored twice', s)
