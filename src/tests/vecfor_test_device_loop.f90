!< Device-readiness test for VecFor pure/elemental procedures.
!<
!< Exercises the operators FOSSIL's distance kernel needs (.dot., .cross.,
!< +, -, scalar *) inside an `!$acc parallel loop`, asserting the device
!< results are bit-exact against a serial reference run on the same data.
!<
!< Built by VecFor mode `tests-nvf-acc` (the device-target nvfortran build).
!< Also compiles cleanly under `tests-gnu` / `tests-intel` -- the !$acc
!< directives are inert comment-directives without -acc, so the test runs
!< serially there and the device-vs-serial comparison degenerates to
!< serial-vs-serial. That keeps the test in every test build, not just nvf.
!<
!< Acceptance: device run agrees bit-exact with serial run.
!< Filed under: szaghi/FOSSIL#20 Step 1.
program vecfor_test_device_loop
use penf, only : R8P, I4P
use vecfor, only : vector_R8P
implicit none

integer(I4P), parameter :: n = 256                    !< Loop length.
type(vector_R8P)        :: a(n), b(n)                 !< Inputs.
real(R8P)               :: dot_dev(n), dot_ref(n)     !< Outputs: .dot.
type(vector_R8P)        :: cross_dev(n), cross_ref(n) !< Outputs: .cross.
type(vector_R8P)        :: comb_dev(n), comb_ref(n)   !< Outputs: 2.0*a + b - a (mixed ops).
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
!$acc parallel loop copyin(a, b, scalar) copyout(dot_dev, cross_dev, comb_dev)
do i = 1, n
   dot_dev(i)   = a(i) .dot. b(i)
   cross_dev(i) = a(i) .cross. b(i)
   comb_dev(i)  = scalar * a(i) + b(i) - a(i)
enddo
!$acc end parallel loop

! --- Serial reference run on the host ---
do i = 1, n
   dot_ref(i)   = a(i) .dot. b(i)
   cross_ref(i) = a(i) .cross. b(i)
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
