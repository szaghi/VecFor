s = p
do i = 1, 4
   call s(i)%mirror(normal=ex - ey)          ! mirrored across the plane x = y
enddo
call show('mirrored across x = y', s)
print '(A,F8.4)', 'volume ', volume(s)
