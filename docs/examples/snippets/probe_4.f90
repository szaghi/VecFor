program probe
!< Tutorial, chapter 4: the faces, their normals and areas, the surface and the volume of the tetrahedron.
use penf, only : R8P
use vecfor, only : ex, ey, ez, face_normal3, vector
implicit none
type(vector) :: o          ! the origin
type(vector) :: p(4)       ! the vertices
integer      :: face(3,4)  ! the vertices of each face
type(vector) :: n          ! the normal of a face
type(vector) :: c          ! the centroid of a face
real(R8P)    :: area       ! the surface of the tetrahedron
real(R8P)    :: volume     ! the volume of the tetrahedron
integer      :: f          ! counter

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
face(:,1) = [1, 3, 2]       ! counter-clockwise seen from outside: the normal points outward
face(:,2) = [1, 2, 4]
face(:,3) = [1, 4, 3]
face(:,4) = [2, 3, 4]
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
n = face_normal3(pt1=p(2), pt2=p(3), pt3=p(4), norm='y')
call n%printf(prefix='unit normal of face 4 = ')
n = face_normal3(pt1=p(2), pt2=p(4), pt3=p(3), norm='y')
call n%printf(prefix='p3 and p4 swapped     = ')
endprogram probe
