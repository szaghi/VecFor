!< Device-readiness test for VecFor's `_oac` API (free subroutine entry points).
!<
!< Exercises the 7 operators FOSSIL's distance kernel needs (.dot., .cross.,
!< +, -, scalar *, assignment) inside an `!$acc parallel loop`, calling them
!< via the device-callable `_oac` entry points (not via TBP-generic operator
!< syntax) and asserting the device results are bit-exact against a serial
!< reference run on the same data computed via the host TBP operators.
!<
!< Why call the `_oac` forms explicitly: under `nvfortran 26.1`, TBP-generic
!< operator dispatch lowers to a vtable lookup, which `!$acc routine seq`
!< rejects (NVFORTRAN-W-0155, indirect procedure call). The `_oac` mirrors
!< take `type(vector_RPP)` arguments instead of `class(...)` and are the only
!< form reachable from a device region. Furthermore, all 6 vector-producing
!< `_oac` entry points are subroutines (intent(out) result arg) rather than
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
!< Acceptance: device run agrees bit-exact with serial reference run.
program vecfor_test_device_loop
use penf, only : R8P, I4P
use vecfor, only : vector_R8P,                &
                   assign_vector_R8P_oac,     &
                   crossproduct_R8P_oac,      &
                   dotproduct_R8P_oac,        &
                   R8P_mul_vector_R8P_oac,    &
                   vector_sub_vector_R8P_oac, &
                   vector_sum_vector_R8P_oac
implicit none

integer(I4P), parameter :: n = 256                    !< Loop length.
type(vector_R8P)        :: a(n), b(n)                 !< Inputs.
real(R8P)               :: dot_dev(n), dot_ref(n)     !< Outputs: .dot.
type(vector_R8P)        :: cross_dev(n), cross_ref(n) !< Outputs: .cross.
type(vector_R8P)        :: comb_dev(n), comb_ref(n)   !< Outputs: 2.0*a + b - a (mixed ops).
type(vector_R8P)        :: tmp1, tmp2                 !< Loop-private scratch.
real(R8P)               :: scalar
integer(I4P)            :: i
logical                 :: all_passed

scalar = 2.0_R8P

! Initialise inputs with reproducible non-trivial values.
do i = 1, n
   a(i) = vector_R8P(x=real(i, R8P), y=real(i + 1, R8P), z=real(i + 2, R8P))
   b(i) = vector_R8P(x=real(n - i, R8P), y=real(n - i + 1, R8P), z=real(n - i + 2, R8P))
enddo

! --- Device run (or serial if -acc absent: directives are inert) ---
! `tmp1`/`tmp2` chain the multi-step `comb = 2*a + b - a` expression: each
! `_oac` subroutine writes a private scratch, then the next subroutine reads
! it. They are `private` to the loop so each thread has its own pair.
!$acc parallel loop copyin(a, b, scalar) copyout(dot_dev, cross_dev, comb_dev) &
!$acc                private(tmp1, tmp2)
do i = 1, n
   dot_dev(i) = dotproduct_R8P_oac(a(i), b(i))
   call crossproduct_R8P_oac(a(i), b(i), cross_dev(i))
   call R8P_mul_vector_R8P_oac(scalar, a(i), tmp1)
   call vector_sum_vector_R8P_oac(tmp1, b(i), tmp2)
   call vector_sub_vector_R8P_oac(tmp2, a(i), tmp1)
   call assign_vector_R8P_oac(comb_dev(i), tmp1)
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

print "(A,L1)", "Are all tests passed? ", all_passed
if (.not. all_passed) error stop "vecfor_test_device_loop FAILED"
endprogram vecfor_test_device_loop
