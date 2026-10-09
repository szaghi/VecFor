!as probe
!run probe_7 probe
program probe
!< Tutorial, chapter 7: the tetrahedron rotated and mirrored.
use penf, only : R8P
use vecfor, only : ex, ey, ez, face_normal3, mirror_matrix, rotation_matrix, vector
implicit none
type(vector) :: o           ! the origin
type(vector) :: p(4)        ! the vertices
type(vector) :: s(4)        ! the vertices of a copy
integer      :: face(3,4)   ! the vertices of each face, counter-clockwise seen from outside
real(R8P)    :: pi          ! pi
real(R8P)    :: r(3,3)      ! a rotation matrix
real(R8P)    :: m(3,3)      ! a mirror matrix
integer      :: i           ! counter

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
face = reshape([1,3,2, 1,2,4, 1,4,3, 2,3,4], [3,4])
pi = acos(-1._R8P)
!region rotate
s = p
do i = 1, 4
   call s(i)%rotate(axis=ez, angle=pi / 2)     ! a quarter turn about z, counter-clockwise
enddo
call show('rotated about z', s)
!endregion rotate
!region matrix
r = rotation_matrix(axis=ex + ey + ez, angle=2 * pi / 3)
do i = 1, 4
   s(i) = r .matrix. p(i)                     ! a third of a turn about the diagonal
enddo
call show('rotated about (1,1,1)', s)
print '(A,F8.4)', 'volume ', volume(s)
!endregion matrix
!region mirror
s = p
do i = 1, 4
   call s(i)%mirror(normal=ex - ey)          ! mirrored across the plane x = y
enddo
call show('mirrored across x = y', s)
print '(A,F8.4)', 'volume ', volume(s)
!endregion mirror
!region mirror_matrix
m = mirror_matrix(normal=ex - ey)
s = p
do i = 1, 4
   call s(i)%mirror(matrix=m)
   call s(i)%mirror(matrix=m)                 ! twice: back where it was
enddo
call show('mirrored twice', s)
!endregion mirror_matrix

contains
   subroutine show(title, v)
   !< Print a title and the vertices, rounded to 4 decimals.
   character(*), intent(in) :: title ! What the vertices are.
   type(vector), intent(in) :: v(:)  ! The vertices.
   integer                  :: j     ! Counter.

   print '(A)', title
   do j = 1, size(v)
      print '(A,I0,3F8.4)', '  p', j, v(j)%x, v(j)%y, v(j)%z
   enddo
   endsubroutine show

   function volume(v) result(vol)
   !< The volume of the tetrahedron of vertices v, by the divergence theorem (chapter 4).
   type(vector), intent(in) :: v(4) ! The vertices.
   real(R8P)                :: vol  ! The volume.
   type(vector)             :: n    ! The normal of a face.
   integer                  :: f    ! Counter.

   vol = 0._R8P
   do f = 1, 4
      n = face_normal3(pt1=v(face(1,f)), pt2=v(face(2,f)), pt3=v(face(3,f)))
      vol = vol + (((v(face(1,f)) + v(face(2,f)) + v(face(3,f))) / 3) .dot. n) / 3
   enddo
   endfunction volume
endprogram probe
