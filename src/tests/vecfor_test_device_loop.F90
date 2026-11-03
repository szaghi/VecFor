!< Device-readiness test for VecFor's `_dev` API (free subroutine entry points).
!<
!< Exercises the 7 operators FOSSIL's distance kernel needs (.dot., .cross.,
!< +, -, scalar *, assignment), the rotation matrix (`rotation_matrix_dev`) and
!< the mirror matrix (`mirror_matrix_dev`) and the matrix product
!< (`matrixproduct_dev`)
!< inside an `!$acc parallel loop`, calling them
!< via the device-callable `_dev` entry points (not via TBP-generic operator
!< syntax) and asserting the device results are bit-exact against a serial
!< reference run on the same data computed via the host TBP operators.
!<
!< Why call the `_dev` forms explicitly: under `nvfortran 26.1`, TBP-generic
!< operator dispatch lowers to a vtable lookup, which `!$acc routine seq`
!< rejects (NVFORTRAN-W-0155, indirect procedure call). The `_dev` mirrors
!< take `type(vector_RPP)` arguments instead of `class(...)` and are the only
!< form reachable from a device region. Furthermore, all 6 vector-producing
!< `_dev` entry points are subroutines (intent(out) result arg) rather than
!< functions, because nvfortran 26.1 (a) routes any `type(vector) = ...` LHS
!< through the user-defined assign TBP (rejected on device) and (b) shares
!< the function-return temp across threads when the function returns a
!< derived type from a parallel-loop body (constant garbage). See szaghi/
!< VecFor#20 and VecFor's CLAUDE.md for the contract.
!<
!< Built by VecFor mode `tests-nvf-acc` (the device-target nvfortran build).
!< Also compiles cleanly under `tests-gnu` / `tests-intel` -- the !$acc
!< directives are inert comment-directives without -acc, so the test runs
!< serially there and the device-vs-serial comparison degenerates to
!< serial-vs-serial. That keeps the test in every test build, not just nvf.
!<
!< Acceptance: device run agrees bit-exact with serial reference run (within
!< 4 epsilon for the rotation matrix, whose sin/cos differ in the last bit on
!< the device; on the host its `_dev` form must be bit-exact) and, when
!< compiled with OpenACC (`_OPENACC`), every iteration of the loop ran on the
!< device. The second check exists because nvfortran (26.1 and 26.9) compiles
!< an indirect call in a compute region with a W-0155 warning and then runs the
!< loop on the host: results stay correct, so a results-only test would pass
!< without touching the GPU.
program vecfor_test_device_loop
use penf, only : R8P, I4P
#ifdef _OPENACC
use openacc, only : acc_on_device, acc_device_not_host
#endif
use vecfor, only : vector_R8P,                &
                   assign_vector_R8P_dev,     &
                   crossproduct_R8P_dev,      &
                   dotproduct_R8P_dev,        &
                   matrixproduct_R8P_dev,     &
                   mirror_matrix_R8P,         &
                   mirror_matrix_R8P_dev,     &
                   R8P_mul_vector_R8P_dev,    &
                   rotation_matrix_R8P,       &
                   rotation_matrix_R8P_dev,   &
                   vector_sub_vector_R8P_dev, &
                   vector_sum_vector_R8P_dev
implicit none

integer(I4P), parameter :: n = 256                    !< Loop length.
type(vector_R8P)        :: a(n), b(n)                 !< Inputs.
real(R8P)               :: dot_dev(n), dot_ref(n)     !< Outputs: .dot.
type(vector_R8P)        :: cross_dev(n), cross_ref(n) !< Outputs: .cross.
type(vector_R8P)        :: comb_dev(n), comb_ref(n)   !< Outputs: 2.0*a + b - a (mixed ops).
type(vector_R8P)        :: tmp1, tmp2                 !< Loop-private scratch.
real(R8P)               :: angle(n)                   !< Rotation angles.
real(R8P)               :: rot_dev(3,3,n)             !< Outputs: rotation matrices about a(i) by angle(i).
real(R8P)               :: rot_ref(3,3,n)             !< Reference rotation matrices (host function).
real(R8P)               :: rot_hst(3,3,n)             !< Rotation matrices of the `_dev` subroutine run on the host.
real(R8P), parameter    :: rot_tol = 4 * epsilon(1._R8P) !< Device vs host tolerance of the rotation matrices.
real(R8P)               :: m(3,3)                     !< Loop-private matrix.
real(R8P)               :: mir_dev(3,3,n)             !< Outputs: mirror matrices across the plane of normal b(i).
real(R8P)               :: mir_ref(3,3,n)             !< Reference mirror matrices (host function).
real(R8P)               :: mir_hst(3,3,n)             !< Mirror matrices of the `_dev` subroutine run on the host.
real(R8P)               :: mat(3,3,n)                 !< Matrices of the matrix product.
type(vector_R8P)        :: matp_dev(n)                !< Outputs: mat(:,:,i) .matrix. a(i).
type(vector_R8P)        :: matp_ref(n)                !< Reference matrix products (host TBP).
type(vector_R8P)        :: matp_hst(n)                !< Matrix products of the `_dev` subroutine run on the host.
integer(I4P)            :: j                          !< Counter.
real(R8P)               :: matp_bound(3,n)            !< Rounding bound of each component of the matrix products.
real(R8P)               :: scalar
integer(I4P)            :: i
logical                 :: on_device(n)               !< Where each iteration of the device loop ran.
logical                 :: all_passed

scalar = 2.0_R8P
on_device = .false.

! Initialise inputs with reproducible non-trivial values.
do i = 1, n
   a(i) = vector_R8P(x=real(i, R8P), y=real(i + 1, R8P), z=real(i + 2, R8P))
   b(i) = vector_R8P(x=real(n - i, R8P), y=real(n - i + 1, R8P), z=real(n - i + 2, R8P))
   angle(i) = 0.0125_R8P * real(i, R8P)
   do j = 1, 9
      mat(mod(j - 1, 3) + 1, (j - 1) / 3 + 1, i) = real(j, R8P) / real(i + 3, R8P) - 0.5_R8P
   enddo
enddo

! --- Device run (or serial if -acc absent: directives are inert) ---
! `tmp1`/`tmp2` chain the multi-step `comb = 2*a + b - a` expression: each
! `_dev` subroutine writes a private scratch, then the next subroutine reads
! it. They are `private` to the loop so each thread has its own pair.
!$acc parallel loop copyin(a, b, scalar, angle, mat) &
!$acc                copyout(dot_dev, cross_dev, comb_dev, rot_dev, mir_dev, matp_dev, on_device) &
!$acc                private(tmp1, tmp2, m)
do i = 1, n
   dot_dev(i) = dotproduct_R8P_dev(a(i), b(i))
   call crossproduct_R8P_dev(a(i), b(i), cross_dev(i))
   call R8P_mul_vector_R8P_dev(scalar, a(i), tmp1)
   call vector_sum_vector_R8P_dev(tmp1, b(i), tmp2)
   call vector_sub_vector_R8P_dev(tmp2, a(i), tmp1)
   call assign_vector_R8P_dev(comb_dev(i), tmp1)
   call rotation_matrix_R8P_dev(a(i), angle(i), m)
   rot_dev(:,:,i) = m
   call mirror_matrix_R8P_dev(b(i), m)
   mir_dev(:,:,i) = m
   m = mat(:,:,i)
   call matrixproduct_R8P_dev(m, a(i), tmp1)
   call assign_vector_R8P_dev(matp_dev(i), tmp1)
#ifdef _OPENACC
   on_device(i) = acc_on_device(acc_device_not_host)
#endif
enddo
!$acc end parallel loop

! --- Serial reference run on the host ---
! Uses the by-name TBP form (`a%dotproduct(b)`) rather than the generic
! operator form (`a .dot. b`). nvfortran 26.1 misanalyses `arr(i) .dot.
! arr(i)` even outside any device region -- the `elemental` TBP-generic is
! incorrectly flagged "Vector expression used where scalar expression
! required" (NVFORTRAN-S-0083). The by-name TBP path lowers correctly.
do i = 1, n
   dot_ref(i)   = a(i)%dotproduct(b(i))
   cross_ref(i) = a(i)%crossproduct(b(i))
   comb_ref(i)  = scalar * a(i) + b(i) - a(i)
   rot_ref(:,:,i) = rotation_matrix_R8P(a(i), angle(i))
   call rotation_matrix_R8P_dev(a(i), angle(i), rot_hst(:,:,i))
   mir_ref(:,:,i) = mirror_matrix_R8P(b(i))
   call mirror_matrix_R8P_dev(b(i), mir_hst(:,:,i))
   matp_ref(i) = a(i)%matrixproduct(mat(:,:,i))
   call matrixproduct_R8P_dev(mat(:,:,i), a(i), matp_hst(i))
enddo

! --- Compare bit-exact ---
all_passed = .true.
do i = 1, n
   if (dot_dev(i)     /= dot_ref(i))       all_passed = .false.
   if (cross_dev(i)%x /= cross_ref(i)%x)   all_passed = .false.
   if (cross_dev(i)%y /= cross_ref(i)%y)   all_passed = .false.
   if (cross_dev(i)%z /= cross_ref(i)%z)   all_passed = .false.
   if (comb_dev(i)%x  /= comb_ref(i)%x)    all_passed = .false.
   if (comb_dev(i)%y  /= comb_ref(i)%y)    all_passed = .false.
   if (comb_dev(i)%z  /= comb_ref(i)%z)    all_passed = .false.
enddo

! Rotation matrices. On the host the `_dev` subroutine must reproduce the host function bit-exact (same arithmetic,
! open-coded). Device vs host cannot be bit-exact: the device sin/cos differ from the host ones in the last bit (46 of
! these 256 cos and 52 sin, nvfortran 26.9) and the device contracts multiply-adds into FMAs. Measured: at most 1 ulp
! of 1.0 (2.2e-16) on 26.1 and 26.9; the elements of a rotation matrix are at most 1 in magnitude, so an absolute
! tolerance of a few epsilon bounds them.
if (any(rot_hst /= rot_ref)) then
   print "(A,I0)", "rotation_matrix_dev differs from rotation_matrix on the host, elements: ", &
                   count(rot_hst /= rot_ref)
   all_passed = .false.
endif
if (any(abs(rot_dev - rot_ref) > rot_tol)) then
   print "(A,ES10.3)", "rotation_matrix_dev on the device off the host by: ", maxval(abs(rot_dev - rot_ref))
   all_passed = .false.
endif

! Mirror matrices: no transcendental intrinsics (sqrt is correctly rounded), bit-exact on the host and on the device.
if (any(mir_hst /= mir_ref)) then
   print "(A,I0)", "mirror_matrix_dev differs from mirror_matrix on the host, elements: ", count(mir_hst /= mir_ref)
   all_passed = .false.
endif
if (any(mir_dev /= mir_ref)) then
   print "(A,I0,A,ES10.3)", "mirror_matrix_dev on the device differs from the host, elements: ", &
                            count(mir_dev /= mir_ref), ", max abs diff: ", maxval(abs(mir_dev - mir_ref))
   all_passed = .false.
endif

! Matrix products. The host TBP calls matmul, whose order of summation is the compiler's: gfortran 16.2 sums
! differently from the open-coded `_dev` form (134 of these 256 products differ, below 1 ulp), nvfortran 26.1 and 26.9
! agree bit-exact on the host and on the device. Two orders of a 3-term sum differ by at most 2*gamma_3 times the sum
! of the absolute terms, gamma_3 ~ 3*epsilon: the bound below; a transcription error (index, sign) is far above it.
do i = 1, n
   matp_bound(:,i) = 6 * epsilon(1._R8P) * matmul(abs(mat(:,:,i)), abs([a(i)%x, a(i)%y, a(i)%z]))
enddo
if (any(abs(matp_hst%x - matp_ref%x) > matp_bound(1,:) .or. &
        abs(matp_hst%y - matp_ref%y) > matp_bound(2,:) .or. &
        abs(matp_hst%z - matp_ref%z) > matp_bound(3,:))) then
   print "(A)", "matrixproduct_dev differs from matrixproduct on the host beyond the rounding bound"
   all_passed = .false.
endif
if (any(abs(matp_dev%x - matp_ref%x) > matp_bound(1,:) .or. &
        abs(matp_dev%y - matp_ref%y) > matp_bound(2,:) .or. &
        abs(matp_dev%z - matp_ref%z) > matp_bound(3,:))) then
   print "(A)", "matrixproduct_dev on the device differs from the host beyond the rounding bound"
   all_passed = .false.
endif

#ifdef _OPENACC
if (.not. all(on_device)) then
   print "(A,I0,A,I0)", "device loop ran on the host for iterations: ", count(.not. on_device), " of ", n
   all_passed = .false.
endif
#endif

print "(A,L1)", "Are all tests passed? ", all_passed
if (.not. all_passed) error stop "vecfor_test_device_loop FAILED"
endprogram vecfor_test_device_loop
