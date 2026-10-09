!as probe
!run probe_11 probe
program probe
!< Tutorial, chapter 11: the signed distances of many points to the slanted face, on the GPU.
use penf, only : R8P
use vecfor, only : assign_vector_oac, crossproduct_oac, dotproduct_oac, ex, ey, ez, R8P_mul_vector_oac, vector, &
                   vector_mul_R8P_oac, vector_sub_vector_oac, vector_sum_vector_oac
implicit none
integer, parameter :: n = 100000 ! points
type(vector)       :: p(4)       ! the vertices
type(vector)       :: g(n)       ! the points
type(vector)       :: s12, s13   ! two edges of the slanted face
type(vector)       :: nrm        ! its normal
type(vector)       :: r          ! from the face to a point
type(vector)       :: t          ! a temporary
real(R8P)          :: d(n)       ! signed distances, on the device
real(R8P)          :: h(n)       ! signed distances, on the host
integer            :: i          ! counter

p(2) = ex ; p(3) = ey ; p(4) = ez
do i = 1, n
   g(i) = (real(mod(i, 97), R8P) * ex + real(mod(i, 89), R8P) * ey + real(mod(i, 83), R8P) * ez) / 50
enddo
!region device
!$acc parallel loop copyin(g, p) copyout(d) private(s12, s13, nrm, r, t)
do i = 1, n
   call vector_sub_vector_oac(p(3), p(2), s12)
   call vector_sub_vector_oac(p(4), p(2), s13)
   call crossproduct_oac(s12, s13, nrm)
   call vector_mul_R8P_oac(nrm, 1._R8P / sqrt(dotproduct_oac(nrm, nrm)), t)   ! the unit normal
   call assign_vector_oac(nrm, t)
   call R8P_mul_vector_oac(-1._R8P, p(2), t)
   call vector_sum_vector_oac(g(i), t, r)                                      ! r = g(i) - p(2)
   d(i) = dotproduct_oac(nrm, r)
enddo
!endregion device
!region host
h = g%distance_to_plane(pt1=p(2), pt2=p(3), pt3=p(4))
print '(A,I0,A)', 'distances of ', n, ' points'
print '(A,I0)',    'points outside            ', count(d > 0._R8P)
print '(A,ES9.1)', 'largest difference to host', maxval(abs(d - h))
!endregion host
endprogram probe
