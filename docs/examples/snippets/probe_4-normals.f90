area = 0._R8P
volume = 0._R8P
do f = 1, 4
   n = face_normal3(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))   ! its length is the face area
   c = (p(face(1,f)) + p(face(2,f)) + p(face(3,f))) / 3
   area = area + n%normL2()
   volume = volume + (c .dot. n) / 3                                        ! divergence theorem
   print '(A,I0,A,3F8.4,A,F8.4)', 'face ', f, ': normal', n%x, n%y, n%z, ', area', n%normL2()
enddo
print '(A,F8.4)', 'surface ', area
print '(A,F8.4,A,F8.4)', 'volume  ', volume, ', 1/6 =', 1._R8P / 6
