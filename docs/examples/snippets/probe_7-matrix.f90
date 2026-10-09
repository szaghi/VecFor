r = rotation_matrix(axis=ex + ey + ez, angle=2 * pi / 3)
do i = 1, 4
   s(i) = r .matrix. p(i)                     ! a third of a turn about the diagonal
enddo
call show('rotated about (1,1,1)', s)
print '(A,F8.4)', 'volume ', volume(s)
