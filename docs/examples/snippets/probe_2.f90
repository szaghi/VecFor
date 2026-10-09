program probe
!< Tutorial, chapter 2: edges, centroid, a moved, a scaled and a stretched copy of the tetrahedron.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: o     ! the origin
type(vector) :: p(4)  ! the vertices
type(vector) :: edge  ! an edge
type(vector) :: c     ! the centroid
type(vector) :: s(4)  ! the vertices of a copy
integer      :: i     ! counter

p(1) = o ; p(2) = ex ; p(3) = ey ; p(4) = ez
edge = p(4) - p(2)                    ! from p2 to p4
call edge%printf(prefix='edge p2->p4  = ')
edge = -edge                          ! the opposite edge
call edge%printf(prefix='edge p4->p2  = ')
c = o
do i = 1, 4
   c = c + p(i)
enddo
c = c / 4                             ! a vector divided by an integer
call c%printf(prefix='centroid     = ')
s = p + (2 * ex - 0.5_R8P * ez)       ! every vertex at once: + works on arrays of vectors
call s(4)%printf(prefix='moved p4     = ')
s = c + 2 * (p - c)                   ! twice as large, about the centroid
call s(4)%printf(prefix='scaled p4    = ')
s = p * (3 * ex + ey + ez)            ! vector * vector: component by component
call s(2)%printf(prefix='stretched p2 = ')
s(1) = p(1) + 1                       ! vector + number: the number is added to every component
call s(1)%printf(prefix='p1 + 1       = ')
endprogram probe
