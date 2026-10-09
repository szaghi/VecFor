s = p
do i = 1, 4
   call s(i)%rotate(axis=ez, angle=pi / 2)     ! a quarter turn about z, counter-clockwise
enddo
call show('rotated about z', s)
