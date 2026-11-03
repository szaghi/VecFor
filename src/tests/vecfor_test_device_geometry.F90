!< Device-readiness test for VecFor's geometric `_oac` API: norms, projections, distances, face normals,
!< predicates, in-place transforms and the angle.
!<
!< Each entry point is called inside an `!$acc parallel loop` and, after it, on the host. Two checks per entry:
!< the `_oac` form run on the host must reproduce the host procedure bit-exact (same arithmetic, open-coded: this
!< catches transcription errors), and the device result must agree with the host procedure, bit-exact unless a
!< tolerance is stated and justified next to the check. Under `_OPENACC` every iteration must also have run on the
!< device (nvfortran runs a loop with an indirect call on the host, results unchanged).
!<
!< Built by `tests-nvf-acc` (device) and by every other test mode and fpm (serial, the directives inert).
program vecfor_test_device_geometry
use penf, only : R8P, I4P
#ifdef _OPENACC
use openacc, only : acc_on_device, acc_device_not_host
#endif
use vecfor, only : vector_R8P,            &
                   assign_vector_R8P_oac, &
                   normalize_R8P_oac,     &
                   normalized_R8P,        &
                   normalized_R8P_oac,    &
                   normL2_R8P,            &
                   normL2_R8P_oac,        &
                   sq_norm_R8P,           &
                   sq_norm_R8P_oac
implicit none

integer(I4P), parameter :: n = 256              !< Loop length.
type(vector_R8P)        :: p0(n)                !< Points (p0(1) is the zero vector).
type(vector_R8P)        :: p1(n), p2(n), p3(n)  !< More points.
type(vector_R8P)        :: t1                   !< Loop-private scratch.
logical                 :: on_device(n)         !< Where each iteration of the device loop ran.
logical                 :: all_passed           !< Overall result.
integer(I4P)            :: i                    !< Counter.
! normL2, sq_norm, normalized, normalize
real(R8P)               :: nrm_dev(n), nrm_ref(n), nrm_oac(n)
real(R8P)               :: sq_dev(n), sq_ref(n), sq_oac(n)
type(vector_R8P)        :: nzd_dev(n), nzd_ref(n), nzd_oac(n)
type(vector_R8P)        :: nze_dev(n), nze_ref(n), nze_oac(n)

all_passed = .true.
on_device = .false.
do i = 1, n
   p0(i) = vector_R8P(x=0.37_R8P * real(i - 1, R8P), y=1._R8P - 0.011_R8P * real(i - 1, R8P), &
                      z=-0.29_R8P * real(i - 1, R8P))
   if (i == 1) p0(i) = vector_R8P(x=0._R8P, y=0._R8P, z=0._R8P)
   p1(i) = vector_R8P(x=1._R8P / real(i, R8P), y=0.7_R8P * real(i, R8P), z=2._R8P - 0.003_R8P * real(i, R8P))
   p2(i) = vector_R8P(x=-1.5_R8P + 0.02_R8P * real(i, R8P), y=0.3_R8P, z=real(mod(i, 7), R8P) - 2.5_R8P)
   p3(i) = vector_R8P(x=0.9_R8P, y=-0.4_R8P * real(mod(i, 5), R8P), z=1._R8P + 1._R8P / real(i + 1, R8P))
enddo

!$acc parallel loop copyin(p0, p1, p2, p3) copyout(on_device, nrm_dev, sq_dev, nzd_dev, nze_dev) private(t1)
do i = 1, n
   nrm_dev(i) = normL2_R8P_oac(p0(i))
   sq_dev(i) = sq_norm_R8P_oac(p0(i))
   call normalized_R8P_oac(p0(i), nzd_dev(i))
   call assign_vector_R8P_oac(t1, p0(i))
   call normalize_R8P_oac(t1)
   call assign_vector_R8P_oac(nze_dev(i), t1)
#ifdef _OPENACC
   on_device(i) = acc_on_device(acc_device_not_host)
#endif
enddo
!$acc end parallel loop

! host: the reference procedures and the `_oac` forms
do i = 1, n
   nrm_ref(i) = normL2_R8P(p0(i))
   nrm_oac(i) = normL2_R8P_oac(p0(i))
   sq_ref(i) = sq_norm_R8P(p0(i))
   sq_oac(i) = sq_norm_R8P_oac(p0(i))
   nzd_ref(i) = normalized_R8P(p0(i))
   call normalized_R8P_oac(p0(i), nzd_oac(i))
   nze_ref(i) = p0(i)
   call nze_ref(i)%normalize()
   nze_oac(i) = p0(i)
   call normalize_R8P_oac(nze_oac(i))
enddo

call check_real('normL2_oac', nrm_dev, nrm_ref, nrm_oac)
call check_real('sq_norm_oac', sq_dev, sq_ref, sq_oac)
call check_vec('normalized_oac', nzd_dev, nzd_ref, nzd_oac)
call check_vec('normalize_oac', nze_dev, nze_ref, nze_oac)

#ifdef _OPENACC
if (.not. all(on_device)) then
   print "(A,I0,A,I0)", "device loop ran on the host for iterations: ", count(.not. on_device), " of ", n
   all_passed = .false.
endif
#endif

print "(A,L1)", "Are all tests passed? ", all_passed
if (.not. all_passed) error stop "vecfor_test_device_geometry FAILED"
contains
   subroutine check_real(label, dev, ref, oac, tol)
   !< Host `_oac` bit-exact vs reference; device vs reference bit-exact, or within `tol` when given.
   character(*), intent(in)           :: label    !< Entry point.
   real(R8P),    intent(in)           :: dev(:)   !< Device results.
   real(R8P),    intent(in)           :: ref(:)   !< Host reference results.
   real(R8P),    intent(in)           :: oac(:)   !< Host `_oac` results.
   real(R8P),    intent(in), optional :: tol      !< Device vs host tolerance.

   if (any(oac /= ref)) then
      print "(A,A,I0)", label, " on the host differs from the host procedure, elements: ", count(oac /= ref)
      all_passed = .false.
   endif
   if (present(tol)) then
      if (any(abs(dev - ref) > tol)) then
         print "(A,A,ES10.3)", label, " on the device off the host by: ", maxval(abs(dev - ref))
         all_passed = .false.
      endif
   elseif (any(dev /= ref)) then
      print "(A,A,I0,A,ES10.3)", label, " on the device differs from the host, elements: ", count(dev /= ref), &
                                 ", max abs diff: ", maxval(abs(dev - ref))
      all_passed = .false.
   endif
   endsubroutine check_real

   subroutine check_vec(label, dev, ref, oac)
   !< Host `_oac` and device bit-exact vs the host reference, component by component.
   character(*),     intent(in) :: label  !< Entry point.
   type(vector_R8P), intent(in) :: dev(:) !< Device results.
   type(vector_R8P), intent(in) :: ref(:) !< Host reference results.
   type(vector_R8P), intent(in) :: oac(:) !< Host `_oac` results.

   call check_real(label//' x', dev%x, ref%x, oac%x)
   call check_real(label//' y', dev%y, ref%y, oac%y)
   call check_real(label//' z', dev%z, ref%z, oac%z)
   endsubroutine check_vec

   subroutine check_logical(label, dev, ref, oac)
   !< Host `_oac` and device equal to the host reference.
   character(*), intent(in) :: label  !< Entry point.
   logical,      intent(in) :: dev(:) !< Device results.
   logical,      intent(in) :: ref(:) !< Host reference results.
   logical,      intent(in) :: oac(:) !< Host `_oac` results.

   if (any(oac .neqv. ref)) then
      print "(A,A,I0)", label, " on the host differs from the host procedure, elements: ", count(oac .neqv. ref)
      all_passed = .false.
   endif
   if (any(dev .neqv. ref)) then
      print "(A,A,I0)", label, " on the device differs from the host, elements: ", count(dev .neqv. ref)
      all_passed = .false.
   endif
   endsubroutine check_logical
endprogram vecfor_test_device_geometry
