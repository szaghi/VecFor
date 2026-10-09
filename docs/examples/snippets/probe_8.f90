program probe
!< Tutorial, chapter 8: many points at once, the volume of the tetrahedron counted on a grid.
use penf, only : R8P
use vecfor, only : ex, ey, ez, face_normal3, normL2, vector
implicit none
integer, parameter        :: n = 40       ! grid points per direction
type(vector)              :: o            ! the origin
type(vector)              :: p(4)         ! the vertices
integer                   :: face(3,4)    ! the vertices of each face, counter-clockwise seen from outside
type(vector)              :: normal(4)    ! the unit normals of the faces
type(vector), allocatable :: g(:)         ! the grid points, at the centres of n**3 cells of the unit cube
logical,      allocatable :: inside(:)    ! is each grid point inside?
real(R8P),    allocatable :: dist(:)      ! signed distances to a face
integer                   :: i, j, k, f   ! counters

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
face = reshape([1,3,2, 1,2,4, 1,4,3, 2,3,4], [3,4])
normal = face_normal3(pt1=p(face(1,:)), pt2=p(face(2,:)), pt3=p(face(3,:)), norm='y')   ! four faces, one call
print '(A,4F8.4)', 'x of the normals ', normal%x
print '(A,4F8.4)', 'their lengths    ', normL2(normal)
allocate(g(n**3))
do k = 1, n
   do j = 1, n
      do i = 1, n
         g(i + n * (j - 1) + n**2 * (k - 1)) = ((i - 0.5_R8P) * ex + (j - 0.5_R8P) * ey + (k - 0.5_R8P) * ez) / n
      enddo
   enddo
enddo
allocate(inside(size(g)), source=.true.)
do f = 1, 4
   dist = g%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))   ! every point, one call
   inside = inside .and. dist <= 0._R8P
enddo
print '(A,I0,A,I0)', 'points inside    ', count(inside), ' of ', size(g)
print '(A,F8.4,A,F8.4)', 'volume estimate  ', count(inside) / real(size(g), R8P), ', exact', 1._R8P / 6
print '(A,I0)', 'points within 0.5 of the origin  ', count(g < 0.5_R8P)
i = maxloc(normL2(g), dim=1)
print '(A,3F8.4)', 'the farthest point from the origin', g(i)%x, g(i)%y, g(i)%z
print '(A,L1)', 'g(1) shorter than g(2): ', g(1) < g(2)
endprogram probe
